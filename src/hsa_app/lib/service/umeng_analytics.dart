import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';

class UMengAnalyticsService {

  static void init() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      UMengAnalytics.init('5df9720d4ca357120b000d92',
      logEnable:true,
      policy: Policy.BATCH, encrypt: true, reportCrash: true);
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      UMengAnalytics.init('5df9724c0cafb2eaed000202',
      logEnable:true,
      policy: Policy.BATCH, encrypt: true, reportCrash: true);
    }  
  }

  static void enterPage(String name) {
    if(name == null) return;
    if(name.length == 0) return;
    UMengAnalytics.beginPageView(name);
  }

  static void exitPage(String name) {
    if(name == null) return;
    if(name.length == 0) return;
    UMengAnalytics.endPageView(name);
  }

  static void logEvent(String name) {
    if(name == null) return;
    if(name.length == 0) return;
    UMengAnalytics.logEvent(name,label:name);
  }
}