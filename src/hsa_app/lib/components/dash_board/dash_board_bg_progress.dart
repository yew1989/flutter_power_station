import 'dart:math';
import 'package:flutter/material.dart';

class DashBoardBgProgress extends StatefulWidget {
  @override
  _DashBoardBgProgressState createState() => _DashBoardBgProgressState();
}

class _DashBoardBgProgressState extends State<DashBoardBgProgress>  {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: DashBoardBgProgressPainter(),
      ),
    );
  }
}

class DashBoardBgProgressPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}