import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

enum VersionUpdateState {  
   fail,
   noUpdate,
   canUpdate,
}

class VersionManager {

  // 跳转界面
  static void goToUpgradeWebUrl(String url) async {
    if (await launcher.canLaunch(url)) {
      await launcher.launch(url);
    }   else {
     throw 'Could not launch $url';
    }
  }

  // 非强制更新,用户手动更新
  static showManualUpgradeDialog({BuildContext context,String title,String content,Function onTapAction,Function onTapCancel}) {
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
  static showForceUpgradeDialog({BuildContext context,String title,String content,Function onTapAction}) {
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
