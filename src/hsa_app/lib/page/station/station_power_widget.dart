import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/station.dart';

class StationPowerWidget extends StatefulWidget {
  
  final StationInfo stationInfo;

  const StationPowerWidget(this.stationInfo,{Key key}) : super(key: key);
  @override
  _StationPowerWidgetState createState() => _StationPowerWidgetState();
}

class _StationPowerWidgetState extends State<StationPowerWidget> {
  @override
  Widget build(BuildContext context) {
    
    StationInfo info = widget?.stationInfo ?? new StationInfo();
    double cur = 0.0;
    if(info.waterTurbines != null){
      info.waterTurbines.map((wt){ 
        cur += wt?.deviceTerminal?.nearestRunningData?.current ?? 0.0;
      }).toList();
    }
    

   final current = cur ?? 0.0;
   final max = widget?.stationInfo?.totalEquippedKW ?? 0.0;

   return Center(
     child: RichText(
       text: TextSpan(
         children: 
            [
              TextSpan(text:current.toString(),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 25)),
              TextSpan(text:'/',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:max.toString(),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:'kW',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 16)),
            ]
          ),
        ),
    );
  }
}