import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  
  String appInfo = '智能电站是福建省力得自动化设备有限公司专为智能电站1号打造的一款智能远程监控APP。';
  String desc1   = '1.监测数据:监测电站水位、功率等数据,监测设备温度、水压等数据。';
  String desc2   = '2.远程控制:远程控制机组的开关机状态,远程控制旁通阀、主阀、清污机等智能设备;远程调控有功、无功。';
  String desc3   = '3.报警提醒:通过智能电站,第一时间将报警信息发送报给用户。';


  @override
  void initState() {
    UMengAnalyticsService.enterPage('关于');
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('关于');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isIphone5S = MediaQuery.of(context).size.width == 320.0 ? true : false;
    final displayVersion = AppConfig.getInstance().localDisplayVersionString;
    final displayBuild = AppConfig.getInstance().displayBuildVersion;

    return ThemeGradientBackground(
      child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text('关于智能电站',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Stack(
                children: <Widget>[
                  ListView(
                  children: <Widget>[
                    SizedBox(height: isIphone5S ? 10 : 50),
                    Center(child: SizedBox(
                      height: 82,
                      width: 82,
                      child: Image.asset('images/about/about_icon.png'))),
                    SizedBox(height: 14),
                    Center(child: Text('$displayVersion',style: TextStyle(color: Colors.white70,fontSize: 10))),
                    SizedBox(height: 4),
                    Center(child: Text('$displayBuild',style: TextStyle(color: Colors.white70,fontSize: 10))),
                    SizedBox(height: isIphone5S ? 10 : 50),
                    Text('【应用简介】',style: TextStyle(color: Colors.white,fontSize:13)),
                    SizedBox(height: 4),
                    Text('  '+appInfo,style: TextStyle(color: Colors.white54,fontSize: 13)),
                    SizedBox(height: 20),
                    Text('【功能介绍】',style: TextStyle(color: Colors.white,fontSize: 13)),
                    SizedBox(height: 4),
                    Text(desc1,style: TextStyle(color: Colors.white54,fontSize: 13)),
                    SizedBox(height: 20),
                    Text(desc2,style: TextStyle(color: Colors.white54,fontSize: 13)),
                    SizedBox(height: 20),
                    Text(desc3,style: TextStyle(color: Colors.white54,fontSize: 13)),
                    ],
                  ),

                  Positioned(bottom: 8,left: 0,right: 0,child: Center(child: 
                  Text('Copyright @ fjlead 2019-2020',style: TextStyle(color: Colors.white70,fontSize: 10)))),

                ],

              ),
            ),
          ),
      ),
    );
  }
}