import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/debug/debug_api.dart';
import 'package:hsa_app/debug/model/weather.dart';
import 'package:hsa_app/event/event_bird.dart';

class StationWeatherWidget extends StatefulWidget {
  final double longtitude;
  final double latitude;
  final Function(String weather) onWeahterResponse;

  const StationWeatherWidget({Key key, this.onWeahterResponse, this.longtitude,this.latitude})
      : super(key: key);

  @override
  _StationWeatherWidgetState createState() => _StationWeatherWidgetState();
}

class _StationWeatherWidgetState extends State<StationWeatherWidget> {

  String weather = '晴';
  int type = 0;

  @override
  void initState() {
    requestWeather(widget.longtitude,widget.latitude);
    super.initState();
  }

  // 彩云天气
  void requestWeather(double longtitude,double latitude) async {
    DebugAPI.getWeather(longitude: longtitude,latitude: latitude,
      onSucc: (weather){
        String skycon = weather.skycon ?? '';
        
        if(skycon == 'CLEAR_DAY' || skycon == 'CLEAR_NIGHT'){
          this.type = 0;
        }else if(skycon == 'PARTLY_CLOUDY_DAY' || skycon == 'PARTLY_CLOUDY_NIGHT' || skycon == 'CLOUDY' || 
                  skycon == 'LIGHT_HAZE' || skycon == 'MODERATE_HAZE' || skycon == 'HEAVY_HAZE' || 
                  skycon == 'FOG' || skycon == 'DUST' || skycon == 'SAND' || skycon == 'WIND'){
          this.type = 1;         
        }else if(skycon == 'LIGHT_RAIN' || skycon == 'MODERATE_RAIN' || skycon == 'HEAVY_RAIN' || 
                  skycon == 'STORM_RAIN' || skycon == 'LIGHT_SNOW' || skycon == 'MODERATE_SNOW' || 
                  skycon == 'HEAVY_SNOW' || skycon == 'STORM_SNOW' || skycon == 'THUNDER_SHOWER' ||
                  skycon == 'HAIL' || skycon == 'SLEET'){
          this.type = 2;             
        }
        setState(() {
          this.weather = weather.weatherStr;
          EventBird().emit('REFRESH_WEATHER',this.weather);
        });
        
        if (widget.onWeahterResponse != null)
        widget.onWeahterResponse(this.weather);
      },onFail: (msg){
        setState(() {
          this.weather = '晴';
        });
        if (widget.onWeahterResponse != null)
        widget.onWeahterResponse(this.weather);
      }
    
    );

    // API.weatherCaiyun(geo, (type) {
    //   setState(() {
    //     if (type == 0) {
    //       this.weather = '晴';
    //     } else if (type == 1) {
    //       this.weather = '多云';
    //     } else if (type == 2) {
    //       this.weather = '雨';
    //     }
    //   });
    //   if (widget.onWeahterResponse != null)
    //     widget.onWeahterResponse(this.weather);
    // }, (_) {
    //   setState(() {
    //     this.weather = '晴';
    //   });
    //   if (widget.onWeahterResponse != null)
    //     widget.onWeahterResponse(this.weather);
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (0 == type) {
      return Image.asset('images/station/GL_sun_icon.png');
    }
    if (1 == type) {
      return Image.asset('images/station/GL_cloudy_icon.png');
    }
    if (2 == type) {
      return Image.asset('images/station/GL_rain_icon.png');
    }
    return Container();
  }
}
