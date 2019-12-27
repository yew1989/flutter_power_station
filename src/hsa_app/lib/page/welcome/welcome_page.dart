import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/package.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/service/jpush_service.dart';
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
  void upgradeWorkFlow(BuildContext context,Package package) {
    if(package == null) {
      debugPrint(' ❌ 版本信息文件获取失败 Package 为空 ');
      Progresshud.showInfoWithStatus('版本信息文件获取失败');
      return;
    }
    // 保存包管理信息
    AppConfig.getInstance().remotePackage = package;
    // 本地版本比远程版本还新,进入App
    if(isRemoteBiggerThanLocal() == false) {
      enterApp(context);
      return;
    }
    // 强制更新
    if(isForceUpdate() == true) {
        VersionManager.showForceUpgradeDialog(context:context, 
        title:AppConfig.getInstance().remotePackage.upgradeTitle, 
        content:AppConfig.getInstance().remotePackage.upgradeInfo,
        onTapAction:(){
          jumpToUpgradeUrl();
          return;
        });
    }
    // 用户手动选择更新
    else {
        VersionManager.showManualUpgradeDialog(context:context, 
        title:AppConfig.getInstance().remotePackage.upgradeTitle, 
        content:AppConfig.getInstance().remotePackage.upgradeInfo,
        onTapAction:(){
          jumpToUpgradeUrl();
          return;
        },
        onTapCancel: (){
          enterApp(context);
          return;
        });
    }
  }

  // 跳转到URL
  void jumpToUpgradeUrl() async {
    await Future.delayed(Duration(milliseconds: 500));
    final jumpUrl = isProductionEnv() ? AppConfig.getInstance().remotePackage.urlMarket
    : AppConfig.getInstance().remotePackage.urlWeb;
    VersionManager.goToUpgradeWebUrl(jumpUrl);
  }

  // 进入App
  void enterApp(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    pushToPageAndKill(context,LoginPage());
  }

  // 远程版本是否大于本地版本
  bool isRemoteBiggerThanLocal() {
    final remoteBuildVersion = AppConfig.getInstance().remotePackage.buildVersion;
    final loacalBuildVersion = AppConfig.getInstance().localBuildVersion;
    return remoteBuildVersion > loacalBuildVersion;
  }

  // 强制更新
  bool isForceUpdate() {
    return AppConfig.getInstance().remotePackage.isForced;
  }

  // 检测是否是生产环境
  bool isProductionEnv() {
    return LeanCloudEnv.product == AppConfig.getInstance().env;
  }

  // 获取版本管理信息
  void requestPackageInfo(BuildContext context) {
    // 获取版本信息
    LeanCloudAPI.getPackageVersionInfo(LeanCloudEnv.test,(Package pack, String msg) {
      debugPrint(' 🎉 版本信息文件获取成功');
      debugPrint(pack.toJson().toString());
      setState(() {
        displayVersion   = pack?.displayVersion ?? '';
        displayBuild     = pack?.displayBuild ?? '';
      });
      upgradeWorkFlow(context,pack);
    }, (String msg) {
      debugPrint(' ❌ 版本信息文件获取失败 ');
      if(msg == '请求错误') {
         Progresshud.showInfoWithStatus('请检查网络');
         retryRequestPackageInfo(context);
      }
    });
  }

  // 重试获取版本信息
  void retryRequestPackageInfo(BuildContext contex) async {
    debugPrint('🔥发起重试:获取版本信息...');
    await Future.delayed(Duration(seconds: 3));
    requestPackageInfo(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('生命周期改变:' + state.toString());
    if (state == AppLifecycleState.resumed) {
      requestPackageInfo(context);
    }
  }

  // 初始化友盟 
  void initUmengService() async{
    await Future.delayed(Duration(milliseconds: 500));
    UMengAnalyticsService.init();
  }

  // 推送
  void initJpush() async {
    await Future.delayed(Duration(milliseconds: 100));
    jpush = JpushService.init();
  }

  @override
  void initState() {
    DeviceInspector.inspectDevice(context);
    initUmengService();
    initJpush();
    WidgetsBinding.instance.addObserver(this);
    requestPackageInfo(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                        child: Text('Copyright @ fjlead 2019-2020',
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
