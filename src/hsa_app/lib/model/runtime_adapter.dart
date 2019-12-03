import 'package:hsa_app/model/runtime_data.dart';

class RuntimeData {
  ElectricalPack electrical;
  DashBoardDataPack dashboard;
  OtherDataPack other;
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
       return tempItem?.mItem2 ?? '';
     }
   }
   return '0.0';
 }

  // 获取径向温度
 static String getRadial(List<Temperatures> temperatures){
    for (var tempItem in temperatures) {
     if(tempItem.mItem1.compareTo('径向') == 0) {
       return tempItem?.mItem2 ?? '';
     }
   }
   return '0.0';
 }


 static RuntimeData adapter(RuntimeDataResponse data,String alias) {
   // 运行参数
   var runtimeData = RuntimeData();
   
   // 电气封装包
   runtimeData.electrical = ElectricalPack();

   // 获取最大值
   var voltageMax     = data?.terminalInfo?.waterTurbineRatedV?.toDouble() ?? 0.0;
   var currentMax     = data?.terminalInfo?.waterTurbineRatedA?.toDouble() ?? 0.0;
   var excitationMax  = data?.terminalInfo?.waterTurbineExcitationCurrentA?.toDouble() ?? 0.0;
   var powerFactorMax = 1.0;
   
   // 获取当前值
   var voltageNow     = data?.voltageAndCurrent?.aV?.toDouble() ?? 0.0;
   var currentNow     = data?.voltageAndCurrent?.aA?.toDouble() ?? 0.0;
   var excitationNow  = data?.workSupportData?.excitationCurrentA?.toDouble() ?? 0.0;
   var powerFactorNow = data?.power?.tPf?.toDouble() ?? 0.0;

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
   

   // 功率面板
   runtimeData.dashboard = DashBoardDataPack();
    
   // 主机与别名
   var workModel = data?.terminalInfo?.workModel ?? '';
   var isMaster = workModel == '主机' ? true :false;
   var aliasName =  alias ?? '';
   
   runtimeData.dashboard.isMaster = isMaster;
   runtimeData.dashboard.aliasName = aliasName;

   // 额定有功☑️ / 视在功率 ❌ 
   var powerMax = data?.terminalInfo?.waterTurbineRatedActivePower?.toDouble() ?? 0.0;
   var openMax  = 1.0;
   var freqMax  = 50.0;

   var powerNow = data?.power?.tkW?.toDouble() ?? 0.0;
   var openNow  = data?.workSupportData?.gateOpening?.toDouble() ?? 0.0;
   var freqNow  = data?.voltageAndCurrent?.vHz?.toDouble() ?? 0.0;

   var powerPercent   = RuntimeDataAdapter.caclulatePencent(powerNow,powerMax);
   var openPercent    = RuntimeDataAdapter.caclulatePencent(openNow,openMax);
   var freqPercent    = RuntimeDataAdapter.caclulatePencent(freqNow,freqMax);

   runtimeData.dashboard.power = ValueItem(now: powerNow,max: powerMax,percent: powerPercent);
   runtimeData.dashboard.open  = ValueItem(now: openNow,max: openMax,percent: openPercent);
   runtimeData.dashboard.freq  = ValueItem(now: freqNow,max: freqMax,percent: freqPercent);

   // 其他信息
   runtimeData.other = OtherDataPack();

   // 温度数组
   var temperatures  = data?.workSupportData?.temperatures ?? [];
   
   // 径向
   var radial = getRadial(temperatures);
   // 推力
   var thrustStr = getThrust(temperatures);
   // 水压
   var pressure = data?.workSupportData?.waterPressures?.toDouble() ?? 0.0;

   runtimeData.other.radial   = OtherData(title: radial,subTitle: '径向  ');
   runtimeData.other.thrust   = OtherData(title: thrustStr ,subTitle: '推力:N');
   runtimeData.other.pressure = OtherData(title: pressure.toString(),subTitle: '水压:MPa');


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
