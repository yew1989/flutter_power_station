// 获取实时参数定时任务
import 'dart:async';
import 'package:hsa_app/agent/agent.dart';
import 'package:hsa_app/debug/model/all_model.dart';

typedef NearestRunningDataCallBack = void Function(NearestRunningData runtimeData);

// 持续获取指定终端实时运行数据
class AgentRunTimeDataLoopTimerTasker {
  
   AgentRunTimeDataLoopTimerTasker({this.isBase,this.terminalAddress,this.timerInterval = 5});

   // 周期间隔 单位 s 秒
   final int timerInterval;
   Timer timer;
   final String terminalAddress;
   final bool isBase;


  void start (NearestRunningDataCallBack onGetRuntimeData) {

    AgentQueryAPI.remoteMeasuringRunTimeData(terminalAddress, isBase);

    timer = Timer.periodic(Duration(seconds: timerInterval), (t) {
      
      AgentQueryAPI.qureryTerminalNearestRunningData(address: terminalAddress, isBase: isBase,onFail: (_){
        t.cancel();
      },
      onSucc: (data,msg){
        if(onGetRuntimeData != null) onGetRuntimeData(data);
      });

    });
  }
  
  void stop () {
    timer?.cancel();
  }
 

}

 // 持续获取某个电站下,多个终端运行数据
class AgentStationInfoDataLoopTimerTasker {
  
   AgentStationInfoDataLoopTimerTasker({this.isBaseList,this.terminalAddressList,this.timerInterval = 5});

   // 周期间隔 单位 s 秒
   final int timerInterval;
   Timer timer;
   final List<String> terminalAddressList;
   final List<bool> isBaseList;

  void start (NearestRunningDataCallBack onGetRuntimeData) {

    if(terminalAddressList == null)return;
    if(isBaseList == null)return;
    if(terminalAddressList.length == 0)return;
    if(isBaseList.length == 0)return;
    if(terminalAddressList.length != isBaseList.length) return;

    for (int i = 0 ; i < terminalAddressList.length ; i++) {
      final terminalAddress = terminalAddressList[i];
      final isBase = isBaseList[i];
      // 获取当前有功和电量、预估值
      AgentQueryAPI.remoteMeasuringElectricParam(terminalAddress, isBase);
    }

    timer = Timer.periodic(Duration(seconds: timerInterval), (t) {
      // TODO 此处还没开发完
      // AgentQueryAPI.qureryTerminalNearestRunningData(address: terminalAddress, isBase: isBase,onFail: (_){
      //   t.cancel();
      // },
      // onSucc: (data,msg){
      //   if(onGetRuntimeData != null) onGetRuntimeData(data);
      // });

    });
  }
  
  void stop () {
    timer?.cancel();
  }
 

}