import 'package:hsa_app/debug/model/deviceTerminal.dart';

class WaterTurbine {
  String turbineId;  //水轮机组Id
  String stationNo;  //所属电站号
  int turbineInStationSeqNum;  //机组站内序号
  double ratedVoltageV;  //额定电压
  double ratedCurrentA;
  double ratedPowerKW;  //额定功率
  double ratedPowerKVA;
  double ratedSpeedRPM;
  double ratedExcitationCurrentA;
  int waterGateValveCount;
  double waterGateOpeningPercentum;
  double turbineSpeedRPM;
  DeviceTerminal deviceTerminal;
  int undisposedAlarmEventCount;
  bool enabledDoubleWaterGateValveControl;
  String runOnOffState;
  String controllerCabinetType;
  List<int> displayDigitalInputNos;
  List<String> temperatureMeasuringAliasName;

  WaterTurbine(
      {this.turbineId,
      this.stationNo,
      this.turbineInStationSeqNum,
      this.ratedVoltageV,
      this.ratedCurrentA,
      this.ratedPowerKW,
      this.ratedPowerKVA,
      this.ratedSpeedRPM,
      this.ratedExcitationCurrentA,
      this.waterGateValveCount,
      this.waterGateOpeningPercentum,
      this.turbineSpeedRPM,
      this.deviceTerminal,
      this.undisposedAlarmEventCount,
      this.enabledDoubleWaterGateValveControl,
      this.runOnOffState,
      this.controllerCabinetType,
      this.displayDigitalInputNos,
      this.temperatureMeasuringAliasName});

  WaterTurbine.fromJson(Map<String, dynamic> json) {
    turbineId = json['turbineId'];
    stationNo = json['stationNo'];
    turbineInStationSeqNum = json['turbineInStationSeqNum'];
    ratedVoltageV = json['ratedVoltageV'];
    ratedCurrentA = json['ratedCurrentA'];
    ratedPowerKW = json['ratedPowerKW'];
    ratedPowerKVA = json['ratedPowerKVA'];
    ratedSpeedRPM = json['ratedSpeedRPM'];
    ratedExcitationCurrentA = json['ratedExcitationCurrentA'];
    waterGateValveCount = json['waterGateValveCount'];
    waterGateOpeningPercentum = json['waterGateOpeningPercentum'];
    turbineSpeedRPM = json['turbineSpeedRPM'];
    deviceTerminal = json['deviceTerminal'] != null
        ? new DeviceTerminal.fromJson(json['deviceTerminal'])
        : null;
    undisposedAlarmEventCount = json['undisposedAlarmEventCount'];
    enabledDoubleWaterGateValveControl =
        json['enabledDoubleWaterGateValveControl'];
    runOnOffState = json['runOnOffState'];
    controllerCabinetType = json['controllerCabinetType'];
    displayDigitalInputNos = json['displayDigitalInputNos'].cast<int>();
    temperatureMeasuringAliasName =
        json['temperatureMeasuringAliasName'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['turbineId'] = this.turbineId;
    data['stationNo'] = this.stationNo;
    data['turbineInStationSeqNum'] = this.turbineInStationSeqNum;
    data['ratedVoltageV'] = this.ratedVoltageV;
    data['ratedCurrentA'] = this.ratedCurrentA;
    data['ratedPowerKW'] = this.ratedPowerKW;
    data['ratedPowerKVA'] = this.ratedPowerKVA;
    data['ratedSpeedRPM'] = this.ratedSpeedRPM;
    data['ratedExcitationCurrentA'] = this.ratedExcitationCurrentA;
    data['waterGateValveCount'] = this.waterGateValveCount;
    data['waterGateOpeningPercentum'] = this.waterGateOpeningPercentum;
    data['turbineSpeedRPM'] = this.turbineSpeedRPM;
    if (this.deviceTerminal != null) {
      data['deviceTerminal'] = this.deviceTerminal.toJson();
    }
    data['undisposedAlarmEventCount'] = this.undisposedAlarmEventCount;
    data['enabledDoubleWaterGateValveControl'] =
        this.enabledDoubleWaterGateValveControl;
    data['runOnOffState'] = this.runOnOffState;
    data['controllerCabinetType'] = this.controllerCabinetType;
    data['displayDigitalInputNos'] = this.displayDigitalInputNos;
    data['temperatureMeasuringAliasName'] = this.temperatureMeasuringAliasName;
    return data;
  }
}