import 'package:dio/dio.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:syncfusion_flutter_core/core.dart';

// 启动 APP时的一些配置和流程
class BootApp {
  static void boot(){
    // 生产环境
    AppConfig.initConfig(LeanCloudEnv.product);
    // 注册 SyncfusionLicense
    SyncfusionLicense.registerLicense("NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmhia2NnZWNmYGJqYBNiZWB9MDw+");
    // 外网连接尝试
    touch('http://www.baidu.com');
  }

  // Touch 外网 用于 IOS 下触发网络权限对话框
  static void touch(String url) async {
    await Dio().get(url);
  }
}