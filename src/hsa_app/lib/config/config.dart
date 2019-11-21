import 'package:hsa_app/model/pageConfig.dart';

enum EnvVersion { 
   iosDev, 
   androidDev, 
   iosTest, 
   androidTest, 
   iosProduct, 
   androidProduct, 
}

class AppConfig {

  EnvVersion   envVersion;
  PageConfig pageConfig;
  String deadLink = 'http://www.google.cn/intl/zh-CN/chrome/browser/';
  String webHost = '';
  PageBundle pageBundle;

  static initConfig() {
    AppConfig.getInstance().envVersion  = EnvVersion.iosDev;
  }
  
  AppConfig._();

  static AppConfig _instance;

  static AppConfig getInstance() {
    if (_instance == null) {
      _instance = AppConfig._();
    }
    return _instance;
  }
}