import 'package:hsa_app/model/runtime_data.dart';

class RuntimeData {
  ElectricalPack electrical;
  DashBoardDataPack dashboard;
  OtherDataPack other;
}


class RuntimeDataAdapter {

 static RuntimeData adapter(RuntimeDataResponse data) {
   var runtimeData = RuntimeData();
   
  //  data.voltageAndCurrent
   runtimeData.electrical = ElectricalPack();
   runtimeData.electrical.voltage = ValueItem();
   runtimeData.electrical.current = ValueItem();
   runtimeData.electrical.excitation = ValueItem();
   runtimeData.electrical.powerFactor = ValueItem();
   
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
  num value;
  String title;
  String subTitile;
}
