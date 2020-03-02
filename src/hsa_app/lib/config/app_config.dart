import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/model/package.dart';
import 'package:package_info/package_info.dart';

class AppConfig {

  LeanCloudEnv env;
  Package remotePackage = Package();
  String localDisplayVersionString    = '';
  int    localBuildVersion            = 0;
  TargetPlatform platform;

  String numberFontName = 'DINCondensedC';

  static initConfig() async {
    // ⚠️ 环境控制
    AppConfig.getInstance().env     = LeanCloudEnv.test;
    AppConfig.getInstance().remotePackage = Package();
    AppConfig.getInstance().localVersion();
    AppConfig.getInstance().platform = defaultTargetPlatform;
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