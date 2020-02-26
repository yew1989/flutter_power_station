import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class DashBoardOpenGateProgress extends StatefulWidget {

  final DashBoardDataPack dashboardData;

  const DashBoardOpenGateProgress(this.dashboardData,{Key key}) : super(key: key);
  @override
  _DashBoardOpenGateProgressState createState() => _DashBoardOpenGateProgressState();
}

class _DashBoardOpenGateProgressState extends State<DashBoardOpenGateProgress> with TickerProviderStateMixin{

  AnimationController controller;

  void initAnimationController(){
    controller  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
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
    await Future.delayed(Duration(milliseconds:800));
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
          painter: DashBoardOpenGateProgressPainter(widget.dashboardData,controller));
        }
      ),
    );
  }
}

class DashBoardOpenGateProgressPainter extends CustomPainter {

  final DashBoardDataPack dashboardData;
  final AnimationController controller;

  DashBoardOpenGateProgressPainter(this.dashboardData, this.controller);
  
  @override
  void paint(Canvas canvas, Size size) {

    var openPencent   = dashboardData?.open?.percent ?? 0.0;
    Paint paintOpenReal = Paint();
    paintOpenReal
      ..strokeCap = StrokeCap.round
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HexColor('4778f7'),
          HexColor('66f7f9'),
        ],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 100.0));
    Rect rectCircleReal = Rect.fromCircle(center: Offset(0, 0), radius: 100.0);
    canvas.drawArc(rectCircleReal, -pi / 2,  controller.value * openPencent * pi, false, paintOpenReal);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}