import 'package:flutter/material.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  
  String appInfo = '智能电站管家是福建省力得自动化设备有限公司专为智能电站1号打造的一款智能远程监控APP。';
  String desc1 = '1.监测数据:监测电站水位、功率等数据,监测设备温度、水压等数据。';
  String desc2 = '2.远程控制:远程控制机组的开关机状态,远程控制旁通阀、主阀、清污机等智能设备;远程调控有功、无功。';
  String desc3 = '3.报警提醒:通过智能电站管家,第一时间将报警信息发送报给用户。';

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text('关于智能电站管家',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18)),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Stack(
                children: <Widget>[
                  ListView(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Center(child: SizedBox(
                      height: 82,
                      width: 82,
                      child: Image.asset('images/about/about_icon.png'))),
                    SizedBox(height: 14),
                    Center(child: Text('V1.0.0',style: TextStyle(color: Colors.white70,fontSize: 10))),
                    SizedBox(height: 4),
                    Center(child: Text('Build 20191220',style: TextStyle(color: Colors.white70,fontSize: 10))),
                    SizedBox(height: 50),
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
                  Positioned(bottom: 8,left: 0,right: 0,child: Center(
                    child: Text('Copyright @ fjlead 2019-2020',style: TextStyle(color: Colors.white70,fontSize: 10)))),
                ],

              ),
            ),
          ),
      ),
    );
  }
}