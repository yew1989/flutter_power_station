import 'package:flutter/material.dart';
import 'package:hsa_app/debug/response/all_resp.dart';
import 'agent.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/API/debug_api_login.dart';

class AgentTestPage extends StatefulWidget {
  @override
  _DebugAgentTestPageState createState() => _DebugAgentTestPageState();
}

class _DebugAgentTestPageState extends State<AgentTestPage> {

  final teminalAddress = '00020013';
  final accountName = 'admin';

  final loginPassword = '456';
  final operationPassword = '123abc';
  
  final teminalBase = '00020013';
  final teminalPro  = '00020044';

  final List<String> leftLabels = [

    '登录',
    '获取Cmd AFN0C.F1(单条)',
    '召测任务 AFN0C.F1',
    '召测任务 AFN0C.F2',
    '操作票获取 (单条)',
    '控制指令 AFN05.F2',

    '远程开机',
    '远程关机',
    '远程开主阀门',
    '远程关主阀门',

    '远程设定目标有功功率',
    '远程设定目标功率因数',
    '远程开旁通阀',
    '远程关旁通阀',

    '远程切换智能控制方案 - 打开远程控制',
    '远程切换智能控制方案 - 关闭远程控制',
    '远程控制垃圾清扫 - 开',
    '远程控制垃圾清扫 - 关',

    '获取最近运行时参数(多项)(Base)',
    '获取最近运行时参数(多项)(Pro)',
    
    ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 列表中的每个行
  Widget listTile(BuildContext context,int index) {
    final String titleText = leftLabels[index];
    return ListTile(title: Text('${(index+1)}、 $titleText'),onTap:()=> onTapTile(index));
  }

  // 点击了单元格
  void onTapTile(int index) async {
    // 登录
    if(index == 0 ) {
      DebugAPILogin.login(context,name:accountName,pswd: loginPassword,onSucc: (auth,msg){
        showToast(msg + auth.toString());
      },onFail:(msg){
        showToast(msg);
      });

    }
    else if(index == 1 ) {

      // 发送命令 00020013/AFN0C_F1/0
      AgentAPI.getCommandId(
        address: '00020013',
        afn: '0C',
        func: 'F1',
        onSucc: (cmdId,msg){
          showToast(msg + '\n' + cmdId);
        },
        onFail:(msg){
        showToast(msg);
      });

    }

    else if(index == 2 ) {

      AgentTask().sendCommandTask(
        context,
        address: '00020013', 
        afn: '0C',
        func: 'F1',
        onSucc: (msg) {
          showToast(msg);
        },
        onLoading: (msg) {
          showToast(msg);
        },
        onFail: (msg){
          showToast(msg);
        },
      );
    }

    else if(index == 3 ) {

      AgentTask().sendCommandTask(
        context,
        address: teminalAddress, 
        afn: '0C',
        func: 'F2',
        param: {'远程主阀开关':true},
        onSucc: (msg) {
          showToast(msg);
        },
        onLoading: (msg) {
          showToast(msg);
        },
        onFail: (msg){
          showToast(msg);
        },
      );

    }
    // 操作票获取
    else if(index == 4) {

      AgentAPI.getCheckOperation(context, operationPassword, (ticket,msg){
        showToast(msg + '\n' + ticket);
      }, (msg){
        showToast(msg);
      });

    }
    else if(index == 5) {

      // 远程控制主阀开关
      AgentTask().sendCommandTask(
        context,

        password: operationPassword,
        address: teminalAddress, 
        afn: '05',
        func: 'F2',
        param: { '远程主阀开关' : false },

        onSucc: (msg) {
          showToast(msg);
        },

        onLoading: (msg) {
          showToast(msg);
        },

        onFail: (msg){
          showToast(msg);
        },

      );
    }


    else if(index == 6) { 
      AgentControlAPI.remotePowerOn(
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 7) { 
      AgentControlAPI.remotePowerOff(
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 8) { 
      AgentControlAPI.remoteMainValveOn(
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 9) { 
      AgentControlAPI.remoteMainValveOff(
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }

    else if(index == 10) { 
      AgentControlAPI.remoteSettingActivePower(
        context,
        '200',
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 11) { 
      AgentControlAPI.remoteSettingPowerFactor(        
        context,
        '0.95',
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 12) { 
      AgentControlAPI.remoteSideValveOn(
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 13) { 
      AgentControlAPI.remoteSideValveOff(        
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 14) { 
      AgentControlAPI.remoteSwitchRemoteModeOn(        
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 15) { 
      AgentControlAPI.remoteSwitchRemoteModeOff(       
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 16) { 
      AgentControlAPI.remoteClearRubbishOn(        
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );
    }
    else if(index == 17) { 

      AgentControlAPI.remoteClearRubbishOff(
        context,
        password: operationPassword,
        address: teminalAddress, 
        onSucc: (msg) {
          showToast(msg);
        },
        onFail: (msg) {
          showToast(msg);
        },
      );

    }
    // BASE
    else if(index == 18) {

        AgentQueryAPI.qureryTerminalNearestRunningData(address: teminalBase,isBase:true,onSucc: (data,msg){
          
          showToast(data.toString());

        },onFail: (msg){

          showToast(msg);

        });
    }
    // PRO
    else if(index == 19) {

        AgentQueryAPI.qureryTerminalNearestRunningData(address: teminalPro,isBase:false,onSucc: (data,msg){

          showToast(data.toString());

        },onFail: (msg){

          showToast(msg);

        });
    }






  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('招测指令')),
      body:ListView.builder(
        itemBuilder: (_, index) => listTile(context,index),
        itemCount: leftLabels.length,
      ),
    );
  }
}