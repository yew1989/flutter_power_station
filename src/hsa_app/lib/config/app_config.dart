import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/model/package.dart';
import 'package:package_info/package_info.dart';

class AppConfig {

  LeanCloudEnv env;
  String deadLink = 'http://www.google.cn/intl/zh-CN/chrome/browser/';
  Package package = Package();
  String localDisplayVersionString = '';
  int localBuildVersion            = 0;

  static initConfig() {
    AppConfig.getInstance().env     = LeanCloudEnv.test;
    AppConfig.getInstance().package = Package();
    AppConfig.getInstance().localVersion();
  }

  void localVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localBuildVersionString = packageInfo?.buildNumber ?? '0';
    AppConfig.getInstance().localBuildVersion = int.tryParse(localBuildVersionString) ?? 0;
    String localDisplayVersionString = packageInfo?.version ?? 'V1.0.0';
    AppConfig.getInstance().localDisplayVersionString = localDisplayVersionString;
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