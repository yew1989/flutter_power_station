import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/circle_indicator.dart';
import 'package:native_color/native_color.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


class WaveBall extends StatefulWidget {
  @override
  _WaveBallState createState() => _WaveBallState();
}

class _WaveBallState extends State<WaveBall> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        children: <Widget>[
          //波浪
          Center(
            child: ClipOval(
              child: Container(
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)],
                      [Color.fromRGBO(92,180,224, 1),Color.fromRGBO(92,180,224, 0.3)],
                    ],
                    durations: [35000,10000],
                    heightPercentages: [0.38,0.4],
                    gradientBegin: Alignment.topCenter,
                    gradientEnd: Alignment.bottomCenter,
                  ),
                  waveAmplitude: 0,
                  backgroundColor: Colors.transparent,
                  size: Size(double.infinity, double.infinity),
                ),
              ),
            ),
          ),

          // 圆环背景
          Center(
            child: Container(
              child: GradientCircularProgressIndicator(
                colors: <Color>[
                  Color.fromRGBO(56, 98, 152, 1),
                  Color.fromRGBO(56, 98, 152, 1),
                ],
                strokeCapRound: true,
                radius: 60,
                backgroundColor: Colors.transparent,
                stokeWidth: 7,
                value: 1,
                totalAngle: 2*pi,
              ),
            ),
          ),

          // 圆环
          Center(
            child: Container(
              child: GradientCircularProgressIndicator(
                colors: <Color>[
                  HexColor('4778f7'),
                  HexColor('66f7f9'),
                ],
                strokeCapRound: true,
                radius: 60,
                backgroundColor: Colors.transparent,
                stokeWidth: 7,
                value: 0.65,
                totalAngle: 2*pi,
              ),
            ),
          ),

          // 功率和水位
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text('1254',
                      style: TextStyle(color: Colors.white, fontSize: 35,fontFamily: 'ArialNarrow'))),
              Center(
                  child: Text('kW',
                      style: TextStyle(color: Colors.white, fontSize: 15,fontFamily: 'ArialNarrow'))),
            ],
          ),
        ],
      ),
    );
  }
}
