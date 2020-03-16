import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/debug_api.dart';

class DebugApiTestPage extends StatefulWidget {
  @override
  _DebugApiTestPageState createState() => _DebugApiTestPageState();
}

class _DebugApiTestPageState extends State<DebugApiTestPage> {

  final List<String> leftLabels = ['登录','获取省份列表'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('API接口测试')),
      body:ListView.builder(
        itemBuilder: (_, index) => listTile(context,index),
        itemCount: leftLabels.length,
      ),
    );
  }
    // 列表中的每个行
    Widget listTile(BuildContext context,int index) {
    final String titleText = leftLabels[index];
    return ListTile(title: Text('${(index+1)}、 $titleText'),onTap:()=> onTapTile(index));
  
  }

  void onTapTile(int index) async {

    if(index == 0 ) {
      // 登录
      DebugAPI.login(context,name:'admin',pswd: '456',onSucc: (auth,msg){
        showToast(msg + auth);
      },onFail:(msg){
        showToast(msg);
      });
    }
    // 获取省份列表
    else if(index == 1 ) {

    }



  }



}