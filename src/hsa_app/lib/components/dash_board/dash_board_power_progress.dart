import 'package:flutter/material.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashBoardPowerProgress extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  final List<double> powerList;
  final int seconds;
  final double powerMax;

  const DashBoardPowerProgress(this.deviceTerminal, this.powerList,this.seconds,this.powerMax,{Key key, }) : super(key: key);
  
  @override
  _DashBoardPowerProgressState createState() => _DashBoardPowerProgressState();
}

class _DashBoardPowerProgressState extends State<DashBoardPowerProgress> with TickerProviderStateMixin{

  AnimationController controller;
  int seconds ;
  List<double> powerList;
  DeviceTerminal deviceTerminal;
  double powerMax = 0.0;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 2;

  void initAnimationController(int seconds ,DeviceTerminal deviceTerminal,List<double> powerList ) async {

    if(canPlayAnimationOnZero <= 0 && mounted ) {
       controller = AnimationController(vsync: this, duration: Duration(seconds: seconds));
       controller.value = 0;
       judgeStats(seconds,powerList);
       canPlayAnimationOnZero = 0;
    }
    canPlayAnimationOnZero --;

  }
  

  //整理判断状态
  void judgeStats(int seconds,List<double> powerList) async {
      
    if(this.powerMax > 0){
      controller = AnimationController(vsync: this, duration: Duration(seconds: seconds));
      controller?.forward();
    }
  }
  

  @override
  void initState() {

    super.initState();
    this.seconds = widget?.seconds ?? 5;
    this.deviceTerminal = widget?.deviceTerminal ?? DeviceTerminal();
    this.powerList = widget?.powerList ?? [0.0, 0.0];
    this.powerMax = widget?.powerMax ?? 0.0;
    initAnimationController(seconds,deviceTerminal,powerList);
    eventBird?.on('NEAREST_DATA', (dt){
      initAnimationController(seconds,deviceTerminal,powerList);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    eventBird?.off('NEAREST_DATA');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var powerList = widget?.powerList ?? [0.0, 0.0];
    judgeStats(seconds,powerList);
    return Center(
      child: getRadialTextAnnotation(),
    );
  }

   Widget getRadialTextAnnotation() {

     //最大功率
    this.powerMax = widget?.powerMax ?? 0.0;
    //前数据/最大功率
    var powerPencentOld  = RuntimeDataAdapter.caclulatePencent(powerList[0],powerMax) ?? 0.0;
    powerPencentOld =  fixDouble(powerPencentOld);
    //后数据/最大功率
    var powerPencentNew  = RuntimeDataAdapter.caclulatePencent(powerList[1],powerMax) ?? 0.0;
    powerPencentNew =  fixDouble(powerPencentNew);

    if(powerPencentNew > 1.3) {
      powerPencentNew = 1.3;
    }
    if(powerPencentOld > 1.3) {
      powerPencentOld = 1.3;
    }


    return  controller == null ? Container() : AnimatedBuilder(
      animation: controller,
      builder:  (context,child) => SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(showTicks: false,
            showLabels: false,
            startAngle: 180,
            endAngle: 110,
            radiusFactor:    0.68,
            axisLineStyle: AxisLineStyle(
                color: Colors.white12,
                thickness: 24, dashArray:  <double>[1.0, 2.6]
            ),
          ),
          RadialAxis(showTicks: false,
            showLabels: false,
            startAngle: 180,
            endAngle: 270 * powerPencentOld + (powerPencentNew - powerPencentOld) * 270 * controller.value - 180 ,
            radiusFactor:    0.68,
            axisLineStyle: AxisLineStyle(
              gradient:  SweepGradient(
                colors: [HexColor('4778f7'),HexColor('66f7f9'),],
                stops: <double>[0.25, 0.75]
              ),
              thickness: 24, dashArray:  <double>[1.0, 2.6]
            )
          ),
          RadialAxis(showTicks: false,
            showLabels: false,
            startAngle: 270 * powerPencentOld + (powerPencentNew - powerPencentOld) * 270 * controller.value - 180 - 4,
            endAngle: 270 * powerPencentOld + (powerPencentNew - powerPencentOld) * 270 * controller.value - 180,
            radiusFactor:    0.68,
            axisLineStyle: AxisLineStyle(
              gradient:  SweepGradient(
                colors: [HexColor('fff7f1ce'),
                        HexColor('fff7f1ce'),],
                stops: <double>[0.25, 0.75]
              ),
              thickness: 24, dashArray:  <double>[4.0, 0]
            )
          ),
        ]
      ),
    );
  }

  


  static double fixDouble(double old) {
    var source = old.toStringAsFixed(2);
    return double.parse(source);
  }
}

// class DashBoardPowerProgressPainter extends CustomPainter {

//   final DeviceTerminal deviceTerminal;
//   final AnimationController controller;
//   final AnimationController beyondController;
//   final AnimationController pinController;
//   final List<double> powerList;
//   final int seconds;

//   DashBoardPowerProgressPainter(this.deviceTerminal, this.powerList,  this.seconds,this.pinController,this.beyondController,  this.controller);
  

//   @override
//   void paint(Canvas canvas, Size size) {
    
//     //最大功率
//     var powerMax = deviceTerminal?.waterTurbine?.ratedPowerKW?.toDouble() ?? 0.0;
//     //前数据/最大功率
//     var powerPencentOld  = RuntimeDataAdapter.caclulatePencent(powerList[0],powerMax) ?? 0.0;
//     powerPencentOld =  fixDouble(powerPencentOld);
//     //后数据/最大功率
//     var powerPencentNew  = RuntimeDataAdapter.caclulatePencent(powerList[1],powerMax) ?? 0.0;
//     powerPencentNew =  fixDouble(powerPencentNew);

//     if(powerPencentNew > 1.3) {
//       powerPencentNew = 1.3;
//     }
//     if(powerPencentOld > 1.3) {
//       powerPencentOld = 1.3;
//     }

//     //指针起始位置
//     double pinStartAngle ;
//     //蓝色线起始
//     double blueStartAngle;
//     //蓝色线变化
//     double blueSweepAngle;
//     //蓝色线补充
//     double blueSweepAngleOld;
//     //红色线起始
//     double redStartAngle;
//     //红色线变化
//     double redSweepAngle;
//     //红色线补充
//     double redSweepAngleOld;

//     double timeScale;


//     //后数据>前数据(顺时针)
//     if(powerList[1] > powerList[0]){
//       //行动轨迹 + 初始角度 + 初始位置
//       //控制器*(后数据-前数据)*pi*1.5 + 前数据*pi*1.5 + (-pi)
//       pinStartAngle = fixDouble(pinController.value * (powerPencentNew - powerPencentOld) * pi * 1.5 
//                     + pi * 1.5 * powerPencentOld 
//                     + (- pi));
//       blueStartAngle = fixDouble(pi * 1.5 * powerPencentOld  + (- pi));    
//       blueSweepAngle = fixDouble(controller.value * (powerPencentNew - powerPencentOld) * pi * 1.5 );
//       blueSweepAngleOld =fixDouble(pi * 1.5 * powerPencentOld);  
      
//     }
//     //后数据<前数据(逆时针)
//     else if(powerList[1] < powerList[0]){
//       //行动轨迹(反向) + 初始角度 + 初始位置
//       //(1-控制器)*(前数据-后数据)*pi*1.5 + 后数据*pi*1.5 + (-pi)
//       pinStartAngle = fixDouble((1 - pinController.value) * (powerPencentOld - powerPencentNew) * pi * 1.5 
//                       + pi * 1.5 * powerPencentNew
//                       + (- pi));
//       blueStartAngle = fixDouble(pi * 1.5 * powerPencentNew  + (- pi));   
//       blueSweepAngle = fixDouble((1 - controller.value) * (powerPencentOld - powerPencentNew) * pi * 1.5  ); 
//       blueSweepAngleOld = fixDouble(pi * 1.5 * powerPencentNew);
//     }



//     // //后数据>前数据
//     // if(powerList[1] > powerList[0]){
//     //   //行动轨迹 + 初始角度 + 初始位置
//     //   //控制器*(后数据-前数据)*pi*1.5 + 前数据*pi*1.5 + (-pi)
//     //   pinStartAngle = pinController.value * (powerPencentNew - powerPencentOld) * pi * 1.5 
//     //                 + pi * 1.5 * powerPencentOld 
//     //                 + (- pi);
//     // }
//     // //后数据<前数据
//     // else if(powerList[1] < powerList[0]){
//     //   //行动轨迹(反向) + 初始角度 + 初始位置
//     //   //(1-控制器)*(前数据-后数据)*pi*1.5 + 后数据*pi*1.5 + (-pi)
//     //   pinStartAngle = (1 - pinController.value) * (powerPencentOld - powerPencentNew) * pi * 1.5 
//     //                   + pi * 1.5 * powerPencentNew
//     //                   + (- pi);
//     // }

//     // 真实功率补充
//     Paint paintPowerBlueOld= Paint();
//     paintPowerBlueOld
//       ..strokeCap = StrokeCap.butt
//       ..filterQuality = FilterQuality.high
//       ..isAntiAlias = true
//       ..strokeWidth = 24
//       ..style = PaintingStyle.stroke
//       ..shader = LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           HexColor('4778f7'),
//           HexColor('66f7f9'),
//         ],
//       ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));

//     Path bluePathOld = Path();
//     bluePathOld.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), -pi , blueSweepAngleOld);
//     // canvas.drawPath(bluePathOld,paintPowerBlueOld);
//     canvas.drawPath(dashPath(bluePathOld,dashArray: CircularIntervalList<double>(<double>[1.0, 2.6])),paintPowerBlueOld);

//     // 真实功率
//     Paint paintPowerBlue = Paint();
//     paintPowerBlue
//       ..color = Colors.transparent
//       ..strokeCap = StrokeCap.butt
//       ..filterQuality = FilterQuality.high
//       ..isAntiAlias = true
//       ..strokeWidth = 24
//       ..style = PaintingStyle.stroke
//       ..shader = LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           HexColor('4778f7'),
//           HexColor('66f7f9'),
//         ],
//       ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));

//     Path bluePath = Path();
//     bluePath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), blueStartAngle , blueSweepAngle);
//     canvas.drawPath(dashPath(bluePath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.6])),paintPowerBlue);

//     // 真实功率指针
//     Paint paintPowerPoint = Paint();
//     paintPowerPoint
//       ..strokeCap = StrokeCap.butt
//       ..filterQuality = FilterQuality.high
//       ..isAntiAlias = true
//       ..strokeWidth = 24
//       ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2)
//       ..style = PaintingStyle.stroke
//       ..shader = RadialGradient(
//         radius:1,
//         center:Alignment.center,
//         colors: [
//           HexColor('fff7f1ce'),
//           HexColor('fff7f1ce'),
//         ],
//       ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));
//     Rect rectPowerPoint = Rect.fromCircle(center: Offset(0, 0), radius: 54.0);
//     canvas.drawArc(rectPowerPoint, pinStartAngle, -0.1, false, paintPowerPoint);


//   //  // 超发
//   //  if(beyondPencentNew > 0) {

//     // Paint paintPowerRedOld = Paint();
//     // paintPowerRedOld
//     // ..strokeCap = StrokeCap.butt
//     // ..filterQuality = FilterQuality.high
//     // ..isAntiAlias = true
//     // ..strokeWidth = 24
//     // ..style = PaintingStyle.stroke
//     // ..shader = LinearGradient(
//     //   begin: Alignment.topLeft,
//     //   end: Alignment.bottomRight,
//     //   colors: [
//     //     HexColor('f8083a'),
//     //     HexColor('f8083a'),
//     //   ],
//     // ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));

//     // 超发进度条
//     // Path redPath = Path();
//     // //redPath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), 0.5 * pi ,beyondPencentNew * pi *  beyondController.value) ;
//     // canvas.drawPath(dashPath(redPath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5])),paintPowerRedOld);


//     // Paint paintPowerRed = Paint();
//     // paintPowerRed
//     // ..strokeCap = StrokeCap.butt
//     // ..filterQuality = FilterQuality.high
//     // ..isAntiAlias = true
//     // ..strokeWidth = 24
//     // ..style = PaintingStyle.stroke
//     // ..shader = LinearGradient(
//     //   begin: Alignment.topLeft,
//     //   end: Alignment.bottomRight,
//     //   colors: [
//     //     HexColor('f8083a'),
//     //     HexColor('f8083a'),
//     //   ],
//     // ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));

//     // // 超发进度条
//     // Path redPathNew = Path();
//     // //redPathNew.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), beyondPencentOld * pi * 0.5 *  beyondController.value ,beyondPencentNew * pi *  beyondController.value) ;
//     // canvas.drawPath(dashPath(redPathNew,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5])),paintPowerRed);
//   //  }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }

//   static double fixDouble(double old) {
//     var source = old.toStringAsFixed(2);
//     return double.parse(source);
//   }

// }