import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent_timer_tasker.dart';
import 'package:hsa_app/model/model/electricity_price.dart';
import 'agent.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/api/apis/api_login.dart';

class AgentTestPage extends StatefulWidget {
  @override
  _DebugAgentTestPageState createState() => _DebugAgentTestPageState();
}

class _DebugAgentTestPageState extends State<AgentTestPage> {

  final teminalAddress = '00020023';
  final accountName = 'admin';

  final loginPassword = '456';
  final operationPassword = '123456';
  
  final teminalBase = '00020023';
  final teminalPro  = '00020023';

  // 实时运行参数任务
  AgentRunTimeDataLoopTimerTasker runtimTasker;
  // 实时有功和收益任务
  AgentStationInfoDataLoopTimerTasker stationTasker;

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

    '持续获取指定终端运行实时数据(开启)',
    '持续获取指定终端运行实时数据(关闭)',

    '持续获取多台终端运行实时功率和收益(开启)',
    '持续获取多台终端运行实时功率和收益(关闭)',

    
    ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    runtimTasker?.stop();
    stationTasker?.stop();
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
      APILogin.login(context,name:accountName,pswd: loginPassword,onSucc: (auth,msg){
        showToast(msg + auth.toString());
      },onFail:(msg){
        showToast(msg);
      });

    }
    else if(index == 1 ) {

      // 发送命令 00020013/AFN0C_F1/0
      AgentAPI.getCommandId(
        address: teminalAddress,
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
        address: teminalAddress, 
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

   // '持续获取指定终端运行实时数据(开启)',
    else if(index == 20) {
      runtimTasker = AgentRunTimeDataLoopTimerTasker(
        isBase: true,
        terminalAddress: teminalBase,
        timerInterval: 5,
      );
      runtimTasker.start((data){
        showToast(data.toString());
      });
    }
    // '持续获取指定终端运行实时数据(关闭)',      
    else if(index == 21) {
      runtimTasker?.stop();
    }
    // '持续获取多台终端运行实时功率和收益(开启)',
    else if(index == 22) {
      // stationTasker = AgentStationInfoDataLoopTimerTasker(
      //   price: ElectricityPrice(
      //   spikeElectricityPrice : 1.0,
      //   peakElectricityPrice : 2.0,
      //   flatElectricityPrice : 0.5,
      //   valleyElectricityPrice : 1.5,
      // ),
      // timerInterval: 5,
      // terminalAddressList: [teminalBase,teminalPro],
      // isBaseList: [true,false],
      // );
      // stationTasker.start((data,totalPower,totalMoney){
      //   String msg = '';
      //   msg += '总有功功率:' + totalPower.toStringAsFixed(1) + '\n';
      //   msg += '总收益:' + totalMoney.toStringAsFixed(2) + '元' + '\n';
      //   msg += data.map((f)=> f.address + ',' + f.power.toStringAsFixed(0) +  ',' + f.date + '\n').toList().toString() + '\n';
      //   showToast(msg);
      // });
    }
    // '持续获取多台终端运行实时功率和收益(关闭)',
    else if(index == 23) {
      stationTasker?.stop();
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