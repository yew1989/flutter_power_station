import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/util/device_inspector.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JpushService {

  static const jpushAppKey = 'cb3580ff62711e058fb12966';
  static const channelName = 'PRODUCT'; // 生产 'PRODUCT' 测试 'TEST'

  static JPush init() {

    // 模拟器不初始化极光推送组件
    if(DeviceInfo.getInstance().isSimulator == true) {
      debugPrint('🐦推送未初始化:模拟器无法获取RegID');
      return null;
    }

    var jpush = JPush();
    final isProduction = AppConfig.getInstance().env == LeanCloudEnv.product ? true : false;
    
    jpush.setup(appKey: jpushAppKey, production: isProduction,debug: ! isProduction,channel: channelName);
    jpush.applyPushAuthority(NotificationSettingsIOS(sound: true,alert: true,badge: true));

    jpush.getRegistrationID().then((regId) {
      if(regId == null) return;
      if(regId.length == 0) return;
      debugPrint('🐦推送RegID :' + regId);
    });

    jpush.addEventHandler(
      onOpenNotification: (Map<String, dynamic> message) {
        debugPrint('🐦推送已开启:' + message.toString());
        return;
      },
      onReceiveMessage: (Map<String, dynamic> message){
        debugPrint('🐦已接收推送消息:' + message.toString());
        return;
      },
      onReceiveNotification: (Map<String, dynamic> message){
        debugPrint('🐦已接收推送通知:' + message.toString());
        return;
      },
    );
    return jpush;
  }

}