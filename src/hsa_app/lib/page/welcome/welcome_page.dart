import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/package.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/service/versionManager.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/device_inspector.dart';
import 'package:package_info/package_info.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {

  String displayVersion = 'V1.0.0';

  void showDiplayVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localDisplayVersionString = packageInfo?.version ?? '1.0.0';
    setState(() {
      displayVersion =  'V' + localDisplayVersionString;
    });
  }
  // 版本更新工作流
  void upgradeWorkFlow(BuildContext context,Package package) {
    if(package == null) {
      exitApp(context);
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
      debugPrint('版本信息文件获取成功');
      debugPrint(pack.toJson().toString());
      upgradeWorkFlow(context,pack);
    }, (_) {
      debugPrint('版本信息文件获取失败');
      exitApp(context);
    });
  }


  // 关闭 App
  void exitApp(BuildContext context) async {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text('提示'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(' '),
              Text('版本信息获取失败'),
              Text(' '),
              Text('点击确认按钮将退出应用'),
              Text(' '),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('确认'),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 500), () => exit(0));
            },
          )
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint(state.toString());
    if (state == AppLifecycleState.resumed) {
      requestPackageInfo(context);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    showDiplayVersion();
    requestPackageInfo(context);
    DeviceInspector.inspectDevice(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void checkIsLogined() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   var token = await ShareManager.instance.loadToken();
  //   var isLogined = token.length > 0;
  //   debugPrint('🔑 本地Token:' + token);
  //   pushToPageAndKill(context, isLogined ? RootPage() : LoginPage());
  // }

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
                        child: Text(displayVersion ?? 'V1.0.0',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 10)))),

                // 构建版本
                Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: Text('Build 20191220',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 10)))),

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
