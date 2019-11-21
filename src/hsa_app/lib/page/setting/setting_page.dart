import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/draw/DrawCircel.dart';
import 'package:hsa_app/draw/DrawPaint.dart';
import 'package:hsa_app/draw/DrawWave.dart';
import 'package:hsa_app/page/debug/widget_page.dart';
import 'package:hsa_app/page/login//login_page.dart';
import 'package:hsa_app/page/setting/modifypswd_page.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/service/versionManager.dart';
import 'package:hsa_app/util/public_tool.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  BuildContext _context;

  void onTapExit() {
    showAlertViewDouble(_context, '提示', '是否退出登录', () {
      // ShareManager().clearAll();
      var route = CupertinoPageRoute(
        builder: (_) => LoginPage(),
      );
      Navigator.of(context, rootNavigator: true)
          .pushAndRemoveUntil(route, (route) => route == null);
    });
  }

  void onTapVersionCheck() async {
    VersionManager.checkNewVersionWithPopAlert(_context, () {}, () {});
  }

  void onTapPushAbout() {
    var host = AppConfig.getInstance().webHost;
    var pageItem = AppConfig.getInstance().pageBundle.about;
    var url = host + pageItem.route ?? AppConfig.getInstance().deadLink;
    var title = pageItem.title ?? '';
    pushToPage(context, WebViewPage(title, url));
  }

  void onTapModifyPswd() {
    pushToPage(context, ModifyPswdPage());
  }

  void onTapWidgetWrap() {
  pushToPage(context, WidgetDebugPage());
  }

  void onTapWidgetPaint() {
    pushToPage(context, DrawPaintPage());
  }

  void onTapWidgetPaint2() {
    pushToPage(context, DrawCircelPaintPage());
  }

  void onWaveWidgetPaint() {
    pushToPage(context, DrawWavePaintPage());
  }

  List<String> funcs = ['修改密码', '关于我们', '版本检测', '退出登录','组件封装','Cavans绘图','圆环组件','波浪组件'];

  Widget settingTile(int idx) {
    var name = funcs[idx];
    return ListTile(
      onTap: () {
        if (idx == 0) return onTapModifyPswd();
        if (idx == 1) return onTapPushAbout();
        if (idx == 2) return onTapVersionCheck();
        if (idx == 3) return onTapExit();
        if (idx == 4) return onTapWidgetWrap();
        if (idx == 5) return onTapWidgetPaint();
        if (idx == 6) return onTapWidgetPaint2();
        if (idx == 7) return onWaveWidgetPaint();
      },
      title: Container(
        height: 60,
        color: Theme.of(context).cardColor,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Icon(
                      Icons.filter_center_focus,
                      size: 20,
                      color: Theme.of(_context).primaryColor,
                    ),
                    SizedBox(width: 10),
                    Text('$name', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('设置'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: funcs.length,
          itemBuilder: (_, idx) => settingTile(idx),
        ),
      ),
    );
  }
}
