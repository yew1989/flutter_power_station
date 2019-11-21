import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DrawCirCelPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('绘制前测量:' + size.toString());

    // solid模糊 ,先来一个发光圆环
    Paint _paint = Paint();
    _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 10.0)
    ..color = Colors.cyan
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCel = Rect.fromCircle(center: Offset(100.0, 150.0), radius: 60.0);
    canvas.drawArc(rectCirCel, -pi/2, 2 * pi, false, _paint);

    // 白色圆环
    _paint
    ..maskFilter = null
    ..color = Colors.white
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCel2 = Rect.fromCircle(center: Offset(300.0, 150.0), radius: 60.0);
    canvas.drawArc(rectCirCel2, -pi/2, 2 * pi, false, _paint);


    // 半圆环
      _paint
    ..maskFilter = null
    ..color = Colors.cyan
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCelHalf = Rect.fromCircle(center: Offset(200.0, 350.0), radius: 60.0);
    canvas.drawArc(rectCirCelHalf, -pi/2, pi, false, _paint);

     // 叠加
     _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 10.0)
    ..color = Colors.cyan
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCel9= Rect.fromCircle(center: Offset(200.0, 550.0), radius: 60.0);
    canvas.drawArc(rectCirCel9, -pi/2, 2 * pi, false, _paint);

    _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 10.0)
    ..color = Colors.cyan
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCel3= Rect.fromCircle(center: Offset(200.0, 550.0), radius: 60.0);
    canvas.drawArc(rectCirCel3, -pi/2, 2 * pi, false, _paint);

      _paint
    ..maskFilter = null
    ..color = Colors.white
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCel4 = Rect.fromCircle(center: Offset(200.0, 550.0), radius: 60.0);
    canvas.drawArc(rectCirCel4, -pi/2, 2 * pi, false, _paint);

     _paint
    ..maskFilter = null
    ..color = Colors.cyan
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
    Rect rectCirCelHalf2 = Rect.fromCircle(center: Offset(200.0, 550.0), radius: 60.0);
    canvas.drawArc(rectCirCelHalf2, -pi/2, pi, false, _paint);

    

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  
}



class DrawCircelPaintPage extends StatefulWidget {
  @override
  _DrawCircelPaintPageState createState() => _DrawCircelPaintPageState();
}

class _DrawCircelPaintPageState extends State<DrawCircelPaintPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('圆圆环环圆圆环'),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
              painter: DrawCirCelPainter(),
            ),
        ),
    );
  }
}