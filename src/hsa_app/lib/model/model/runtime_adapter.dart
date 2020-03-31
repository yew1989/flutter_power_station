import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_data.dart';
import 'package:hsa_app/page/dialog/control_model_dialog.dart';

class EventTileData {
  final String leftString;
  final String rightString;
  EventTileData(this.leftString, this.rightString);
}

class RuntimeData {
  ElectricalPack electrical;
  DashBoardDataPack dashboard;
  OtherDataPack other;
  List<EventTileData> events;
  ControlModelCurrentStatus status;
  bool isMotorPowerOn;
  num equippedCapacitor;
}


class RuntimeDataAdapter {

  // 计算百分比 可以超过 1
 static double caclulatePencent(double now,double max){
   if(max == 0) return 0.0;
   if(now == 0) return 0.0;
   var percent = now / max ;
   return percent.toDouble();
 }

 // 获取推力
 static String getThrust(List<Temperatures> temperatures){
    for (var tempItem in temperatures) {
     if(tempItem.mItem1.compareTo('推力') == 0) {
       return tempItem?.mItem2 ?? '0.0';
     }
   }
   return '0.0';
 }

  // 获取首项指标名称
 static String getFirstItemName(List<Temperatures> temperatures){
   if(temperatures == null) return '径向';
   if(temperatures.length == 0) return '径向';
   var firstItem = temperatures.first;
   var name = firstItem?.mItem1 ?? '径向';
   return name;
 }

// 获取首项指标值
 static String getFirstItemValue(List<Temperatures> temperatures){
   if(temperatures == null) return '0.0';
   if(temperatures.length == 0) return '0.0';
   var firstItem = temperatures.first;
   var name = firstItem?.mItem2 ?? '0.0';
   return name;
 }

 // 判断是否可信 - 可信标准为 冻结时间 在 5分钟内
 static bool isDataAvailable(RuntimeDataResponse data) {
    var freezeTime = data?.voltageAndCurrent?.freezeTime ?? '';
    freezeTime = freezeTime.replaceAll('T', ' ');// 替换 C# 时间戳中的 T
    DateTime now = DateTime.now();
    DateTime freeze = DateTime.parse(freezeTime);
    var t = now.millisecondsSinceEpoch - freeze.millisecondsSinceEpoch;
    var minuteFive = 5 * 60 * 1000;
    return t > minuteFive ? false : true;
 }

 // 机组开关机状态
//  static bool motorPowerBool(RuntimeDataResponse data) {

//    var statusString = data?.terminalInfo?.waterTurbineStartStopState ?? '未定义';
//    if(statusString.compareTo('正在开机') == 0 || statusString.compareTo('并网运行') == 0) {
//       var isAvailable = isDataAvailable(data);
//       return isAvailable;
//    }
//    else if(statusString.compareTo('正在关机') == 0 || statusString.compareTo('机组关机') == 0) {
//      return false;
//    }
//    else if(statusString.compareTo('未定义') == 0) {
//       var volt = data?.voltageAndCurrent?.aV?.toDouble() ?? 0.0;
//       if(volt <= 50) {
//         return false;
//       }
//       else if (volt > 50){
//         var isAvailable = isDataAvailable(data);
//         return isAvailable;
//       }
//       return false;
//    }
//    return false;
//  }



 static RuntimeData adapter(DeviceTerminal data,String alias) {
   // 运行参数
   var runtimeData = RuntimeData();
   
   // 电气封装包
   runtimeData.electrical = ElectricalPack();

   // 获取最大值
   var voltageMax     = data?.waterTurbine?.ratedVoltageV?.toDouble() ?? 0.0;
   var currentMax     = data?.waterTurbine?.ratedCurrentA?.toDouble() ?? 0.0;
   var excitationMax  = data?.waterTurbine?.ratedExcitationCurrentA?.toDouble() ?? 0.0;
   var powerFactorMax = 1.0;
   
   // 获取当前值
   var voltageNow     = data?.nearestRunningData?.voltage?.toDouble() ?? 0.0;
   var currentNow     = data?.nearestRunningData?.current?.toDouble() ?? 0.0;
   var excitationNow  = data?.nearestRunningData?.fieldCurrent?.toDouble() ?? 0.0;
   var powerFactorNow = data?.nearestRunningData?.power?.toDouble() ?? 0.0;

   // 获取比例值
   var voltagePercent     = RuntimeDataAdapter.caclulatePencent(voltageNow,voltageMax);
   var currentPercent     = RuntimeDataAdapter.caclulatePencent(currentNow,currentMax);
   var excitationPercent  = RuntimeDataAdapter.caclulatePencent(excitationNow,excitationMax);
   var powerFactorPercent = RuntimeDataAdapter.caclulatePencent(powerFactorNow,powerFactorMax);

   // 电压
   runtimeData.electrical.voltage     = ValueItem(now: voltageNow,max: voltageMax,percent: voltagePercent);
   // 电流
   runtimeData.electrical.current     = ValueItem(now: currentNow,max: currentMax,percent: currentPercent);
   // 励磁电流
   runtimeData.electrical.excitation  = ValueItem(now: excitationNow,max: excitationMax,percent: excitationPercent);
   // 功率因数
   runtimeData.electrical.powerFactor = ValueItem(now: powerFactorNow,max: powerFactorMax,percent: powerFactorPercent);
   
   // 最大装机功率
   runtimeData.equippedCapacitor =  data?.waterTurbine?.ratedPowerKW ?? 0.0;
   
   // 功率面板
   runtimeData.dashboard = DashBoardDataPack();
    
   // 主机与别名
   //var workModel = data?.terminalInfo?.workModel ?? '';
   //var isMaster = workModel == '主机' ? true :false;
   var isMaster = data.isMaster;
   var aliasName =  alias ?? '';
   
   runtimeData.dashboard.isMaster = isMaster;
   runtimeData.dashboard.aliasName = aliasName;

   // 额定有功☑️ / 视在功率 ❌ 
   var powerMax = data?.waterTurbine?.ratedPowerKW?.toDouble() ?? 0.0;
   var openMax  = 1.0;
   var freqMax  = 50.0;

   var powerNow = data?.nearestRunningData?.power?.toDouble() ?? 0.0;
   var openNow  = data?.nearestRunningData?.openAngle?.toDouble() ?? 0.0;
   var freqNow  = data?.nearestRunningData?.frequency?.toDouble() ?? 0.0;

   var powerPercent   = RuntimeDataAdapter.caclulatePencent(powerNow,powerMax);
   var openPercent    = RuntimeDataAdapter.caclulatePencent(openNow,openMax);
   var freqPercent    = RuntimeDataAdapter.caclulatePencent(freqNow,freqMax);

   runtimeData.dashboard.power = ValueItem(now: powerNow,max: powerMax,percent: powerPercent);
   runtimeData.dashboard.open  = ValueItem(now: openNow,max: openMax,percent: openPercent);
   runtimeData.dashboard.freq  = ValueItem(now: freqNow,max: freqMax,percent: freqPercent);

   // 其他信息
   runtimeData.other = OtherDataPack();

   // 温度数组
   //var temperatures  = data?.waterTurbine?.temperatureMeasuringAliasName ?? [];
   
   // 首项
   var radialName  = '径向';//getFirstItemName(temperatures);
   var radialValue = 0.0;//data?.nearestRunningData?.;//getFirstItemValue(temperatures);
   // 推力
   var thrustStr = data?.nearestRunningData?.thrust ?? 0.0;//getThrust(temperatures);

   // 水压
   var waterPressures = data?.nearestRunningData?.waterPressure ?? 0.0;
   var pressure = waterPressures ?? 0.0;

   runtimeData.other.radial   = OtherData(title: radialValue.toString(),subTitle: radialName);
   runtimeData.other.thrust   = OtherData(title: thrustStr.toString() ,subTitle: '推力:N');
   runtimeData.other.pressure = OtherData(title: pressure.toString(),subTitle: '水压:MPa');


   // 事件列表
   runtimeData.events = List<EventTileData>();
   // 记录
  //  var records = data?.workSupportData?.recentAlarmEventRecord;
  //  if(records!=null) {
  //    for (var record in records) {
  //      var right = record?.freezeTime ?? '';
  //      right = right.replaceAll('T', ' ');// 替换 C# 时间戳中的 T
  //      var left  = 'ERC' + record?.eRCFlag.toString() + '--' +  record?.eRCTitle;
  //      var event = EventTileData(left,right);
  //      runtimeData.events.add(event);
  //    }
  //  }

   // 当前状态
   var modelString = data?.controlType ?? '未知';
   var isAllowRemoteControl = data?.isAllowRemoteControl ?? false;
   if(modelString.compareTo('未知') == 0) {
     runtimeData.status = ControlModelCurrentStatus.unknow;
   }
   else if(modelString.compareTo('手动') == 0) {
     runtimeData.status = ControlModelCurrentStatus.manual;
   }
   else if(modelString.compareTo('自动') == 0) {
     runtimeData.status = ControlModelCurrentStatus.auto;
   }
   else if(modelString.compareTo('智能') == 0) {
     runtimeData.status = isAllowRemoteControl ? ControlModelCurrentStatus.remoteOn : ControlModelCurrentStatus.remoteOff;
   }
   // 开关机状态
   runtimeData.isMotorPowerOn = true;//motorPowerBool(data);

   return runtimeData;
 }

}

class ElectricalPack {
  ValueItem voltage;
  ValueItem current;
  ValueItem excitation;
  ValueItem powerFactor;
}

class ValueItem {
  ValueItem({this.now,this.max,this.percent});
  num now;
  num max;
  num percent;
}

class DashBoardDataPack {
  bool isMaster;
  String aliasName;
  ValueItem open;
  ValueItem freq;
  ValueItem power;
}

class OtherDataPack {
  OtherData radial;
  OtherData thrust;
  OtherData pressure;
}

class OtherData {
  OtherData({this.title,this.subTitle});
  String title;
  String subTitle;
}
