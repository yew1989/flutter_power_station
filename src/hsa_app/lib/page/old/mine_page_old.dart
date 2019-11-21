import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/page/setting/setting_page.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePageOld extends StatefulWidget {
  @override
  _MinePageStateOld createState() => _MinePageStateOld();
}

class _MinePageStateOld extends State<MinePageOld> {
  Widget topBar() {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                // 圆环
                CircleAvatar(
                  radius: 36.0,
                  backgroundImage: AssetImage('assets/login.jpg'),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Center(
                          child: Text(
                        '积分',
                        style: TextStyle(color: Colors.white),
                      )),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        var host = AppConfig.getInstance().webHost;
                        var pageItem = AppConfig.getInstance().pageBundle.credits;
                        var url = host + pageItem.route ?? AppConfig.getInstance().deadLink;
                        var title = pageItem.title ?? '';
                        url = url + '?auth=' + ShareManager.instance.token;
                        pushToPage(context,WebViewPage(title, url));
                      },
                    ),
                    FlatButton(
                      child: Center(
                          child: Text(
                        '订单',
                        style: TextStyle(color: Colors.white),
                      )),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                    FlatButton(
                      child: Center(
                          child: Text(
                        '周报',
                        style: TextStyle(color: Colors.white),
                      )),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
          ),

          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).primaryColor,
              iconSize: 30,
              onPressed: (){
                var route = CupertinoPageRoute(
                  builder: (_) => SettingPage(),
                );
                Navigator.of(context,rootNavigator: true).push(route);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget menuBar() {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: double.infinity,
      // color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Center(
                    child: Text(
                  '签到',
                  style: TextStyle(color: Colors.white),
                )),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  var host = AppConfig.getInstance().webHost;
                  var pageItem = AppConfig.getInstance().pageBundle.clockin;
                  var url = host + pageItem.route ?? AppConfig.getInstance().deadLink;
                  var title = pageItem.title ?? '';
                  url = url + '?auth=' + ShareManager.instance.token;
                  pushToPage(context,WebViewPage(title , url));
                },
              ),
              FlatButton(
                child: Center(
                    child: Text(
                  '巡检',
                  style: TextStyle(color: Colors.white),
                )),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
              FlatButton(
                child: Center(
                    child: Text(
                  '报修',
                  style: TextStyle(color: Colors.white),
                )),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Center(
                    child: Text(
                  '客服',
                  style: TextStyle(color: Colors.white),
                )),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
              FlatButton(
                child: Center(
                    child: Text(
                  '投诉',
                  style: TextStyle(color: Colors.white),
                )),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
              FlatButton(
                child: Center(
                    child: Text(
                  'SOS',
                  style: TextStyle(color: Colors.white),
                )),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  onTapSoScall('18046053193');
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.grey[100],
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              topBar(),
              menuBar(),
            ],
          ),
        ),
      ),
    );
  }

  // 拨打电话
  Future<bool> onTapSoScall(String phone) async {
    var url = 'tel:';
    if(TargetPlatform.iOS == defaultTargetPlatform) {
      url += '+86' + phone;
    }
    else if(TargetPlatform.android == defaultTargetPlatform){
      url += phone;
    }
    var canTouch =  await canLaunch(url);
    if (canTouch) {
      bool isOk = await launch(url);
      return isOk;
    }
    showToast('拨打电话失败');
    return false;
  }
}
