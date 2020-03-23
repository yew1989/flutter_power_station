import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/API/debug_api_login.dart';
import 'package:hsa_app/debug/debug_api.dart';

class DebugApiTestPage extends StatefulWidget {
  @override
  _DebugApiTestPageState createState() => _DebugApiTestPageState();
}

class _DebugApiTestPageState extends State<DebugApiTestPage> {

  final List<String> leftLabels = ['登录','获取用户信息','修改密码','获取省份列表','电站列表','机组列表','实时参数','关注与取消','告警时间','实时运行参数'];

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

      DebugAPILogin.login(context,name:'admin',pswd: '456',onSucc: (auth,msg){
        showToast(msg + auth.toString());
      },onFail:(msg){
        showToast(msg);
      });
    }

    // 获取用户信息
    else if(index == 1 ) {
      
      DebugAPILogin.getAccountInfo(name:'admin',onSucc: (account){

        var log = '账号名 :' + account.description + '\n';
        log += '拥有电站数 :' + account.accountStationRelation.length.toString() + '\n';
        log += '账号ID :' + account.accountId + '\n';

        showToast(log);

      },onFail:(msg){
        showToast(msg);
      });

    }

    // 获取用户信息
    else if(index == 2 ) {
      
      DebugAPILogin.resetLoginPassword(context,accountName:'admin' , oldLoginPwd: '123' ,newLoginPwd:'456',onSucc: (account,msg){

        var log = '密码修改成功!';

        showToast(log);

      },onFail:(msg){
        showToast(msg);
      });

    }

    // 获取省份列表

    else if(index == 3 ) {

      DebugAPI.getAreaList(rangeLevel:'Province',onSucc: (areas){

        var log = '省份数量 :' + areas.length.toString() + '\n';
        log += '省份 :' + areas.map((area) => area.provinceName).toList().toString() + '\n';
        
        showToast(log);

      },onFail: (msg){
        showToast(msg);
      });
    }


    //电站列表

    else if(index == 4 ) {
      List<String> srtlist = ['0137001','0001001'];
      DebugAPI.getStationList(isIncludeCustomer:true,isIncludeLiveLink:true,/*arrayOfStationNoOptAny:srtlist,*/page:1,pageSize:10,onSucc: (msg){

        var log = '电站总数:'+ msg.total.toString();
        
        showToast(log);

      },onFail: (msg){
        showToast(msg);
      });
    }

    //电站列表(单)/水轮机组信息

    else if(index == 5 ) {

      DebugAPI.getWaterTurbineList(stationNo: "0001001",isIncludeCustomer:true,isIncludeLiveLink:true,onSucc: (msg){

        var log = '电站名称:'+ msg.stationName;
        
        showToast(log);

      },onFail: (msg){
        showToast(msg);
      });
    }

    //取终端最近运行时通讯的数据(多)

    else if(index == 6 ) {
      List<String> paramList = ['terminalconnectedstate','AFN0C.F7.p0','AFN0C.F9.p0','AFN0C.F10.p0','AFN0C.F11.p0','AFN0C.F13.p0',
                  'AFN0C.F24.p0','AFN0C.F20.p0','AFN0C.F21.p0','AFN0C.F22.p0'];
      DebugAPI.getMultipleAFNFnpn(terminalAddress: '03740001',paramList:paramList,onSucc: (msg){

        
        
        showToast(msg.current.toString());

      },onFail: (msg){
        showToast(msg);
      });
    }
  }



}