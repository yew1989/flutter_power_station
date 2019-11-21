import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';


class DrawXXXPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    // 直线
    Paint _paint = Paint()
    ..color = Colors.blueAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(20.0, 20.0), Offset(200.0, 100.0), _paint);
    
   // 直线
    _paint
    ..color = Colors.redAccent
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..strokeWidth = 8.0
    ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(20.0, 100.0), Offset(200.0, 40.0), _paint);

    // 圆形
    _paint
    ..color = Colors.greenAccent
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..strokeWidth = 10.0
    ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(50.0, 150.0), 30, _paint);

    // 圆环
    _paint
    ..color = Colors.yellowAccent
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..strokeWidth = 8.0
    ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(150.0, 50.0), 40, _paint);

    // normal模糊
    _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0)
    ..color = Colors.pinkAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(220.0, 20.0), Offset(400.0, 20.0), _paint);

    // outer模糊
     _paint
     ..maskFilter = MaskFilter.blur(BlurStyle.outer, 3.0)
    ..color = Colors.orangeAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(220.0, 60.0), Offset(400.0, 60.0), _paint);

     // solid模糊
      _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6.0)
    ..color = Colors.pinkAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(220.0, 100.0), Offset(400.0, 100.0), _paint);

    // inner模糊
    _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.inner, 3.0)
    ..color = Colors.orangeAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(220.0, 140.0), Offset(400.0, 140.0), _paint);

    // 画白色点
     _paint
    ..maskFilter = null
    ..color = Colors.white
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;
    canvas.drawPoints(ui.PointMode.points,[
      Offset(20, 220),
      Offset(30, 230),
      Offset(40, 240),
      Offset(50, 250),
      Offset(60, 230),
      Offset(70, 240),
      Offset(40, 260),
      Offset(100, 220),
    ], _paint);


    // 画红色封闭点,连接路径
    _paint
    ..maskFilter = null
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke;
    canvas.drawPoints(ui.PointMode.polygon,[
      Offset(120, 220),
      Offset(130, 230),
      Offset(140, 240),
      Offset(150, 250),
      Offset(160, 230),
       Offset(180, 230),
       Offset(180, 200),
       Offset(120, 220),
      // Offset(200, 220),
    ], _paint);

    // 画一个椭圆
        _paint
    ..maskFilter = null
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke;
    Rect rectOval = Rect.fromPoints(Offset(250.0, 160.0), Offset(350.0, 180.0));
    canvas.drawOval(rectOval, _paint);

        // 画一个椭圆
        _paint
    ..maskFilter = null
    ..color = Colors.purpleAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 4.0
    ..style = PaintingStyle.fill;
    Rect rectOval2 = Rect.fromPoints(Offset(250.0, 200.0), Offset(350.0, 250.0));
    canvas.drawOval(rectOval2, _paint);


    /*
      fromPoints(Offset a, Offset b)
      使用左上和右下角坐标来确定矩形的大小和位置

      fromCircle({ Offset center, double radius })
      使用圆的圆心点坐标和半径和确定外切矩形的大小和位置

      fromLTRB(double left, double top, double right, double bottom)
      使用矩形左边的X坐标、矩形顶部的Y坐标、矩形右边的X坐标、矩形底部的Y坐标来确定矩形的大小和位置

      fromLTWH(double left, double top, double width, double height)
      使用矩形左边的X坐标、矩形顶部的Y坐标矩形的宽高来确定矩形的大小和位置
    
     */

      _paint
    ..maskFilter = null
    ..color = Colors.redAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
    Rect rectArc = Rect.fromCircle(center: Offset(20.0, 350.0), radius: 40.0);
    canvas.drawArc(rectArc,-pi/2, pi/2 - 0.2, false, _paint);

    _paint
    ..maskFilter = null
    ..color = Colors.greenAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
    Rect rectArc2 = Rect.fromCircle(center: Offset(100.0, 350.0), radius: 40.0);
    canvas.drawArc(rectArc2,-pi/2, pi +0.5, false, _paint);

    _paint
    ..maskFilter = null
    ..color = Colors.yellowAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
    Rect rectArc3 = Rect.fromCircle(center: Offset(200.0, 350.0), radius: 40.0);
    canvas.drawArc(rectArc3,-pi/2, pi +0.85, true, _paint);
    
    _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6.0)
    ..color = Colors.orangeAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rectArc4 = Rect.fromCircle(center: Offset(300.0, 350.0), radius: 40.0);
    canvas.drawArc(rectArc4,pi, pi +0.85, false, _paint);


        _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6.0)
    ..color = Colors.orangeAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rectArc5 = Rect.fromCircle(center: Offset(300.0, 350.0), radius: 30.0);
    canvas.drawArc(rectArc5,pi, pi +0.85, false, _paint);

            _paint
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6.0)
    ..color = Colors.cyanAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rectArc6 = Rect.fromCircle(center: Offset(300.0, 350.0), radius: 30.0);
    canvas.drawArc(rectArc6,pi, pi +0.85, false, _paint);

               _paint
    // ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6.0)
    ..color = Colors.cyanAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.fill;
    Rect rectArc7 = Rect.fromCircle(center: Offset(350.0, 300.0), radius: 30.0);
    canvas.drawArc(rectArc7,pi, pi +0.85, false, _paint);


    _paint
    ..maskFilter = null
    ..color = Colors.lightBlueAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rrect1 = Rect.fromLTWH(20, 410, 50, 30);
    canvas.drawArc(rrect1,pi, pi +0.85, false, _paint);

      _paint
 ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6.0)
    ..color = Colors.lightGreenAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rrect2 = Rect.fromLTWH(100, 420, 50, 30);
    RRect rrect = RRect.fromRectAndRadius(rrect2, Radius.circular(10.0));
    canvas.drawRRect(rrect, _paint);

         _paint
    ..maskFilter = null
    ..color = Colors.deepPurpleAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rrect3 = Rect.fromLTWH(200, 430, 120, 30);
    canvas.drawRect(rrect3, _paint);


    // 双圆角矩形
     _paint
    ..maskFilter = null
    ..color = Colors.teal
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Rect rect1 = Rect.fromCircle(center: Offset(50.0, 500.0), radius: 30.0);
    Rect rect2 = Rect.fromCircle(center: Offset(50.0, 500.0), radius: 20.0);
    //分别绘制外部圆角矩形和内部的圆角矩形
    RRect outer = RRect.fromRectAndRadius(rect1, Radius.circular(10.0));
    RRect inner = RRect.fromRectAndRadius(rect2, Radius.circular(10.0));
    canvas.drawDRRect(outer, inner, _paint);

    // 绘制路径drawPath
    _paint
    ..maskFilter = null
    ..color = Colors.pinkAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

    Path path = Path()..moveTo(100.0, 100.0);

    path.lineTo(280.0, 300.0);
    path.lineTo(180.0, 320.0);
    path.lineTo(240.0, 350.0);
    path.lineTo(180.0, 400.0);
    
    canvas.drawPath(path, _paint);

    // 使用二阶贝塞尔曲线绘制弧线:
        _paint
    ..maskFilter = null
    ..color = Colors.cyanAccent
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;
    Path path2 =  Path()..moveTo(100.0, 500.0);
    Rect rect = Rect.fromCircle(center: Offset(200.0, 600.0), radius: 60.0);
    path2.arcTo(rect, 0.0, 3.14, false);
    canvas.drawPath(path2, _paint);

    // 三阶贝塞尔曲线

     _paint
    ..maskFilter = null
    ..color = Colors.amber
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.fill;

    var width = 60;
    var height = 90;
    Path path4 = Path();
    path4.moveTo(width / 2, height / 4);
    path4.cubicTo((width * 6) / 7, height / 9, (width * 13) / 13,
        (height * 2) / 5, width / 2, (height * 7) / 12);
    canvas.drawPath(path4, _paint);

    Path path3 =  Path();
    path3.moveTo(width / 2, height / 4);
    path3.cubicTo(width / 7, height / 9, width / 21, (height * 2) / 5,
        width / 2, (height * 7) / 12);
    canvas.drawPath(path3, _paint);

    // 绘制图片
    // _paint
    // ..maskFilter = null
    // ..color = Colors.amber
    // ..strokeCap = StrokeCap.round
    // ..isAntiAlias = true
    // ..strokeWidth = 3.0
    // ..style = PaintingStyle.fill;
    // final image2 = Image.asset('assets/img/sun.png');
    // canvas.drawImage(image2, Offset(3, 4), _paint);


  // 绘制文本
  for (int i = 0; i<5 ;i++) {
    // 新建一个段落建造器，然后将文字基本信息填入;
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
    textAlign: TextAlign.left,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    fontSize: 15.0+i,
  ));
  pb.pushStyle(ui.TextStyle(color: Colors.white));
  pb.addText('期待Flutter一统移动端天下');
  // 设置文本的宽度约束
  ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: 300);
  // 这里需要先layout,将宽度约束填入，否则无法绘制
  ui.Paragraph paragraph = pb.build()..layout(pc);
  // 文字左上角起始点
  Offset offset = Offset(50, 500+i*40.0);
  canvas.drawParagraph(paragraph, offset);


    // 渐变层颜色 矩形环
      _paint
    ..maskFilter = null
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..filterQuality = FilterQuality.high
    ..style = PaintingStyle.stroke
    ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 2*pi,
        colors: [
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.red,
          Colors.purple,
          Colors.blue,
        ],
        // stops: 1,
      ).createShader(Rect.fromLTWH(300, 500, 100, 80));

    RRect rrect = RRect.fromRectAndRadius(Rect.fromLTWH(300, 500, 100, 80), Radius.circular(10));
    canvas.drawRRect(rrect, _paint);

    // 渐变层颜色 圆环
    _paint
    ..maskFilter = null
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 20
    ..filterQuality = FilterQuality.high
    ..style = PaintingStyle.stroke
    ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 2*pi,
        colors: [
          // Colors.blue,
          // Colors.green,
          // Colors.yellow,
          // Colors.red,
          Colors.purple,
          Colors.blue,
          Colors.purple,
        ],
      ).createShader(Rect.fromCircle(center: Offset(350.0, 640.0), radius: 40.0));
    Rect rectArc6 = Rect.fromCircle(center: Offset(350.0, 640.0), radius: 40.0);
    canvas.drawArc(rectArc6,0, 2*pi - 1.2, false, _paint);

        _paint
    ..maskFilter = null
    ..strokeCap = StrokeCap.round
    ..color = Colors.yellow
    ..isAntiAlias = true
    ..strokeWidth = 3
    ..filterQuality = FilterQuality.high
    ..style = PaintingStyle.stroke;

     Rect rectMini1 = Rect.fromLTWH(20, 580, 100, size.width / 3);
     canvas.drawRect(rectMini1, _paint);

     Rect rectMini2 = Rect.fromLTWH(30, 590, 100, size.width / 4);
     canvas.drawRect(rectMini2, _paint);

      Rect rectMini3 = Rect.fromLTWH(40, 600, 100, size.width / 5);
     canvas.drawRect(rectMini3, _paint);

    // canvas.drawArc(rectArc7,0, 2*pi - 0.8, false, _paint);

    //     Rect rectArc8 = Rect.fromCircle(center: Offset(350.0, 680.0), radius: 20.0);
    // canvas.drawArc(rectArc8,0, 2*pi - 0.8, false, _paint);

   }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  
}



class DrawPaintPage extends StatefulWidget {
  @override
  _DrawPaintPageState createState() => _DrawPaintPageState();
}

class _DrawPaintPageState extends State<DrawPaintPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DrawXXX'),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
              painter: DrawXXXPainter(),
            ),
        ),
    );
  }
}