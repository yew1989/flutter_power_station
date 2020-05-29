// APP更新流程
import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_publish.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/service/versionManager.dart';
import 'package:ovprogresshud/progresshud.dart';

class UpgradeWorkFlow {

  // 开始入口
  void start(BuildContext context) async {
    requestPublishInfo(context);
  }
  
  // 获取版本管理信息
  void requestPublishInfo(BuildContext context) async {

    await Future.delayed(Duration(milliseconds: 5000));
    
    APIPublish.getMobileAppPublishInfo((publish) { 
      upgradeWorkFlow(context,publish);
    }, (msg) { 
      debugPrint(' ❌ 版本信息文件获取失败 ');
      retryRequestPublishInfo(context);
    });
  }

    // 重试获取版本信息
  void retryRequestPublishInfo(BuildContext context) async {
    debugPrint('🔥发起重试:获取版本信息...');
    await Future.delayed(Duration(seconds: 3));
    requestPublishInfo(context);
  }

    // 版本更新工作流
  void upgradeWorkFlow(BuildContext context,Publish publish) {

    if(publish == null) {
      Progresshud.showInfoWithStatus('版本信息文件获取失败');
      return;
    }

    // 用户手动选择更新 (非强制更新流程)
    if(isForceUpdate(publish) == false) {
        // 本地版本比远程版本还新,进入App
        if(isRemoteBiggerThanLocal(publish) == false) {
          enterApp(context);
          return;
        }
        // 建议更新
        showManualDialog(context, publish);
    }
     // 强制更新
    else if (isForceUpdate(publish) == false){
        // 本地版本比远程版本还新,进入App
        if(isRemoteBiggerThanLocal(publish) == false) {
          enterApp(context);
          return;
        }
        // 本地版本小于兼容版本,强行更新
        if(isRemoteLowestVersionBiggerThanLocal(publish) == true) {
          showManualDialog(context, publish);
        }
        // 本地版本大于兼容版本,但小于远程版本,建议更新
        else if(isRemoteLowestVersionBiggerThanLocal(publish) == false) {
          showForceDialog(context, publish);
        }
    }
  }

  void showManualDialog(BuildContext context,Publish publish) {
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

  void showForceDialog(BuildContext context,Publish publish) {
        VersionManager.showForceUpgradeDialog(
        context:context,
        title:'发现新版本',
        content:publish.updateDescription ?? '',
        onTapAction:(){
          jumpToUpgradeUrl(publish);
          return;
        });
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
    final remote = publish?.publishVersion ?? 0;
    final local = AppConfig.getInstance().localBuildVersion;
    return remote > local;
  }

  // 强制更新情况下,判断兼容版本号,若兼容版本号大于本地 则强制更新使能.
  bool isRemoteLowestVersionBiggerThanLocal(Publish publish) {
    final remote = publish?.cmptVersion ?? 0;
    final local = AppConfig.getInstance().localBuildVersion;
    return remote > local;
  }

  // 强制更新
  bool isForceUpdate(Publish publish) {
    return publish?.isForceUpdate ?? false;
  }

}