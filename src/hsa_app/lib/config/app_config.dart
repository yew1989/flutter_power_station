import 'package:flutter/foundation.dart';
import 'package:hsa_app/util/share_manager.dart';
import 'package:package_info/package_info.dart';

class AppConfig {

  // 本地展示字符串
  String localDisplayVersionString;
  // 本地版本号
  int localBuildVersion;
  // 平台标识
  String platform;
  // 设备唯一标识
  String uuid;
  // 设备召测的时间间隔(默认值)
  int deviceQureyTimeInterval;
  // 电站概要页动画播放时间持续时间
  int stationPageAnimationDuration;
  // 运行参数页动画播放时间持续时间
  int runtimePageAnimationDuration;
  // app版本类型 Canary 金丝雀版 Dev 开发版 Beta 测试版 Stable 稳定版
  String appVersionType;
  // 本地构建版本号 展示
  String displayBuildVersion;

  static initConfig() async {

    AppConfig.getInstance().platform = defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android';
    AppConfig.getInstance().deviceQureyTimeInterval = 5;
    AppConfig.getInstance().stationPageAnimationDuration = 5;
    AppConfig.getInstance().runtimePageAnimationDuration = 5;
    AppConfig.getInstance().uuid = await ShareManager().loadUUID();
    AppConfig.getInstance().appVersionType = 'Dev';
    AppConfig.getInstance().displayBuildVersion = 'Build 20200529';
    debugPrint('🆔UUID:' + AppConfig.getInstance().uuid);
    localVersion();
  }

  static void localVersion() async {
    var log = '';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localBuildVersionString = packageInfo?.buildNumber ?? '0';
    AppConfig.getInstance().localBuildVersion = int.tryParse(localBuildVersionString) ?? 0;
    String localDisplayVersionString = packageInfo?.version ?? '1.0.0';
    AppConfig.getInstance().localDisplayVersionString = localDisplayVersionString;
    log += '本地构建版本号:' + localBuildVersionString + '  ';
    log += '本地展示版本号:' + localDisplayVersionString + '  ';
    debugPrint(log);
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