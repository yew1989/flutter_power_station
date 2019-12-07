import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/page/framework/root_page.dart';
import 'package:hsa_app/service/versionManager.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/share.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin,WidgetsBindingObserver {

  String loadingText = '配置信息获取中 ...';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint(state.toString());
    if(state == AppLifecycleState.resumed) {
      checkUpdateVersion();
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    API.touchNetWork();
    AppConfig.initConfig();
    appCheck();
    mesureDeviceBoundSize();
  }

  // 测量设备宽高
  void mesureDeviceBoundSize() {
    Future.delayed(Duration(seconds:1),(){
      debugPrint('📱设备宽:' + MediaQuery.of(context).size.width.toString());
      debugPrint('📱设备高:' + MediaQuery.of(context).size.height.toString());
    });
  }

  // APP 环境自检
  void appCheck() async {
    var isConfigOK = await readWebURLConfigFromRemote();
    if(!isConfigOK) return;
    checkUpdateVersion();
  }

  // 检测更新
  Future<bool> checkUpdateVersion() async {
    await Future.delayed(Duration(seconds:1),(){
    });
    var state = await VersionManager.checkNewVersionWithPopAlert(context,(){},(){
      checkIsLogined();
    });
    if(state == VersionUpdateState.fail) {
      loadingText = '版本配置文件获取失败,请检查网络';
      setState(() {});
      return false;
    }
    else {
      loadingText = '版本配置文件获取成功';
      setState(() {});
      if(state == VersionUpdateState.noUpdate) {
        checkIsLogined();
      }
      return true;
    }
  }

  // 读取远端文件
  Future<bool> readWebURLConfigFromRemote() async {
    await Future.delayed(Duration(seconds:1));
    var routeOk = await getWebRoute();
    if(!routeOk) {
      loadingText = '配置文件获取失败,请检查网络';
      setState(() {});
      return false;
    }
    else {
      loadingText = '配置文件获取成功';
      setState(() {});
      return true;
    }
  }

  void checkIsLogined() async {
    await Future.delayed(Duration(seconds:1));
    var token = await ShareManager.instance.loadToken();
    var isLogined = token.length > 0 ;
    debugPrint('🔑 本地Token:'+token);
    pushToPageAndKill(context, isLogined ? RootPage(): LoginPage());
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
                // 中央
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1125 / 664,
                      child: Image.asset('images/welcome/Start_water.png')),
                  ),
                ),

                // 发电从未如此简单
               Positioned(bottom: 90,left: 0,right: 0,
                child: SizedBox(
                    height: 28,
                    child: AspectRatio(
                      aspectRatio: 366 / 84,
                      child: Image.asset('images/welcome/Start_slogan.png')))),

                // 显示版本
                Positioned(bottom: 54,left: 0,right: 0,
                child: Center(child: Text('V1.0.0',
                style: TextStyle(color: Colors.white70,fontSize: 10)))),

                // 构建版本
                Positioned(bottom: 40,left: 0,right: 0,
                child: Center(child: Text('Build 20191220',
                style: TextStyle(color: Colors.white70,fontSize: 10)))),

                // 版权信息
                Positioned(bottom: 8,left: 0,right: 0,
                child: Center(child: Text('Copyright @ fjlead 2019-2020',
                style: TextStyle(color: Colors.white70,fontSize: 10)))),

              ],
            ),
          ),
        ),
      ),
    );
  }


  
Future<bool> getWebRoute() async {
  var webConfig = await API.getWebRoute();
  if(webConfig == null) {
    debugPrint('❌:路由文件获取错误');
    return false;
  }
  // 整体环境配置
  AppConfig.getInstance().pageConfig  = webConfig;
  // 环境 host
  AppConfig.getInstance().webHost = webConfig.appPageRoute.testHost;
  // 环境 page bundle
  AppConfig.getInstance().pageBundle = webConfig.appPageRoute.page;
  return true;
}

}

