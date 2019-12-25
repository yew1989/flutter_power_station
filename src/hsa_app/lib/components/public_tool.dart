import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      final route = CupertinoPageRoute(builder: (context) => page);
      Navigator.of(context,rootNavigator: true).push(route);
  }

  pushToPageAndKill(BuildContext context,Widget page){
    // final route = MaterialPageRoute(builder: (context) => page);
    // Navigator.of(context).pushAndRemoveUntil(route, (route) => route == null);
     final route = CupertinoPageRoute(builder: (_) => page);
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

  // 进度条 loading
  void progressShowLoading(String msg) {
    if( msg == null ) return;
    Progresshud.showWithStatus(msg);
  }

  // 进度条 success
  void progressShowSuccess(String msg) {
    Progresshud.dismiss();
    if( msg == null ) return;
    Progresshud.showSuccessWithStatus(msg);
  }

  // 进度条 Info
  void progressShowInfo(String msg) {
    Progresshud.dismiss();
    if( msg == null ) return;
    Progresshud.showWithStatus(msg);
  }

  // 进度条 fail
  void progressShowError(String msg) {
    Progresshud.dismiss();
    if( msg == null ) return;
    Progresshud.showErrorWithStatus(msg);
  }

  //进度条 dismiss
  void progressDismiss(String msg) {
    Progresshud.dismiss();
  }
  