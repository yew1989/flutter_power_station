import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


class DrawWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class DrawWavePaintPage extends StatefulWidget {
  @override
  _DrawWavePainterState createState() => _DrawWavePainterState();
}

class _DrawWavePainterState extends State<DrawWavePaintPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('水波和曲线'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // 绘制正选
          Container(
            height: 100,
            width: double.infinity,
            child: WaveWidget(
              waveFrequency: 20,
              config: CustomConfig(
                colors: [Colors.blue],
              //  gradients: [
              //     [Colors.blue],
              //     // [Colors.blue[800], Color(0x773399CC)],
              //     // [Colors.blue, Color(0x660033FF)],
              //     // [Colors.blue, Color(0x550099CC)],
              //   ],
                durations: [10000],
                heightPercentages: [0.55],
                
                // gradients: [
                //   [Colors.blue, Color(0xEE6699FF)],
                //   [Colors.blue[800], Color(0x773399CC)],
                //   [Colors.blue, Color(0x660033FF)],
                //   [Colors.blue, Color(0x550099CC)],
                // ],
                // durations: [35000, 19440, 10800, 6000],
                // heightPercentages: [0.55, 0.40, 0.45, 0.50],
                // gradientBegin: Alignment.bottomLeft,
                // gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 10,
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),


        Container(
            height: 100,
            width: double.infinity,
            child: WaveWidget(
              waveFrequency: 10,
              wavePhase: 110,
              config: CustomConfig(
                colors: [Colors.blue],
              //  gradients: [
              //     [Colors.blue],
              //     // [Colors.blue[800], Color(0x773399CC)],
              //     // [Colors.blue, Color(0x660033FF)],
              //     // [Colors.blue, Color(0x550099CC)],
              //   ],
                durations: [10000],
                heightPercentages: [0.55],
                
                // gradients: [
                //   [Colors.blue, Color(0xEE6699FF)],
                //   [Colors.blue[800], Color(0x773399CC)],
                //   [Colors.blue, Color(0x660033FF)],
                //   [Colors.blue, Color(0x550099CC)],
                // ],
                // durations: [35000, 19440, 10800, 6000],
                // heightPercentages: [0.55, 0.40, 0.45, 0.50],
                // gradientBegin: Alignment.bottomLeft,
                // gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 10,
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),


         Container(
            height: 100,
            width: double.infinity,
            child: WaveWidget(
              waveFrequency: 2.6,
              config: CustomConfig(
                colors: [Colors.blue],
              //  gradients: [
              //     [Colors.blue],
              //     // [Colors.blue[800], Color(0x773399CC)],
              //     // [Colors.blue, Color(0x660033FF)],
              //     // [Colors.blue, Color(0x550099CC)],
              //   ],
                durations: [10000],
                heightPercentages: [0.55],
                
                // gradients: [
                //   [Colors.blue, Color(0xEE6699FF)],
                //   [Colors.blue[800], Color(0x773399CC)],
                //   [Colors.blue, Color(0x660033FF)],
                //   [Colors.blue, Color(0x550099CC)],
                // ],
                // durations: [35000, 19440, 10800, 6000],
                // heightPercentages: [0.55, 0.40, 0.45, 0.50],
                // gradientBegin: Alignment.bottomLeft,
                // gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 10,
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),




          Container(
            height: 100,
            width: double.infinity,
            child: WaveWidget(
              waveFrequency: 2.6,
              config: CustomConfig(
                colors: [Colors.blue,Colors.red],
              //  gradients: [
              //     [Colors.blue],
              //     // [Colors.blue[800], Color(0x773399CC)],
              //     // [Colors.blue, Color(0x660033FF)],
              //     // [Colors.blue, Color(0x550099CC)],
              //   ],
                durations: [10000,10000],
                heightPercentages: [0.55,0.85],
                
                // gradients: [
                //   [Colors.blue, Color(0xEE6699FF)],
                //   [Colors.blue[800], Color(0x773399CC)],
                //   [Colors.blue, Color(0x660033FF)],
                //   [Colors.blue, Color(0x550099CC)],
                // ],
                // durations: [35000, 19440, 10800, 6000],
                // heightPercentages: [0.55, 0.40, 0.45, 0.50],
                // gradientBegin: Alignment.bottomLeft,
                // gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 10,
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),


        Container(
            height: 100,
            width: double.infinity,
            child: WaveWidget(
              waveFrequency: 2.6,
              config: CustomConfig(
                colors: [Colors.blue,Colors.red],
              //  gradients: [
              //     [Colors.blue],
              //     // [Colors.blue[800], Color(0x773399CC)],
              //     // [Colors.blue, Color(0x660033FF)],
              //     // [Colors.blue, Color(0x550099CC)],
              //   ],
                durations: [100000,50000],
                heightPercentages: [0.55,0.65],
                
                // gradients: [
                //   [Colors.blue, Color(0xEE6699FF)],
                //   [Colors.blue[800], Color(0x773399CC)],
                //   [Colors.blue, Color(0x660033FF)],
                //   [Colors.blue, Color(0x550099CC)],
                // ],
                // durations: [35000, 19440, 10800, 6000],
                // heightPercentages: [0.55, 0.40, 0.45, 0.50],
                // gradientBegin: Alignment.bottomLeft,
                // gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 10,
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),


            Container(
            height: 100,
            width: double.infinity,
            child: WaveWidget(
              waveFrequency: 2.6,
              config: CustomConfig(
               gradients: [
                  [Colors.transparent,Colors.blue,Colors.transparent],
                  [Colors.transparent,Colors.red, Colors.transparent],
                ],
                durations: [100000,50000],
                heightPercentages: [0.55,0.65],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 10,
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, double.infinity),
            ),
          ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            ClipOval(
                child: Container(
            height: 100,
            width: 100,
            child: WaveWidget(
                waveFrequency: 2.6,
                config: CustomConfig(
                 gradients: [
                    [Colors.transparent,Colors.blue,Colors.transparent],
                    [Colors.transparent,Colors.red, Colors.transparent],
                  ],
                  durations: [10000,5000],
                  heightPercentages: [0.55,0.65],
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 5,
                backgroundColor: Colors.transparent,
                size: Size(double.infinity, double.infinity),
            ),
          ),
              ),

          ClipOval(
            child: Container(
              height: 100,
              width: 100,
              child: WaveWidget(
                waveFrequency: 2.6,
                config: CustomConfig(
                 gradients: [
                    [Colors.green,Colors.blue,Colors.green],
                    [Colors.yellow,Colors.red, Colors.yellow],
                  ],
                  durations: [10000,5000],
                  heightPercentages: [0.55,0.65],
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 5,
                backgroundColor: Colors.transparent,
                size: Size(double.infinity, double.infinity),
              ),
            ),
          ),


          ],
        ),
         




        ], 
      ),
    );
  }
}