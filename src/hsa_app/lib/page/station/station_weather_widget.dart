import 'package:flutter/material.dart';
import 'package:hsa_app/page/station/caiyun_weather.dart';

class StationWeatherWidget extends StatefulWidget {

  final WeatherPictureType pictureType;
  const StationWeatherWidget({Key key, this.pictureType = WeatherPictureType.sunny}) : super(key: key);

  @override
  _StationWeatherWidgetState createState() => _StationWeatherWidgetState();
}

class _StationWeatherWidgetState extends State<StationWeatherWidget> {

  @override
  Widget build(BuildContext context) {
    if ( WeatherPictureType.sunny == widget.pictureType) {
      return Image.asset('images/station/GL_sun_icon.png');
    }
    if ( WeatherPictureType.cloudy == widget.pictureType) {
      return Image.asset('images/station/GL_cloudy_icon.png');
    }
    if ( WeatherPictureType.rainny == widget.pictureType) {
      return Image.asset('images/station/GL_rain_icon.png');
    }
    return Container();
  }
}
