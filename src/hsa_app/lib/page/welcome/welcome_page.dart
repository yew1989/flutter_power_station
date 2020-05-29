import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_publish.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/model/publish.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/service/push/jpush_service.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/service/versionManager.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/device_inspector.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:ovprogresshud/progresshud.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {

  JPush jpush;
  String displayVersion = '';
  String displayBuild   = '';

  // 版本更新工作流
  void upgradeWorkFlow(BuildContext context,Publish publish) {
    if(publish == null) {
      debugPrint(' ❌ 版本信息文件获取失败 Package 为空 ');
      Progresshud.showInfoWithStatus('版本信息文件获取失败');
      return;
    }
    // 本地版本比远程版本还新,进入App
    if(isRemoteBiggerThanLocal(publish) == false) {
      enterApp(context);
      return;
    }
    // 强制更新
    if(isForceUpdate(publish) == true) {
        VersionManager.showForceUpgradeDialog(
        context:context,
        title:'发现新版本',
        content:publish.updateDescription ?? '',
        onTapAction:(){
          jumpToUpgradeUrl(publish);
          return;
        });
    }
    // 用户手动选择更新
    else {
        VersionManager.showManualUpgradeDialog(
        context:context,
        title:'发现新版本',
        content:publish.updateDescription ?? '',
        onTapAction:(){
          jumpToUpgradeUrl(publish);
          return;
        },
        onTapCancel: (){
          enterApp(context);
          return;
        });
    }
  }

  // 跳转到URL
  void jumpToUpgradeUrl(Publish publish) async {
    await Future.delayed(Duration(milliseconds: 500));
    final jumpUrl = publish?.installationPackageUrl ?? '';
    VersionManager.goToUpgradeWebUrl(jumpUrl);
  }

  // 进入App
  void enterApp(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 3));
    pushToPageAndKill(context,LoginPage());
  }

  // 远程版本是否大于本地版本
  bool isRemoteBiggerThanLocal(Publish publish) {
    final remoteBuildVersion = publish?.publishVersion ?? 0;
    final loacalBuildVersion = AppConfig.getInstance().localBuildVersion;
    return remoteBuildVersion > loacalBuildVersion;
  }

  // 强制更新
  bool isForceUpdate(Publish publish) {
    return publish?.isForceUpdate ?? false;
  }

  // 获取版本管理信息
  void requestPublishInfo(BuildContext context) async {

    await Future.delayed(Duration(milliseconds: 5000));
    
    APIPublish.getMobileAppPublishInfo((publish) { 
      if(!mounted) return;
      setState(() {
        this.displayVersion   =  publish?.displayVersionInfo ?? '';
        this.displayBuild     = 'Build 20200529';
      });
      upgradeWorkFlow(context,publish);
    }, (msg) { 
      debugPrint(' ❌ 版本信息文件获取失败 ');
      retryRequestPublishInfo(context);
    });
  }

  // 重试获取版本信息
  void retryRequestPublishInfo(BuildContext contex) async {
    debugPrint('🔥发起重试:获取版本信息...');
    await Future.delayed(Duration(seconds: 3));
    requestPublishInfo(context);
  }

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
    requestPublishInfo(context);
    initUmengService();
    initJpush();
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
                Positioned(
                    bottom: 90,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                        height: 28,
                        child: AspectRatio(
                            aspectRatio: 366 / 84,
                            child: Image.asset(
                                'images/welcome/Start_slogan.png')))),

                // 显示版本
                Positioned(
                    bottom: 54,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: Text('$displayVersion',style: TextStyle(color: Colors.white70, fontSize: 10)))),

                // 构建版本
                Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: Text('$displayBuild',style: TextStyle(color: Colors.white70, fontSize: 10)))),

                // 版权信息
                Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: Text('Copyright @ fjlead 2020-2021',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 10)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
