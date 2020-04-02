import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class DashBoardOpenGateProgress extends StatefulWidget {

  final DeviceTerminal deviceTerminal;

  const DashBoardOpenGateProgress(this.deviceTerminal,{Key key}) : super(key: key);
  @override
  _DashBoardOpenGateProgressState createState() => _DashBoardOpenGateProgressState();
}

class _DashBoardOpenGateProgressState extends State<DashBoardOpenGateProgress> with TickerProviderStateMixin{

  AnimationController controller;

  void initAnimationController(){
    controller  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    // controller.addStatusListener((status) {
    // if (status == AnimationStatus.completed) {
    //   controller.reverse();
    // }
    // else if(status == AnimationStatus.dismissed) {
    //   controller.forward();
    //  }
    // });
  }

  void forwardAnimation() async {
    await Future.delayed(Duration(milliseconds:800));
    if(controller == null) return;
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
          painter: DashBoardOpenGateProgressPainter(widget.deviceTerminal,controller));
        }
      ),
    );
  }
}

class DashBoardOpenGateProgressPainter extends CustomPainter {

  final DeviceTerminal deviceTerminal;
  final AnimationController controller;

  DashBoardOpenGateProgressPainter(this.deviceTerminal, this.controller);
  
  @override
  void paint(Canvas canvas, Size size) {
    var openNow  = deviceTerminal?.nearestRunningData?.openAngle?.toDouble() ?? 0.0;
    var openMax  = 1.0;
    var openPencent   = RuntimeDataAdapter.caclulatePencent(openNow,openMax) ?? 0.0;
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