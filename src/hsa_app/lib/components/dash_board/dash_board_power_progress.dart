import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';
import 'package:path_drawing/path_drawing.dart';

class DashBoardPowerProgress extends StatefulWidget {

  final DeviceTerminal deviceTerminal;

  const DashBoardPowerProgress(this.deviceTerminal,{Key key}) : super(key: key);
  
  @override
  _DashBoardPowerProgressState createState() => _DashBoardPowerProgressState();
}

class _DashBoardPowerProgressState extends State<DashBoardPowerProgress> with TickerProviderStateMixin{

  AnimationController controller;
  AnimationController beyondController;

  void initAnimationController() async {
    controller       = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    beyondController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  void forwardAnimation() async {
    await Future.delayed(Duration(milliseconds:100));
    controller.forward();
  }

  void forwardAnimationBeyond() async {
    await Future.delayed(Duration(milliseconds:1500));
    beyondController.forward();
  }

  @override
  void initState() {
    initAnimationController();
    forwardAnimation();
    forwardAnimationBeyond();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    beyondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context,child) {
          return AnimatedBuilder(
            animation: beyondController,
            builder: (context,child) => CustomPaint(
            painter: DashBoardPowerProgressPainter(widget.deviceTerminal,controller,beyondController)),
          );
        }
      ),
    );
  }
}

class DashBoardPowerProgressPainter extends CustomPainter {

  final DeviceTerminal deviceTerminal;
  final AnimationController controller;
  final AnimationController beyondController;

  DashBoardPowerProgressPainter(this.deviceTerminal, this.controller, this.beyondController);
  
  @override
  void paint(Canvas canvas, Size size) {

    var powerNow = deviceTerminal?.nearestRunningData?.power?.toDouble() ?? 0.0;
    var powerMax = deviceTerminal?.waterTurbine?.ratedPowerKW?.toDouble() ?? 0.0;
    var powerPencent  = RuntimeDataAdapter.caclulatePencent(powerNow,powerMax) ?? 0.0;
    var beyondPencent = 0.0;

    if(powerPencent > 1.0) {
      beyondPencent = powerPencent - 1.0;
      powerPencent = 1.0;
      if(beyondPencent > 0.5) {
        beyondPencent = 0.5;
      }
    }

    // 真实功率
    Paint paintPowerBlue = Paint();
    paintPowerBlue
      ..strokeCap = StrokeCap.butt
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HexColor('4778f7'),
          HexColor('66f7f9'),
        ],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));

    Path bluePath = Path();
    bluePath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), -pi, (controller.value * powerPencent*1.5) * pi);
    canvas.drawPath(dashPath(bluePath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5])),paintPowerBlue);

    // 真实功率指针
    Paint paintPowerPoint = Paint();
    paintPowerPoint
      ..strokeCap = StrokeCap.butt
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 24
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2)
      ..style = PaintingStyle.stroke
      ..shader = RadialGradient(
        radius:1,
        center:Alignment.center,
        colors: [
          HexColor('fff7f1ce'),
          HexColor('fff7f1ce'),
        ],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));
    Rect rectPowerPoint = Rect.fromCircle(center: Offset(0, 0), radius: 54.0);
    canvas.drawArc(rectPowerPoint, (-pi + (controller.value * powerPencent*1.5) * pi), -0.1, false, paintPowerPoint);


   // 超发
   if(beyondPencent > 0) {
      Paint paintPowerRed = Paint();
      paintPowerRed
      ..strokeCap = StrokeCap.butt
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HexColor('f8083a'),
          HexColor('f8083a'),
        ],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));


    // 超发进度条
    Path redPath = Path();
    // 为了展现好看,超发部分 放大 3倍
    beyondPencent = beyondPencent * 3;
    redPath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), pi/2 ,beyondPencent * 1.0 * pi *  beyondController.value) ;
    canvas.drawPath(dashPath(redPath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5])),paintPowerRed);

    // 超发功率指针  暂停
    /*
    Paint beyondIndexPaint = Paint();
    beyondIndexPaint
      ..strokeCap = StrokeCap.butt
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 24
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2)
      ..style = PaintingStyle.stroke
      ..shader = RadialGradient(
        radius:1,
        center:Alignment.center,
        colors: [
          HexColor('fff7f1ce'),
          HexColor('fff7f1ce'),
        ],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 50.0));
      canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), (pi/2 + beyondPencent * 1.0 * pi *  beyondController.value), -0.1, false, beyondIndexPaint);
    */
   }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}