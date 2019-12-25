import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JpushService {

  static JPush init() {
    
    final isProduction = AppConfig.getInstance().env == LeanCloudEnv.product ? true : false;
    
    var jpush = JPush();

    jpush.setup(
      appKey:'cb3580ff62711e058fb12966', 
      production: isProduction,
      debug: !isProduction,
      channel: '',
    );

    jpush.applyPushAuthority(NotificationSettingsIOS(
      sound: true,alert: true,badge: true));

    jpush.getRegistrationID().then((regId) {
      debugPrint('🐦 🐦 🐦 推送RegistrationID 🐦 🐦 🐦:' + regId);
    });

    jpush.addEventHandler(
      onOpenNotification: (Map<String, dynamic> message) {
        debugPrint('onOpenNotification' + message.toString());
      },
      onReceiveMessage: (Map<String, dynamic> message){
        debugPrint('onReceiveMessage' + message.toString());
      },
      onReceiveNotification: (Map<String, dynamic> message){
        debugPrint('onReceiveNotification' + message.toString());
      }
    );
    return jpush;
  }

}