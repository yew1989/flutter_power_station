import 'package:flutter/material.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class StationWaveWidget extends StatefulWidget {
  
  final StationInfo station;

  const StationWaveWidget(this.station,{Key key}) : super(key: key);

  @override
  _StationWaveWidgetState createState() => _StationWaveWidgetState();
}

class _StationWaveWidgetState extends State<StationWaveWidget> {


  double caculateWaveRatio(StationInfo station) {
    var waterMax = station?.water?.max ?? 0.0;
    var waterCurrent = station?.water?.current ?? 0.0;
    if( waterMax == 0 ) return 0.0;
    if( waterCurrent == 0 ) return 0.0; 
    if( waterCurrent > waterMax) return 1;
    var ratio =  waterCurrent / waterMax;
    return ratio;

  }

  double caculateUIWave(double waveRatio) {
    if(waveRatio > 1)  {
      waveRatio = 1;
    }
    var wave = 0.75 - (waveRatio / 2);
    return wave;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;    
    final waveRatio = caculateWaveRatio(widget.station);
    final wave      = caculateUIWave(waveRatio);
    return Center(
       child: WaveWidget(
         waveFrequency: 3.6,
         config: CustomConfig(
           gradients: [[Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)]],
           durations: [10000],
           heightPercentages: [wave],
           gradientBegin: Alignment.topCenter,
           gradientEnd: Alignment.bottomCenter
           ),
           waveAmplitude: 0,
           backgroundColor: Colors.transparent,
           size: Size(width, double.infinity),
          ),
      );
  }
  
}