class Weather{

  String status;
  String skycon;
  String weatherStr;

  Weather({this.status,
    this.skycon,this.weatherStr});

  Weather.fromJson(Map<String, dynamic> json){
    status = json['status'];
    skycon = json['skycon'];
    weatherStr = skycontoChinese(skycon);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['skycon'] = this.skycon;
    data['weatherStr'] = this.weatherStr;
    return data;
  }

  String skycontoChinese(String str){
    Map<String, String> weatherState = Map<String, String>();
    weatherState['CLEAR_DAY'] = '晴';
    weatherState['CLEAR_NIGHT'] = '晴';
    weatherState['PARTLY_CLOUDY_DAY'] = '多云';
    weatherState['PARTLY_CLOUDY_NIGHT'] = '多云';
    weatherState['CLOUDY'] = '阴';
    weatherState['LIGHT_HAZE'] = '轻度雾霾';
    weatherState['MODERATE_HAZE'] = '中度雾霾';
    weatherState['HEAVY_HAZE'] = '重度雾霾';
    weatherState['LIGHT_RAIN'] = '小雨';
    weatherState['MODERATE_RAIN'] = '中雨';
    weatherState['HEAVY_RAIN'] = '大雨';
    weatherState['STORM_RAIN'] = '暴雨';
    weatherState['FOG'] = '雾';
    weatherState['LIGHT_SNOW'] = '小雪';
    weatherState['MODERATE_SNOW'] = '中雪';
    weatherState['HEAVY_SNOW'] = '大雪';
    weatherState['STORM_SNOW'] = '暴雪';
    weatherState['DUST'] = '浮尘';
    weatherState['SAND'] = '沙尘';
    weatherState['WIND'] = '大风';
    weatherState['THUNDER_SHOWER'] = '雷阵雨';
    weatherState['HAIL'] = '冰雹';
    weatherState['SLEET'] = '雨夹雪';

    return weatherState[str];
  }
  

}