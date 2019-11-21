import 'package:flutter/material.dart';
import 'package:native_color/native_color.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:math';

class DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('绘制前测量:' + size.toString());

    Paint paintFix = Paint();
    paintFix
      ..color = Colors.white24
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    Rect rectCirleFix = Rect.fromCircle(center: Offset(0, 0), radius: 94.0);
    canvas.drawArc(rectCirleFix, -pi / 2, 2 * pi, false, paintFix);

    Paint paintFreqBack = Paint();
    paintFreqBack
      ..color = Colors.white24
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    Rect rectCircleFreq = Rect.fromCircle(center: Offset(0, 0), radius: 100.0);
    canvas.drawArc(rectCircleFreq, -pi / 2, 1 * pi, false, paintFreqBack);

    Paint paintFreqReal = Paint();
    paintFreqReal
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
    canvas.drawArc(rectCircleReal, -pi / 2, 0.75 * pi, false, paintFreqReal);

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
    canvas.drawArc(rectPaintHzReal, -pi, 1 * pi, false, paintHzReal);

    // 转速
    Paint paintHzPRM = Paint();
    paintHzPRM
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

    Path p = Path();
    Rect rect2 = Rect.fromCircle(center: Offset(0, 0), radius: 54.0);
    p.addArc(rect2, -pi, 1.5 * pi);
    canvas.drawPath(
      dashPath(
      p,
      dashArray: CircularIntervalList<double>(<double>[1.0, 2.5]),
      ),paintHzPRM);

   Paint paintHzPRMRed = Paint();
   paintHzPRMRed
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

    Path p2 = Path(); 
    Rect rect3 = Rect.fromCircle(center: Offset(0, 0), radius: 54.0);
    p2.addArc(rect3,pi/2,0.1* pi);
    canvas.drawPath(
      dashPath(
      p2,
      dashArray: CircularIntervalList<double>(<double>[1.0, 2.5]),
      ),paintHzPRMRed);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DashBoardWidget extends StatefulWidget {
  @override
  _DashBoardWidgetState createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
        children: 
        [
          Center(
            child: CustomPaint(
              painter: DashPainter(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('1000',style: TextStyle(color: Colors.white,fontSize: 34,fontFamily: 'ArialNarrow')),
                SizedBox(height: 2,width: 50,child: Image.asset('images/runtime/Time_line1.png')),
                SizedBox(height: 2),
                Text('900kW',style: TextStyle(color: Colors.white38,fontSize: 15,fontFamily: 'ArialNarrow')),
              ],
            ),
          )
        ]),
      );
  }
}