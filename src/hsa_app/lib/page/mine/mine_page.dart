import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_login.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/page/about/about_page.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/page/search/search_page.dart';
import 'package:hsa_app/page/password/modifypswd_page.dart';
import 'package:hsa_app/service/push/push_api.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:native_color/native_color.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  String userName = '';
  int stationCount = 0;

  @override
  void initState() {
    super.initState();
    requestUserInfo();
    bindPushService();
    UMengAnalyticsService.enterPage('我的');
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('我的');
    super.dispose();
  }

    // 绑定推送服务
  void bindPushService() async {
    PushAPI.bindRegId((msg){
      debugPrint(msg);
    }, (msg){
      debugPrint(msg);
    });
  }

  void requestUserInfo() async {
    userName = await ShareManager.instance.loadUserName();
    APILogin.getAccountInfo(name: userName,onSucc: (account){
      setState(() {
        this.stationCount = account.accountStationRelation.length;
        this.userName = account.accountName;  
      });
    });
  }

  // 用户资料信息
  Widget userInfoWidget(String userName,int stationCount) {
    var downString = stationCount.toString() + ' 座智能电站';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
          Text(userName, style: TextStyle(color: Colors.white, fontSize: 21)),
          SizedBox(height: 12),
          Text(downString, style: TextStyle(color: Colors.white, fontSize: 13)),
          ],
      );
  }

  // 用户头像
  Widget userAvator(){
    return SizedBox(height: 100, width: 100,child: CircleAvatar(radius: 50, backgroundImage: AssetImage('images/about/about_icon.png')));
  }

  // 我的页面头部
  Widget mineHeaderView() {

    return Container(
      height: 200,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            userAvator(),
            SizedBox(width: 16),
            userInfoWidget(this.userName,this.stationCount),
          ],
        ),
      ),
    );
  }



  // 修改密码
  void onTapChangePswd(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 250));
    pushToPage(context, ModifyPswdPage(this.userName));
  }

  // 关于
  void onTapAbout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 250));
    pushToPage(context, AboutPage());
  }


  // SOS拨号器
  void onTapSOSCall(BuildContext context) {
    final sosPhone = AppConfig.getInstance().remotePackage?.phoneSOS ?? '';
    onTapSoScall(sosPhone);
  }

  // 登录界面
  Widget loginOutButton() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: FlatButton(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
          splashColor: Colors.white,color: HexColor('6699ff'),
          child: Text('退出登录', style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: () {
          showAlertViewDouble(context, '提示', '是否退出登录', () {
            ShareManager.instance.saveIsSavePassword(false);
            final route = CupertinoPageRoute(builder: (_) => LoginPage());
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(route, (route) => route == null);
            });
          },
        ),
    );
  }

  Widget itemTile(String title, String iconName, Function onTap) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
              color: Colors.transparent,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SizedBox(
                    height: 22,
                    width: 22,
                    child: Image.asset(iconName),
                    ),
                    SizedBox(width: 12),
                    Text(title,style: TextStyle(color: Colors.white,fontSize: 16),)
                    ],
                  ),
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: Image.asset('images/mine/My_next_btn.png'),
                  ),
                ],
              ),
            ),
              // 分割线
              SizedBox(height: 0.3,child: Container(color:Colors.white24)),
            ]
          ),
        ),
      ),
    );
  }

  // 搜索电站
  void onTapSearchStations(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 250));
    pushToPage(context, SearchPage());
  }

  // 界面构建
  @override
  Widget build(BuildContext context) {

    final isIphone5S = MediaQuery.of(context).size.width == 320.0 ? true : false;

    return Scaffold(
      body: ThemeGradientBackground(
        child: Stack(
          children: [ 
          // 选项列表
          ListView(
            primary: false,
            children: [

              mineHeaderView(),
              
              itemTile('修改密码', 'images/mine/My_Change_pwd_icon.png', () => onTapChangePswd(context)),
              itemTile('关于智能电站', 'images/mine/My_about_icon.png', () =>  onTapAbout(context)),
              itemTile('电站抢修', 'images/mine/My_sos_icon.png', () =>  onTapSOSCall(context)),
              itemTile('搜索电站', 'images/history/History_selt_btn.png', () =>  onTapSearchStations(context)),
              
              // 分割线(最后一条)
              SizedBox(height: 0.3,child: Container(color:Colors.white24)),
            ],
          ),
          // 注销按钮
          Positioned(
            bottom: isIphone5S ? 30 : 56,
            left: 0,
            right: 0,
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 50),child: loginOutButton())
          ),
          // 标签栏阴影
          Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: TabBarLineShawdow(),
          )
          ]
        ),
      ),
    );
  }

  // 拨打电话
  Future<bool> onTapSoScall(String phone) async {
    await Future.delayed(Duration(milliseconds: 250));
    var url = 'tel:';
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      url += '+86' + phone;
    } else if (TargetPlatform.android == defaultTargetPlatform) {
      url += phone;
    }
    var canTouch = await canLaunch(url);
    if (canTouch) {
      bool isOk = await launch(url);
      return isOk;
    }
    showToast('拨打电话失败');
    return false;
  }
}
