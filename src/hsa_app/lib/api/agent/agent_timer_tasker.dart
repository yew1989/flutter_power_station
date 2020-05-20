// 获取实时参数定时任务
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent.dart';
import 'package:hsa_app/api/apis/api_update.dart';
import 'package:hsa_app/model/model/all_model.dart';

// 供展示的实时有功数据体
class ActivePowerRunTimeData {

  final String address;
  final String date;
  final double power;
  ActivePowerRunTimeData(this.address, this.date, this.power);
  
}

// 实时运行参数页返回 - 实时参数
typedef NearestRunningDataCallBack = void Function(NearestRunningData runtimeData);

// 电站概要页返回 - 当前有功,电站总有功,当日电站总收益
typedef StationInfoDataCallBack = void Function(StationInfo station);

// 升级任务列表 - 当前进度
typedef UpdateTaskListCallBack = void Function(List<UpdateTask> updateTaskList);

// 升级任务详情 - 当前进度
typedef UpdateTaskInfoCallBack = void Function(UpdateTask updateTask);

// 持续获取指定终端实时运行数据
class AgentRunTimeDataLoopTimerTasker {
  
   int timerInterval;// 周期间隔 单位 s 秒
   String terminalAddress;
   bool isBase;
   bool isAllowHighSpeedNetworkSwitching;// 是否允许快速远程召测
   Timer timer;

   void listen(String terminalAddress,bool isBase,bool isAllowHighSpeedNetworkSwitching,int timerInterval,NearestRunningDataCallBack onData) {

     this.terminalAddress = terminalAddress;
     this.isBase = isBase;
     this.isAllowHighSpeedNetworkSwitching = isAllowHighSpeedNetworkSwitching;
     this.timerInterval = timerInterval;

    runTimeDataOnce(onData,null);

    timer = Timer.periodic(Duration(seconds: this.timerInterval), (t) {
      runTimeDataOnce(onData,(){
        t?.cancel();
      });
    });
  }

  // 运行时数据
  void runTimeDataOnce(NearestRunningDataCallBack onGetRuntimeData,void Function() onFail) {

    // 仅允许高速告诉召测标志开启才能对终端进行召测
    if(this.isAllowHighSpeedNetworkSwitching == true) {
      AgentQueryAPI.remoteMeasuringRunTimeData(this.terminalAddress, this.isBase);
    }

    // 获取缓存数据
    AgentQueryAPI.qureryTerminalNearestRunningData(address: this.terminalAddress, isBase: this.isBase,onFail: (_){
      if(onFail != null)onFail();
    },
    onSucc: (data,msg){
      if(onGetRuntimeData != null) onGetRuntimeData(data);
    });
  }
  
  void dispose() {
    timer?.cancel();
  }

}


 // 持续获取某个电站下,多个终端运行数据 获取当前有功和电量、预估值, 仅支持在线的终端
class AgentStationInfoDataLoopTimerTasker {

   Timer timer;
   StationInfo station;
   bool isAllowHighSpeedNetworkSwitching;
   int timerInterval;// 周期间隔 单位 s 秒

   void listen (StationInfo station,bool isAllowHighSpeedNetworkSwitching,int timerInterval,StationInfoDataCallBack onData) {

    this.station =station;
    this.timerInterval = timerInterval;
    this.isAllowHighSpeedNetworkSwitching = isAllowHighSpeedNetworkSwitching;

    // 总收益
    double _money = 0.0;
    // 当前有功
    List<ActivePowerRunTimeData> datas = [];
    // 总有功
    double _totalActivePower = 0.0;

    // 剩余未返回次数
    int unResponeseAck = 0;

    final terminalAddressList = this.station.waterTurbines.map((w)=>w.deviceTerminal.terminalAddress).toList();
    final isBaseList = this.station.waterTurbines.map((w)=>w.deviceTerminal.deviceVersion.compareTo('S1-Pro') == 0  ? false : true).toList();

    if(terminalAddressList == null)return;
    if(isBaseList == null)return;
    if(terminalAddressList.length == 0)return;
    if(isBaseList.length == 0)return;
    if(terminalAddressList.length != isBaseList.length) return;

    stationInfOnce(_money, _totalActivePower, datas, unResponeseAck,this.isAllowHighSpeedNetworkSwitching,onData);
    
    // 定时读取
    timer = Timer.periodic(Duration(seconds: this.timerInterval), (t) {
      stationInfOnce(_money, _totalActivePower, datas, unResponeseAck,this.isAllowHighSpeedNetworkSwitching, onData);
    }
    
    );
  }

   void stationInfOnce(double _money, double _totalActivePower, List<ActivePowerRunTimeData> datas, int unResponeseAck,bool isAllowHighSpeedNetworkSwitching,StationInfoDataCallBack onGetStationInfo) {

    var stationResult = station;

    final terminalAddressList = station.waterTurbines.map((w)=>w.deviceTerminal.terminalAddress).toList();
    final isBaseList = station.waterTurbines.map((w)=>w.deviceTerminal.deviceVersion.compareTo('S1-Pro') == 0  ? false : true).toList();
    final price = ElectricityPrice(
      spikeElectricityPrice: station.spikeElectricityPrice ?? 0.0,
      peakElectricityPrice: station.peakElectricityPrice ?? 0.0,
      flatElectricityPrice: station.flatElectricityPrice ?? 0.0,
      valleyElectricityPrice: station.valleyElectricityPrice ?? 0.0,
    );

     // 初始化
     _money = 0.0;
     _totalActivePower = 0.0;
     datas = [];
     unResponeseAck = terminalAddressList.length;
     
     // 仅允许高速告诉召测标志开启才能对终端进行召测
     if(isAllowHighSpeedNetworkSwitching == true) {
        // 并发召测当前有功和电量、预估值
        for (int i = 0 ; i < terminalAddressList.length ; i++) {
          final terminalAddress = terminalAddressList[i];
          final isBase = isBaseList[i];
          AgentQueryAPI.remoteMeasuringElectricParam(terminalAddress, isBase);
        }
     }
     
     // 获取缓存数据
     for (int j = 0; j < terminalAddressList.length; j++) {
     
         final terminalAddress = terminalAddressList[j];
         final isBase = isBaseList[j];
     
         AgentQueryAPI.qureryTerminalNearestRunningData(address: terminalAddress, isBase: isBase,price: price,onSucc: (data,msg){
     
           unResponeseAck -- ;
     
           final active = data.power;
           final date = data.dataCachedTime != ''  ?  data.dataCachedTime ?? '0000-00-00 00:00:00' : '0000-00-00 00:00:00';
           final activeData =  ActivePowerRunTimeData(terminalAddress, date, active);
           datas.add(activeData);
     
           _totalActivePower += active;
           _money += data.money;
           
           if(unResponeseAck <= 0) {
     
             // 按输入顺序排序
             datas = sort(datas, terminalAddressList); 

             // 拼接到输出 stationResult
             for (int k = 0 ; k < datas.length ; k++) {
               final turbine = stationResult.waterTurbines[k];
               final data = datas[k];
               turbine?.deviceTerminal?.nearestRunningData?.dataCachedTime = data?.date ?? '0000-00-00 00:00:00';
               turbine?.deviceTerminal?.nearestRunningData?.power = data?.power ?? 0.0;
             }
             stationResult.totalMoney = _money;
             stationResult.totalActivePower = _totalActivePower;

             if(onGetStationInfo != null) onGetStationInfo(stationResult);
           }
         },onFail: (msg){
     
           unResponeseAck --;
     
           final activeData =  ActivePowerRunTimeData(terminalAddress, '0000-00-00 00:00:00', 0.0);
           datas.add(activeData);
     
           if(unResponeseAck <= 0) {
     
             // 按输入顺序排序
             datas = sort(datas, terminalAddressList); 

             // 拼接到输出 stationResult
             for (int k = 0 ; k < datas.length ; k++) {
               final turbine = stationResult.waterTurbines[k];
               final data = datas[k];
               turbine?.deviceTerminal?.nearestRunningData?.dataCachedTime = data?.date ?? '0000-00-00 00:00:00';
               turbine?.deviceTerminal?.nearestRunningData?.power = data?.power ?? 0.0;
             }
             stationResult.totalMoney = _money;
             stationResult.totalActivePower = _totalActivePower;
             if(onGetStationInfo != null) onGetStationInfo(stationResult);
     
           }
         });
      }
   }


  // 多线程打乱了顺序,按输入顺序排序
  List<ActivePowerRunTimeData> sort(List<ActivePowerRunTimeData> oldDatas,List<String> terminalAddressList) {
    
    List<ActivePowerRunTimeData> result = [];

    for (int i = 0; i < terminalAddressList.length; i++) {
      final addr = terminalAddressList[i];
      for (int j = 0 ; j < oldDatas.length ; j++) {
        final item = oldDatas[j];
        if(item.address.compareTo(addr) == 0) {
          result.add(item);
          break;
        }
      }
    } 
    return result;
  }
  
  void dispose() {
    timer?.cancel();
  }
 

}


class GetUpgradeMissionState {
  
   int timerInterval;// 周期间隔 单位 s 秒
   String terminalAddress;
   String upgradeMissionId;
   List<String> upgradeTaskStates;
   Timer timer;

   void listen(String terminalAddress,String upgradeMissionId,List<String> taskProcessingStates,int timerInterval,UpdateTaskListCallBack onData) {

    this.terminalAddress = terminalAddress;
    this.upgradeMissionId = upgradeMissionId;
    this.timerInterval = timerInterval;
    this.upgradeTaskStates =taskProcessingStates;
    runTimeDataOnce(onData,null);

    timer = Timer.periodic(Duration(seconds: this.timerInterval), (t) {
      runTimeDataOnce(onData,(){
        t?.cancel();
      });
    });
  }

  // 运行时数据
  void runTimeDataOnce(UpdateTaskListCallBack onGetRuntimeData,void Function() onFail) {


    // 获取缓存数据
    APIUpdate.upgradeTaskList(

      terminalAddress: this.terminalAddress,
      upgradeMissionId: this.upgradeMissionId,
      upgradeTaskStates: this.upgradeTaskStates,
      onFail: (_){
        if(onFail != null)onFail();
      },
      onSucc: (data){
        if(onGetRuntimeData != null) onGetRuntimeData(data);
      });
  }
  
  void dispose() {
    timer?.cancel();
  }

}

class GetUpgradeMissionStateSingle {
  
   int timerInterval;// 周期间隔 单位 s 秒
   String upgradeMissionId;
   Timer timer;

   void listen(String upgradeMissionId,int timerInterval,UpdateTaskInfoCallBack onData) {

    this.upgradeMissionId = upgradeMissionId;
    this.timerInterval = timerInterval;
    runTimeDataOnce(onData,null);

    timer = Timer.periodic(Duration(seconds: this.timerInterval), (t) {
      runTimeDataOnce(onData,(){
        t?.cancel();
      });
    });
  }

  // 运行时数据
  void runTimeDataOnce(UpdateTaskInfoCallBack onGetRuntimeData,void Function() onFail) {


    // 获取缓存数据
    APIUpdate.upgradeTaskInfo(

      upgradeMissionId: this.upgradeMissionId,
      onFail: (_){
        if(onFail != null)onFail();
      },
      onSucc: (data){
        if(onGetRuntimeData != null) onGetRuntimeData(data);
      });
  }
  
  void dispose() {
    timer?.cancel();
  }

}