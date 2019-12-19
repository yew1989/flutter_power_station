import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:lcfarm_flutter_umeng/lcfarm_flutter_umeng.dart';

class UMengAnalyticsService {

  static String getChannelName() {
    var env = AppConfig.getInstance().env;
    if(env == LeanCloudEnv.dev) return '开发';
    if(env == LeanCloudEnv.test) return '测试';
    if(env == LeanCloudEnv.product) return '生产';
    return '未知';
  }

  static void init() {
      LcfarmFlutterUmeng.init(
        iOSAppKey: '5df9724c0cafb2eaed000202',
        androidAppKey: '5df9720d4ca357120b000d92',
        channel: getChannelName(),
        logEnable: false,
        encrypt: true);
  }

  static void enterPage(String name) {
    if(name == null) return;
    if(name.length == 0) return;
    LcfarmFlutterUmeng.beginLogPageView(name);
  }

  static void exitPage(String name) {
    if(name == null) return;
    if(name.length == 0) return;
    LcfarmFlutterUmeng.endLogPageView(name);
  }

  static void logEvent(String eventId,String label) {
    if(eventId == null) return;
    if(eventId.length == 0) return;
    if(label == null) return;
    if(label.length == 0) return;
    LcfarmFlutterUmeng.event(eventId,label:label);
  }
}