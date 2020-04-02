import 'package:dio/dio.dart';
import 'package:hsa_app/model/response/weather_resp.dart';

// 天气类型
enum WeatherPictureType {
  sunny,
  cloudy,
  rainny,
}

// 天气数据体
class CaiyunWeatherData {
  final String name;
  final WeatherPictureType type;

  CaiyunWeatherData(this.name, this.type);
}

// 天气请求接口
class CaiyunWeatherAPI {

  // 获取天气
  static Future<CaiyunWeatherData> request (double longtitude,double latitude) async {
     
    //天气接口的版本
   final wVersion = 'v2.5';
   //天气接口token
   final wToken = 'TAkhjf8d1nlSlspN';
   // 地理位置参数
   final long = longtitude ?? 0.0;
   final lat  = latitude ?? 0.0;
   if(longtitude == 0.0 || lat == 0.0) {
     return CaiyunWeatherData('晴',WeatherPictureType.sunny);
   }
   
  final path = 'https://api.caiyunapp.com/'+wVersion+'/'+wToken+'/'+long.toString()+','+lat.toString()+'/realtime.json';
  
  Response response = await Dio().get(path);
  
  if (response == null) return CaiyunWeatherData('晴',WeatherPictureType.sunny);
  if (response.statusCode != 200) return CaiyunWeatherData('晴',WeatherPictureType.sunny);

  var resp = WeatherResp.fromJson(response.data);
  final skycon = resp?.result?.realtime?.skycon ?? '';
  final name   = resp?.result?.realtime?.weatherStr ?? '晴';

  if(skycon == 'CLEAR_DAY' || skycon == 'CLEAR_NIGHT'){
     return CaiyunWeatherData(name,WeatherPictureType.sunny);
  }else if(skycon == 'PARTLY_CLOUDY_DAY' || skycon == 'PARTLY_CLOUDY_NIGHT' || skycon == 'CLOUDY' || 
      skycon == 'LIGHT_HAZE' || skycon == 'MODERATE_HAZE' || skycon == 'HEAVY_HAZE' || 
      skycon == 'FOG' || skycon == 'DUST' || skycon == 'SAND' || skycon == 'WIND'){
      return CaiyunWeatherData(name,WeatherPictureType.cloudy);           
  }else if(skycon == 'LIGHT_RAIN' || skycon == 'MODERATE_RAIN' || skycon == 'HEAVY_RAIN' || 
          skycon == 'STORM_RAIN' || skycon == 'LIGHT_SNOW' || skycon == 'MODERATE_SNOW' || 
          skycon == 'HEAVY_SNOW' || skycon == 'STORM_SNOW' || skycon == 'THUNDER_SHOWER' ||
          skycon == 'HAIL' || skycon == 'SLEET'){    
          return CaiyunWeatherData(name,WeatherPictureType.rainny);      
  }else {
        return CaiyunWeatherData('晴',WeatherPictureType.sunny);
    }
  }
}