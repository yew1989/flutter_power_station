import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:ovprogresshud/progresshud.dart';

showAlertViewDouble(BuildContext context, String title, String content,Function ontap) {
  showCupertinoModalPopup<int>(
      context: context,
      builder: (t) {
        var dialog = CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('确定'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(t).pop();
                if(ontap != null)ontap();
              },
            ),
            CupertinoDialogAction(
              child: Text('取消'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(t).pop();
              },
            ),
          ],
        );
        return dialog;
  });
}

showAlertViewSingle(BuildContext context, String title, String content,Function ontap) {
  showCupertinoModalPopup<int>(
      context: context,
      builder: (t) {
        var dialog = CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('确定'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(t).pop();
                if(ontap != null)ontap();
              },
            ),
          ],
        );
        return dialog;
  });
}

// Route Manager
  pushToPage(BuildContext context,Widget page) {
      var route = CupertinoPageRoute(builder: (_) => page);
      Navigator.of(context,rootNavigator: true).push(route);
  }

  pushToPageAndKill(BuildContext context,Widget page){
     var route = CupertinoPageRoute(builder: (_) => page);
     Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(route, (route) => route == null);
  }

// Toast
  showToast(String msg) {
    if (msg == null) return;
    if (msg.length == 0) return;
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }

// Hud

showSuccessHud(BuildContext context,String msg) {
  if(msg == null)return;
  if(msg.length == null)return;
  ProgressHud.of(context).showAndDismiss(ProgressHudType.success, msg);
}

showErrorHud(BuildContext context,String msg) {
  if(msg == null)return;
  if(msg.length == null)return;
  ProgressHud.of(context).showAndDismiss(ProgressHudType.error, msg);
}

showLoadingHud(BuildContext context) {
  var hud = ProgressHud.of(context);
  hud.show(ProgressHudType.progress, "loading");
}

dismissLoadingHud(BuildContext context) {

}

showProgressHudPeriodic(BuildContext context) {
  var hud = ProgressHud.of(context);
  hud.show(ProgressHudType.progress, "loading");

  double current = 0;
  Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
    current += 1;
    var progress = current / 100;
    hud.updateProgress(progress, "loading $current%");
    if (progress == 1) {
      hud.showAndDismiss(ProgressHudType.success, "load success");
      timer.cancel();
    }
  });
}
  