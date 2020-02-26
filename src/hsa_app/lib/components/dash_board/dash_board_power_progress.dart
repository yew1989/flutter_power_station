import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';
import 'package:path_drawing/path_drawing.dart';

class DashBoardPowerProgress extends StatefulWidget {

  final DashBoardDataPack dashboardData;

  const DashBoardPowerProgress(this.dashboardData,{Key key}) : super(key: key);
  @override
  _DashBoardPowerProgressState createState() => _DashBoardPowerProgressState();
}

class _DashBoardPowerProgressState extends State<DashBoardPowerProgress> with TickerProviderStateMixin{

  AnimationController controller;

  void initAnimationController(){
    controller  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    }
    else if(status == AnimationStatus.dismissed) {
      controller.forward();
     }
    });
  }

  void forwardAnimation() async {
    await Future.delayed(Duration(milliseconds:100));
    controller.forward();
  }

  @override
  void initState() {
    initAnimationController();
    forwardAnimation();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context,child) {
          return CustomPaint(
          painter: DashBoardPowerProgressPainter(widget.dashboardData,controller));
        }
      ),
    );
  }
}

class DashBoardPowerProgressPainter extends CustomPainter {

  final DashBoardDataPack dashboardData;
  final AnimationController controller;

  DashBoardPowerProgressPainter(this.dashboardData, this.controller);
  
  @override
  void paint(Canvas canvas, Size size) {

    var powerPencent  = dashboardData?.power?.percent ?? 0.0;
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
          Colors.white, 
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
    redPath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0),pi/2,beyondPencent * 1.0 * pi);
    canvas.drawPath(dashPath(redPath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5])),paintPowerRed);
   }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}