import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/page/framework/root_page.dart';
import 'package:hsa_app/service/versionManager.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin,WidgetsBindingObserver {

  String loadingText = '配置信息获取中 ...';

  // 设置代理
  void dioInitProxy() {
    
  }

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
    // debugPrint('初始化WelCome');
    // dioInitProxy();
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
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text('启动中',style: TextStyle(color: Colors.white70,fontSize: 16)),
                  Text('请稍后',style: TextStyle(color: Colors.white38,fontSize: 12)),
              ],
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
  AppConfig.getInstance().webHost = webConfig.appPageRoute.devHost;
  // 环境 page bundle
  AppConfig.getInstance().pageBundle = webConfig.appPageRoute.page;
  return true;
}

}

