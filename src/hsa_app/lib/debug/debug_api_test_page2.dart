import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/debug_api.dart';

class DebugApiTestPage2 extends StatefulWidget {
  @override
  _DebugApiTestPageState2 createState() => _DebugApiTestPageState2();
}

class _DebugApiTestPageState2 extends State<DebugApiTestPage2> {

  final List<String> leftLabels = ['登录','获取用户信息','获取省份列表',
  
  '获取告警事件类型列表(水轮机)','获取告警事件类型列表(生态下泄)',
  '历史水位','历史有功',

  ];

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

    // 登录 
    if(index == 0 ) {

      DebugAPI.login(context,name:'admin',pswd: '456',onSucc: (auth,msg){
        showToast(msg + auth.toString());
      },onFail:(msg){
        showToast(msg);
      });
    }

    // 获取用户信息
    else if(index == 1 ) {
      
      DebugAPI.getAccountInfo(name:'admin',onSucc: (account){

        var log = '账号名 :' + account.description + '\n';
        log += '拥有电站数 :' + account.accountStationRelation.length.toString() + '\n';
        log += '账号ID :' + account.accountId + '\n';

        showToast(log);

      },onFail:(msg){
        showToast(msg);
      });

    }

    // 获取省份列表

    else if(index == 2 ) {

      DebugAPI.getAreaList(rangeLevel:'Province',onSucc: (areas){

        var log = '省份数量 :' + areas.length.toString() + '\n';
        log += '省份 :' + areas.map((area) => area.provinceName).toList().toString() + '\n';
        
        showToast(log);

      },onFail: (msg){
        showToast(msg);
      });
    }

    // 获取告警事件类型列表(水轮机)
    else if(index == 3 ) {

      DebugAPI.getErcFlagTypeList(type:'0',onSucc: (types){

        var log = '告警类型数量 :' + types.length.toString() + '\n';
        log += '告警类型 :' + types.map((f) => 'ERC' + f.ercFlag.toString() + ' ' + f.ercTitle + '\n').toList().toString() + '\n';
        
        showToast(log);

      },onFail: (msg){
        showToast(msg);
      });
    }
    
    // 获取告警事件类型列表(生态下泄)
      else if(index == 4 ) {

      DebugAPI.getErcFlagTypeList(type:'1',onSucc: (types){

        var log = '告警类型数量 :' + types.length.toString() + '\n';
        log += '告警类型 :' + types.map((f) => 'ERC' + f.ercFlag.toString() + ' ' + f.ercTitle + '\n').toList().toString() + '\n';
        
        showToast(log);

      },onFail: (msg){
        showToast(msg);
      });
    }
  
  }



}