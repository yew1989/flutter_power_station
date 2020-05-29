import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_publish.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/model/publish.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/service/push/jpush_service.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/service/upgrade_workflow.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/util/device_inspector.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {

  JPush jpush;
  String displayVersion = '';
  String displayBuild   = '';
  UpgradeWorkFlow upgradeWorkFlow = UpgradeWorkFlow();
  
  // 初始化友盟统计
  void initUmengService() async{
    await Future.delayed(Duration(milliseconds: 500));
    UMengAnalyticsService.init();
  }

  // 初始化极光推送
  void initJpush() async {
    await Future.delayed(Duration(milliseconds: 500));
    jpush = JpushService.init();
  }

  @override
  void initState() {
    super.initState();
    DeviceInspector.inspectDevice();
    initUmengService();
    initJpush();
    showVersions();
    upgradeWorkFlow.start(context);
  }

  void showVersions() async {
    await Future.delayed(Duration(milliseconds: 250));
    this.displayVersion   =  'V' + AppConfig.getInstance().localDisplayVersionString;
    this.displayBuild     =  AppConfig.getInstance().displayBuildVersion;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: <Widget>[

                // 中央水背景图
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                        aspectRatio: 1125 / 664,
                        child: Image.asset('images/welcome/Start_water.png')),
                  ),
                ),

                // 发电从未如此简单 slogan
                Positioned(bottom: 90,left: 0,right: 0,
                    child: SizedBox(height: 28,
                        child: AspectRatio(aspectRatio: 366 / 84,
                            child: Image.asset('images/welcome/Start_slogan.png')))),

                // 显示版本
                Positioned(bottom: 54,left: 0,right: 0,
                    child: Center(child: Text('$displayVersion',style: TextStyle(color: Colors.white70, fontSize: 10)))),

                // 构建版本
                Positioned(bottom: 40,left: 0,right: 0,
                    child: Center(child: Text('$displayBuild',style: TextStyle(color: Colors.white70, fontSize: 10)))),

                // 版权信息
                Positioned(bottom: 8,left: 0,right: 0,
                    child: Center(child: Text('Copyright @ fjlead 2020-2021',
                    style: TextStyle(color: Colors.white70, fontSize: 10)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
