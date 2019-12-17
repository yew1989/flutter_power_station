import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/model/package.dart';

class AppConfig {

  LeanCloudEnv env;
  String deadLink = 'http://www.google.cn/intl/zh-CN/chrome/browser/';
  Package package = Package();

  static initConfig() {
    AppConfig.getInstance().env     = LeanCloudEnv.test;
    AppConfig.getInstance().package = Package();
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