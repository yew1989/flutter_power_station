import 'package:flutter/material.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/components/wave_widget.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:native_color/native_color.dart';

class StationWaveWidget extends StatefulWidget {
  
  final StationInfo station;

  const StationWaveWidget(this.station,{Key key}) : super(key: key);

  @override
  _StationWaveWidgetState createState() => _StationWaveWidgetState();
}

class _StationWaveWidgetState extends State<StationWaveWidget> {


  double caculateWaveRatio(StationInfo station) {
    var waterMax = station?.reservoirAlarmWaterStage ?? 0.0;
    var waterCurrent = station?.reservoirCurrentWaterStage ?? 0.0;
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
      child: Stack(
        children: <Widget>[
                 Center(
              child: WaveWidget(
               waveFrequency: 1.8,
               config: CustomConfig(
                 gradientBegin:Alignment.centerRight,
                 gradientEnd: Alignment.centerLeft,
                 gradients: [
                    [HexColor('ff4296bc'),HexColor('ff4296bc')],
                    [HexColor('66147cc1'),HexColor('66147cc1')],
                  ],
                 durations: [2000,3000],
                 heightPercentages: [wave,wave],
                 ),
                 waveAmplitude: 0,
                 backgroundColor: Colors.transparent,
                 size: Size(width, double.infinity),
                ),
          ),
          Positioned(
            bottom: 0,left: 0,right: 0,child: WaterPoolWaveShawdow(),
          ),
        ],
      ),
    );
  }
  
}