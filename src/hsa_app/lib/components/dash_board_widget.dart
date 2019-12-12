import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:math';

class DashPainter extends CustomPainter {

  final DashBoardDataPack dashboardData;

  DashPainter(this.dashboardData);

  @override
  void paint(Canvas canvas, Size size) {

    var openPencent   = dashboardData?.open?.percent ?? 0.0;
    var freqPencent   = dashboardData?.freq?.percent ?? 0.0;
    var powerPencent  = dashboardData?.power?.percent ?? 0.0;
    var beyondPencent = 0.0;

    if(powerPencent > 1.0) {
      beyondPencent = powerPencent - 1.0;
      powerPencent = 1.0;
      if(beyondPencent > 0.5) {
        beyondPencent = 0.5;
      }
    }


    // 固定圆环
    Paint paintFix = Paint();
    paintFix
      ..color = Colors.white24
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: 94.0), -pi / 2, 2 * pi, false, paintFix);

    // 开度背景 半圆
    Paint paintOpenBack = Paint();
    paintOpenBack
      ..color = Colors.white24
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: 100.0), -pi / 2, 1 * pi, false, paintOpenBack);

    // 开度真实
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
    canvas.drawArc(rectCircleReal, -pi / 2, openPencent * pi, false, paintOpenReal);

    // 真实频率背景
    Paint paintHzBg = Paint();
    paintHzBg
      ..color = Colors.white10
      ..strokeCap = StrokeCap.butt
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    Rect rectPaintHzBg = Rect.fromCircle(center: Offset(0, 0), radius: 80.0);
    canvas.drawArc(rectPaintHzBg, -pi, 1.25 * pi, false, paintHzBg);

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
    canvas.drawArc(rectPaintHzReal, -pi, freqPencent * pi, false, paintHzReal);

    // 功率
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
    bluePath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0), -pi, (powerPencent*1.5) * pi);
    canvas.drawPath(dashPath(bluePath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5])),paintPowerBlue);

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

    Path redPath = Path(); 
    // 为了展现好看,超发部分 放大 3倍
    beyondPencent = beyondPencent * 3;
    redPath.addArc(Rect.fromCircle(center: Offset(0, 0), radius: 54.0),pi/2,beyondPencent * 1.0 * pi);
    canvas.drawPath(dashPath(redPath,dashArray: CircularIntervalList<double>(<double>[1.0, 2.5]),),paintPowerRed);
   }
   

    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DashBoardWidget extends StatefulWidget {

  final DashBoardDataPack dashBoardData;

  const DashBoardWidget({Key key, this.dashBoardData}) : super(key: key);
  @override
  _DashBoardWidgetState createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  @override
  Widget build(BuildContext context) {
    
    // 功率 now
    var powerNow = widget?.dashBoardData?.power?.now ?? 0.0;
    var powerNowStr = powerNow.toStringAsFixed(0);

    // 功率 max
    var powerMax = widget?.dashBoardData?.power?.max ?? 0.0;
    var powerMaxStr = powerMax.toStringAsFixed(0) + 'kW';

    return Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
        children: 
        [
          Center(
            child: CustomPaint(
              painter: DashPainter(widget?.dashBoardData),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(powerNowStr ??'',style: TextStyle(color: Colors.white,fontSize: 34,fontFamily: 'ArialNarrow')),
                SizedBox(height: 2,width: 50,child: Image.asset('images/runtime/Time_line1.png')),
                SizedBox(height: 2),
                Text(powerMaxStr ??'',style: TextStyle(color: Colors.white38,fontSize: 15,fontFamily: 'ArialNarrow')),
              ],
            ),
          )
        ]),
      );
  }
}