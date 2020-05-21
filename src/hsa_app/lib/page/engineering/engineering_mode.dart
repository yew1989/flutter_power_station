import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/operation_func_code/operation_manager.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/page/update/update_root.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';


class EngineeringModePage extends StatefulWidget {
  @override
  _EngineeringModePageState createState() => _EngineeringModePageState();
}

class _EngineeringModePageState extends State<EngineeringModePage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  // 电站升级
  void onTapUpdateStations(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 250));
    pushToPage(context, UpdateRootPage());
  }

  // 界面构建
  @override
  Widget build(BuildContext context) {

    return ThemeGradientBackground(
      
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('工程模式',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
        ),
        body: Stack(
          children: [ 
            
            // 选项列表
            ListView(
              primary: false,
              children: [
                SizedBox(height: 20,),
                OperationManager.getInstance().haveRemoteUpgrade ?  itemTile('设备升级', 'images/update/Update.png', () =>  onTapUpdateStations(context)) : Container(),
                // 分割线(最后一条)
                SizedBox(height: 0.3,child: Container(color:Colors.white24)),
              ],
            ),
          ]
        ),
      ),
    );
  }

}
