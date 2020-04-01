// 获取实时参数定时任务
import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:hsa_app/agent/agent.dart';
import 'package:hsa_app/debug/model/all_model.dart';
import 'package:hsa_app/debug/model/electricity_price.dart';

// 供展示的实时有功数据体
class ActivePowerRunTimeData {

  final String address;
  final String date;
  final String power;
  ActivePowerRunTimeData(this.address, this.date, this.power);
  
}

// 实时运行参数页返回 - 实时参数
typedef NearestRunningDataCallBack = void Function(NearestRunningData runtimeData);

// 电站概要页返回 - 当前有功,电站总有功,当日电站总收益
typedef StationInfoDataCallBack = void Function(List<ActivePowerRunTimeData> datas,String totalActivePower,String totalMoney);

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


 // 持续获取某个电站下,多个终端运行数据 获取当前有功和电量、预估值, 仅支持在线的终端
class AgentStationInfoDataLoopTimerTasker {
  
   AgentStationInfoDataLoopTimerTasker({this.isBaseList,this.terminalAddressList,this.timerInterval = 5,this.price});

   // 周期间隔 单位 s 秒
   final int timerInterval;
   final List<String> terminalAddressList;
   final List<bool> isBaseList;
   // 电价
   final ElectricityPrice price;
   Timer timer;

   void start (StationInfoDataCallBack onGetStationInfo) {

   // 总收益
   double _money = 0.0;
   // 当前有功
   List<ActivePowerRunTimeData> datas = [];
   // 总有功
   double _totalActivePower = 0.0;

   // 剩余未返回次数
   int unResponeseAck = 0;

    if(terminalAddressList == null)return;
    if(isBaseList == null)return;
    if(terminalAddressList.length == 0)return;
    if(isBaseList.length == 0)return;
    if(terminalAddressList.length != isBaseList.length) return;

    // 定时读取
    timer = Timer.periodic(Duration(seconds: timerInterval), (t) {

    // 初始化
    _money = 0.0;
    _totalActivePower = 0.0;
    datas = [];
    unResponeseAck = terminalAddressList.length;

    // 并发召测当前有功和电量、预估值
    for (int i = 0 ; i < terminalAddressList.length ; i++) {
      final terminalAddress = terminalAddressList[i];
      final isBase = isBaseList[i];
      AgentQueryAPI.remoteMeasuringElectricParam(terminalAddress, isBase);
    }

    for (int j = 0; j < terminalAddressList.length; j++) {

        final terminalAddress = terminalAddressList[j];
        final isBase = isBaseList[j];

        AgentQueryAPI.qureryTerminalNearestRunningData(address: terminalAddress, isBase: isBase,price: price,onSucc: (data,msg){

          unResponeseAck -- ;

          final active = data.power;
          final date = data.dataCachedTime;
          final activeData =  ActivePowerRunTimeData(terminalAddress, date, active.toStringAsFixed(0));
          datas.add(activeData);

          _totalActivePower += active;
          _money += data.money;
          
          if(unResponeseAck <= 0) {

            // 按输入顺序排序
            datas = sort(datas, terminalAddressList); 
            if(onGetStationInfo != null) onGetStationInfo(datas,_totalActivePower.toStringAsFixed(1),_money.toStringAsFixed(2));
          }
        },onFail: (msg){

          unResponeseAck --;

          final dateStr = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd,' ',hh, ':', nn, ':', ss]);
          final activeData =  ActivePowerRunTimeData(terminalAddress, dateStr, '0');
          datas.add(activeData);

          if(unResponeseAck <= 0) {

            // 按输入顺序排序
            datas = sort(datas, terminalAddressList); 
            if(onGetStationInfo != null) onGetStationInfo(datas,_totalActivePower.toStringAsFixed(1),_money.toStringAsFixed(2));

          }
        });
     }

    });
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
  
  void stop () {
    timer?.cancel();
  }
 

}