import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class DashBoardFreqProgress extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  final List<double> freqList;
  final int seconds;


  const DashBoardFreqProgress(this.deviceTerminal, this.freqList, this.seconds,{Key key}) : super(key: key);
  @override
  _DashBoardFreqProgressState createState() => _DashBoardFreqProgressState();
}

class _DashBoardFreqProgressState extends State<DashBoardFreqProgress> with TickerProviderStateMixin{

  AnimationController controller;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 1;
  
  void initAnimationController(){
    int t = widget?.seconds ?? 5;
    if(canPlayAnimationOnZero <= 0 && mounted ) {
      controller?.dispose();
      controller  = AnimationController(vsync: this, duration: Duration(seconds: t));
      controller.forward();
      canPlayAnimationOnZero = 0;
    }
    canPlayAnimationOnZero --;
  }

  @override
  void initState() {
    super.initState();
    initAnimationController();
    eventBird?.on('NEAREST_DATA', (_){
      initAnimationController();
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
    var freqList = widget?.freqList ?? [0.0,0.0];
    return Center(
      child: controller == null ? Container() : AnimatedBuilder(
        animation: controller,
        builder: (context,child) {
          return CustomPaint(
          painter: DashBoardFreqProgressPainter(widget.deviceTerminal,controller,freqList));
        }
      ),
    );
  }
}

class DashBoardFreqProgressPainter extends CustomPainter {

  final DeviceTerminal deviceTerminal;
  final AnimationController freqController;
  final List<double> freqList;

  DashBoardFreqProgressPainter(this.deviceTerminal, this.freqController ,this.freqList);
  
  @override
  void paint(Canvas canvas, Size size) {
    var freqMax  = 50.0;
    var freqPencentOld   = RuntimeDataAdapter.caclulatePencent(freqList[0],freqMax) ?? 0.0;
    var freqPencentNew   = RuntimeDataAdapter.caclulatePencent(freqList[1],freqMax) ?? 0.0;

    //线起始
    double startAngle = 0.0;
    //线变化
    double sweepAngle = 0.0;
    //线补充
    double sweepAngleOld = 0.0;

    //后数据>前数据(顺时针)
    if(freqList[1] >= freqList[0]){
      startAngle = pi * freqPencentOld + (-pi);
      sweepAngle = freqController.value * (freqPencentNew - freqPencentOld) * pi ;
      sweepAngleOld = pi * freqPencentOld;
    }
    //后数据<前数据(逆时针)
    else if(freqList[1] < freqList[0]){
      startAngle = pi * freqPencentNew + (-pi);
      sweepAngle = (1 - freqController.value) * (freqPencentOld - freqPencentNew) * pi ;
      sweepAngleOld = pi * freqPencentNew;
    }

    // 真实频率填充
    Paint paintHzRealOld = Paint();
    paintHzRealOld
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
    Rect rectPaintHzRealOld = Rect.fromCircle(center: Offset(0, 0), radius: 80.0);
    canvas.drawArc(rectPaintHzRealOld, -pi, sweepAngleOld, false, paintHzRealOld);

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
    canvas.drawArc(rectPaintHzReal,startAngle, sweepAngle, false, paintHzReal);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}