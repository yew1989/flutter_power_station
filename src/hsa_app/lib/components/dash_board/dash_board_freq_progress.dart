import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class DashBoardFreqProgress extends StatefulWidget {

  final DashBoardDataPack dashboardData;

  const DashBoardFreqProgress(this.dashboardData,{Key key}) : super(key: key);
  @override
  _DashBoardFreqProgressState createState() => _DashBoardFreqProgressState();
}

class _DashBoardFreqProgressState extends State<DashBoardFreqProgress> with TickerProviderStateMixin{

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
    await Future.delayed(Duration(milliseconds:200));
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
          painter: DashBoardFreqProgressPainter(widget.dashboardData,controller));
        }
      ),
    );
  }
}

class DashBoardFreqProgressPainter extends CustomPainter {

  final DashBoardDataPack dashboardData;
  final AnimationController controller;

  DashBoardFreqProgressPainter(this.dashboardData, this.controller);
  
  @override
  void paint(Canvas canvas, Size size) {
    var freqPencent   = dashboardData?.freq?.percent ?? 0.0;
    // 真实频率
    Paint paintHzReal = Paint();
    paintHzReal
      ..strokeCap = StrokeCap.butt
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HexColor('4778f7'),
          HexColor('66f7f9'),
        ],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 80.0));
    Rect rectPaintHzReal = Rect.fromCircle(center: Offset(0, 0), radius: 80.0);
    canvas.drawArc(rectPaintHzReal, -pi, controller.value * freqPencent * pi, false, paintHzReal);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}