import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/model/model/package.dart';
import 'package:package_info/package_info.dart';

class AppConfig {

  LeanCloudEnv env;
  Package remotePackage = Package();
  String localDisplayVersionString    = '';
  int    localBuildVersion            = 0;
  TargetPlatform platform;
  
  // 设备召测的时间间隔(默认值)
  int deviceQureyTimeInterval;
  // 电站概要页动画播放时间持续时间
  int stationPageAnimationDuration;
  // 运行参数页动画播放时间持续时间
  int runtimePageAnimationDuration;

  static initConfig(LeanCloudEnv env) async {
    AppConfig.getInstance().env     = env ?? LeanCloudEnv.test;
    AppConfig.getInstance().remotePackage = Package();
    AppConfig.getInstance().localVersion();
    AppConfig.getInstance().platform = defaultTargetPlatform;
    AppConfig.getInstance().deviceQureyTimeInterval = 5;
    AppConfig.getInstance().stationPageAnimationDuration = 3;
    AppConfig.getInstance().runtimePageAnimationDuration = 4;
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