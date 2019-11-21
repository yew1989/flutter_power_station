import 'package:flutter/cupertino.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/version.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

enum VersionUpdateState {  
   fail,
   noUpdate,
   canUpdate,
}

class VersionManager {

  static Future<VersionItem> getRemoteVerionForCurrentDevice() async {
    var version = await API.getAppVersionRemote();
    final env = AppConfig.getInstance().envVersion;
      switch (env) {
        case EnvVersion.iosDev:
          return version.versionInfo.iOSDev;
          break;
        case EnvVersion.androidDev:
          return version.versionInfo.androidDev;
          break;
        case EnvVersion.iosTest:
          return version.versionInfo.iOSTest;
          break;
        case EnvVersion.androidTest:
          return version.versionInfo.androidTest;
          break;
        case EnvVersion.iosProduct:
          return  version.versionInfo.iOSProduct;
          break;
        case EnvVersion.androidProduct:
          return version.versionInfo.androidProduct;
          break;
        default:
      }
    return null;
  }

  static Future<VersionUpdateState> checkNewVersionWithPopAlert(BuildContext context,Function onTapAction,Function onTapCanel) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersionString = packageInfo.buildNumber;
    var item = await VersionManager.getRemoteVerionForCurrentDevice();
    if(item == null) return VersionUpdateState.fail;
    
    var local  = int.tryParse(localVersionString) ?? 0;
    var remote = int.tryParse(item.versionCode) ?? 0;
    
    debugPrint('🍬版本管理:本地版本 $local');
    debugPrint('🍬版本管理:远端版本 $remote');

    if(local >= remote) {
      debugPrint('🍬版本管理:本地版本高于服务器,无需更新');
      return VersionUpdateState.noUpdate;
    }
    else{
      debugPrint('🍬版本管理:检测到服务器有新版本');
      
      var force = item.lastForce;
      var title = '提示';
      var content = item.upgradeInfo ?? '发现新版本,是否立即更新?';
      var url = item.upgradeUrl ?? '';

      if(force) {
        debugPrint('🍬版本管理:强制更新 开启');
        showForceUpdateDialog(context, title, content,(){
          goToUpdateWebUrl(url);
          if(onTapAction != null)onTapAction();
        });
      }
      else {
        debugPrint('🍬版本管理:强制更新 关闭');
        showUpdateDialog(context, title, content,(){
          goToUpdateWebUrl(url);
          if(onTapAction != null)onTapAction();
        },(){
          if(onTapCanel != null)onTapCanel();
        });
      }
      return VersionUpdateState.canUpdate;
      
    }
  }


  static void goToUpdateWebUrl(String url) async {
    if (await launcher.canLaunch(url)) {
      await launcher.launch(url);
    }   else {
     throw 'Could not launch $url';
    }
  }

  // 非强制更新
  static showUpdateDialog(BuildContext context,String title,String content,Function onTapAction,Function onTapCancel) {
    showCupertinoDialog<int>(
        context: context,
        builder: (t) {
          var dialog =  CupertinoAlertDialog(
            title:   Text(title),
            content:   Text(content),
            actions: <Widget>[
                CupertinoDialogAction(
                child:   Text('立即更新'),
                isDefaultAction: true,
                onPressed: (){
                   if(onTapAction != null) onTapAction();
                   Navigator.of(t).pop();
                },
              ),
              CupertinoDialogAction(
                child:   Text('稍后再说'),
                isDestructiveAction: true,
                onPressed: () {
                  if(onTapCancel != null) onTapCancel();
                  Navigator.of(t).pop();
                },
              ),
            ],
          );
          return dialog;
    });
  }

  // 强制更新
  static showForceUpdateDialog(BuildContext context,String title,String content,Function onTapAction) {
    showCupertinoDialog<int>(
        context: context,
        builder: (t) {
          var dialog =  CupertinoAlertDialog(
            title:   Text(title),
            content:   Text(content),
            actions: <Widget>[
                CupertinoDialogAction(
                child:   Text('立即更新'),
                isDefaultAction: true,
                onPressed: (){
                   if(onTapAction != null) onTapAction();
                   Navigator.of(t).pop();
                },
              ),
            ],
          );
          return dialog;
    });
  }


}
