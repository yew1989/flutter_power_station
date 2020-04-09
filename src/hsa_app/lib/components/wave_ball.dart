import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/circle_indicator.dart';
import 'package:hsa_app/components/wave_widget.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:native_color/native_color.dart';

class WaveValuePack {
  
  double wava1 = 0.0;
  double wave2 = 0.0;
  
  WaveValuePack({this.wava1,this.wave2});

  static double caculateWaveRatio(StationInfo station) {

    var waterMax = station?.reservoirAlarmWaterStage ?? 0.0;
    var waterCurrent = station?.reservoirCurrentWaterStage ?? 0.0;
    if( waterMax == 0 ) return 0.0;
    if( waterCurrent == 0 ) return 0.0; 
    if( waterCurrent > waterMax) return 1;
    var ratio =  waterCurrent / waterMax;
    return ratio;

  }

  static WaveValuePack caculateUIWave(double waveRatio) {
    
    var waterPercent = 1 - waveRatio;
    var wave1 = waterPercent + 0.01;
    var wave2 = waterPercent + 0.02;
    return WaveValuePack(wava1: wave1,wave2: wave2);

  }
}


class PowerValuePack {
  
  double powerRatio;
  PowerValuePack(this.powerRatio);

  static double caculateWaveRatio(StationInfo station) {

    var powerMax = station?.totalEquippedKW ?? 0.0;
    var powerCurrent = station?.totalActivePower ?? 0.0;
    // if(station.waterTurbines != null){
    //   station.waterTurbines.map((wt){
    //     powerCurrent += wt.deviceTerminal?.nearestRunningData?.current ?? 0.0 ;
    //   }).toList();
    // }
   
    if( powerMax == 0 ) return 0.0;
    if( powerCurrent == 0 ) return 0.0; 
    if( powerCurrent > powerMax) return 1;
    var ratio =  powerCurrent / powerMax;
    return ratio;

  }
}


class WaveBall extends StatefulWidget {

  final StationInfo station;
  const WaveBall({Key key, this.station}) : super(key: key);

  @override
  _WaveBallState createState() => _WaveBallState();
}

class _WaveBallState extends State<WaveBall> {
  
  @override
  Widget build(BuildContext context) {

    var waterRatio = WaveValuePack.caculateWaveRatio(widget.station);
    var wavePack = WaveValuePack.caculateUIWave(waterRatio);
    var powerRatio = PowerValuePack.caculateWaveRatio(widget.station);

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
                    heightPercentages: [wavePack.wava1,wavePack.wave2],
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
                value: powerRatio ?? 0.0,
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
                  child: Text(widget.station?.totalActivePower.toString() ??'0.0',
                      style: TextStyle(color: Colors.white, fontSize: 35,fontFamily: AppTheme().numberFontName))),
              Center(
                  child: Text('kW',
                      style: TextStyle(color: Colors.white, fontSize: 15,fontFamily: AppTheme().numberFontName))),
            ],
          ),
        ],
      ),
    );
  }
}
