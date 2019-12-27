import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/model/station_info.dart';

class StationWeatherWidget extends StatefulWidget {
  final Geo geo;
  final Function(String weather) onWeahterResponse;

  const StationWeatherWidget({Key key, this.onWeahterResponse, this.geo})
      : super(key: key);

  @override
  _StationWeatherWidgetState createState() => _StationWeatherWidgetState();
}

class _StationWeatherWidgetState extends State<StationWeatherWidget> {

  String weather = '晴';

  @override
  void initState() {
    requestWeather(widget.geo);
    super.initState();
  }

  // 彩云天气
  void requestWeather(Geo geo) async {
    API.weatherCaiyun(geo, (type) {
      setState(() {
        if (type == 0) {
          this.weather = '晴';
        } else if (type == 1) {
          this.weather = '多云';
        } else if (type == 2) {
          this.weather = '雨';
        }
      });
      if (widget.onWeahterResponse != null)
        widget.onWeahterResponse(this.weather);
    }, (_) {
      setState(() {
        this.weather = '晴';
      });
      if (widget.onWeahterResponse != null)
        widget.onWeahterResponse(this.weather);
    });
  }

  @override
  Widget build(BuildContext context) {
    if ('晴' == weather) {
      return Image.asset('images/station/GL_sun_icon.png');
    }
    if ('多云' == weather) {
      return Image.asset('images/station/GL_cloudy_icon.png');
    }
    if ('雨' == weather) {
      return Image.asset('images/station/GL_rain_icon.png');
    }
    return Container();
  }
}
