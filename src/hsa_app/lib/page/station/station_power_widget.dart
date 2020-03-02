import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/station_info.dart';

class StationPowerWidget extends StatefulWidget {
  
  final StationInfo stationInfo;

  const StationPowerWidget(this.stationInfo,{Key key}) : super(key: key);
  @override
  _StationPowerWidgetState createState() => _StationPowerWidgetState();
}

class _StationPowerWidgetState extends State<StationPowerWidget> {
  @override
  Widget build(BuildContext context) {
    
   final current = widget?.stationInfo?.power?.current ?? 0.0;
   final max = widget?.stationInfo?.power?.max ?? 0.0;

   return Center(
     child: RichText(
       text: TextSpan(
         children: 
            [
              TextSpan(text:current.toString(),style: TextStyle(color: Colors.white,fontFamily: AppConfig.getInstance().numberFontName,fontSize: 25)),
              TextSpan(text:'/',style: TextStyle(color: Colors.white,fontFamily: AppConfig.getInstance().numberFontName,fontSize: 18)),
              TextSpan(text:max.toString(),style: TextStyle(color: Colors.white,fontFamily: AppConfig.getInstance().numberFontName,fontSize: 18)),
              TextSpan(text:'kW',style: TextStyle(color: Colors.white,fontFamily: AppConfig.getInstance().numberFontName,fontSize: 16)),
            ]
          ),
        ),
    );
  }
}