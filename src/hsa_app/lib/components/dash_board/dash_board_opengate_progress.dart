import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class DashBoardOpenGateProgress extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  final List<double> openList;
  final int seconds;

  const DashBoardOpenGateProgress(this.deviceTerminal,this.openList,this.seconds,{Key key}) : super(key: key);
  @override
  _DashBoardOpenGateProgressState createState() => _DashBoardOpenGateProgressState();
}

class _DashBoardOpenGateProgressState extends State<DashBoardOpenGateProgress> with TickerProviderStateMixin{

  AnimationController openController;

  void initAnimationController(){
    int t = widget?.seconds ?? 5;
    openController  = AnimationController(vsync: this, duration: Duration(seconds: t));
    eventBird?.on('NEAREST_DATA_OPEN', (dt){
      openController.value = 0;
      openController.forward();
    });
  }


  @override
  void initState() {
    initAnimationController();
    super.initState();
  }

  @override
  void dispose() {
    openController?.dispose();
    eventBird?.off('NEAREST_DATA_OPEN');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var openList = widget?.openList ?? [0.0,0.0];
    return Center(
      child: AnimatedBuilder(
        animation: openController,
        builder: (context,child) {
          return CustomPaint(
          painter: DashBoardOpenGateProgressPainter(widget.deviceTerminal,openController,openList));
        }
      ),
    );
  }
}

class DashBoardOpenGateProgressPainter extends CustomPainter {

  final DeviceTerminal deviceTerminal;
  final AnimationController openController;
  final List<double> openList;

  DashBoardOpenGateProgressPainter(this.deviceTerminal, this.openController,this.openList);
  
  @override
  void paint(Canvas canvas, Size size) {
    var openMax  = 1.0;
    var openPencentOld   = RuntimeDataAdapter.caclulatePencent(openList[0],openMax) ?? 0.0;
    var openPencentNew   = RuntimeDataAdapter.caclulatePencent(openList[1],openMax) ?? 0.0;
    

    //线起始
    double startAngle;
    //线变化
    double sweepAngle;
    //线补充
    double sweepAngleOld;

    //后数据>前数据(顺时针)
    if(openList[1] > openList[0]){
      startAngle = pi * openPencentOld + (- 0.5 * pi);
      sweepAngle = openController.value * (openPencentNew - openPencentOld) * pi ;
      sweepAngleOld = pi * openPencentOld;
    }
    //后数据<前数据(逆时针)
    else if(openList[1] < openList[0]){
      startAngle = pi * openPencentNew + (- 0.5 * pi);
      sweepAngle = (1 - openController.value) * (openPencentOld - openPencentNew) * pi ;
      sweepAngleOld = pi * openPencentNew;
    }

    //补充
    Paint paintOpenRealOld = Paint();
    paintOpenRealOld
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
    Rect rectCircleRealOld = Rect.fromCircle(center: Offset(0, 0), radius: 100.0);
    canvas.drawArc(rectCircleRealOld, -pi / 2, sweepAngleOld, false, paintOpenRealOld);

    //行动轨迹
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
    canvas.drawArc(rectCircleReal, startAngle,  sweepAngle, false, paintOpenReal);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}