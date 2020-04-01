class Turbine {
  String id;
  String stationNo;
  String terminalAddress;
  String deviceTerminalType;
  String deviceTerminalHardware;
  String freezeTime;
  TurbineElectricalPower turbineElectricalPower;
  TurbineControlState turbineControlState;
  TrubineExcitationComponent trubineExcitationComponent;
  TurbineRuningStage turbineRuningStage;

  Turbine(
      {this.id,
      this.stationNo,
      this.terminalAddress,
      this.deviceTerminalType,
      this.deviceTerminalHardware,
      this.freezeTime,
      this.turbineElectricalPower,
      this.turbineControlState,
      this.trubineExcitationComponent,
      this.turbineRuningStage});

  Turbine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationNo = json['stationNo'];
    terminalAddress = json['terminalAddress'];
    deviceTerminalType = json['deviceTerminalType'];
    deviceTerminalHardware = json['deviceTerminalHardware'];
    freezeTime = json['freezeTime'];
    turbineElectricalPower = json['turbineElectricalPower'] != null
        ? new TurbineElectricalPower.fromJson(json['turbineElectricalPower'])
        : null;
    turbineControlState = json['turbineControlState'] != null
        ? new TurbineControlState.fromJson(json['turbineControlState'])
        : null;
    trubineExcitationComponent = json['trubineExcitationComponent'] != null
        ? new TrubineExcitationComponent.fromJson(
            json['trubineExcitationComponent'])
        : null;
    turbineRuningStage = json['turbineRuningStage'] != null
        ? new TurbineRuningStage.fromJson(json['turbineRuningStage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stationNo'] = this.stationNo;
    data['terminalAddress'] = this.terminalAddress;
    data['deviceTerminalType'] = this.deviceTerminalType;
    data['deviceTerminalHardware'] = this.deviceTerminalHardware;
    data['freezeTime'] = this.freezeTime;
    if (this.turbineElectricalPower != null) {
      data['turbineElectricalPower'] = this.turbineElectricalPower.toJson();
    }
    if (this.turbineControlState != null) {
      data['turbineControlState'] = this.turbineControlState.toJson();
    }
    if (this.trubineExcitationComponent != null) {
      data['trubineExcitationComponent'] =
          this.trubineExcitationComponent.toJson();
    }
    if (this.turbineRuningStage != null) {
      data['turbineRuningStage'] = this.turbineRuningStage.toJson();
    }
    return data;
  }
}

class TurbineElectricalPower {
  double generatorVoltageA;
  double generatorVoltageB;
  double generatorVoltageC;
  double generatorCurrentA;
  double generatorCurrentB;
  double generatorCurrentC;
  double generatorActivePowerAll;
  double generatorActivePowerA;
  double generatorActivePowerB;
  double generatorActivePowerC;
  double generatorReactivePowerAll;
  double generatorReactivePowerA;
  double generatorReactivePowerB;
  double generatorReactivePowerC;
  double generatorApparentPowerAll;
  double generatorApparentPowerA;
  double generatorApparentPowerB;
  double generatorApparentPowerC;
  double generatorPowerFactorAll;
  double generatorPowerFactorA;
  double generatorPowerFactorB;
  double generatorPowerFactorC;
  double generatorVoltageFreq;
  double gridVoltageA;
  double gridVoltageB;
  double gridVoltageC;
  double gridVoltageFreq;
  double phaseDifference;

  TurbineElectricalPower(
      {this.generatorVoltageA,
      this.generatorVoltageB,
      this.generatorVoltageC,
      this.generatorCurrentA,
      this.generatorCurrentB,
      this.generatorCurrentC,
      this.generatorActivePowerAll,
      this.generatorActivePowerA,
      this.generatorActivePowerB,
      this.generatorActivePowerC,
      this.generatorReactivePowerAll,
      this.generatorReactivePowerA,
      this.generatorReactivePowerB,
      this.generatorReactivePowerC,
      this.generatorApparentPowerAll,
      this.generatorApparentPowerA,
      this.generatorApparentPowerB,
      this.generatorApparentPowerC,
      this.generatorPowerFactorAll,
      this.generatorPowerFactorA,
      this.generatorPowerFactorB,
      this.generatorPowerFactorC,
      this.generatorVoltageFreq,
      this.gridVoltageA,
      this.gridVoltageB,
      this.gridVoltageC,
      this.gridVoltageFreq,
      this.phaseDifference});

  TurbineElectricalPower.fromJson(Map<String, dynamic> json) {
    generatorVoltageA = json['发电机A相电压'].cast<double>();
    generatorVoltageB = json['发电机B相电压'].cast<double>();
    generatorVoltageC = json['发电机C相电压'].cast<double>();
    generatorCurrentA = json['发电机A相电流'].cast<double>();
    generatorCurrentB = json['发电机B相电流'].cast<double>();
    generatorCurrentC = json['发电机C相电流'].cast<double>();
    generatorActivePowerAll = json['发电机总有功功率'].cast<double>();
    generatorActivePowerA = json['发电机A相有功功率'].cast<double>();
    generatorActivePowerB = json['发电机B相有功功率'].cast<double>();
    generatorActivePowerC = json['发电机C相有功功率'].cast<double>();
    generatorReactivePowerAll = json['发电机总无功功率'].cast<double>();
    generatorReactivePowerA = json['发电机A相无功功率'].cast<double>();
    generatorReactivePowerB = json['发电机B相无功功率'].cast<double>();
    generatorReactivePowerC = json['发电机C相无功功率'].cast<double>();
    generatorApparentPowerAll = json['发电机总视在功率'].cast<double>();
    generatorApparentPowerA = json['发电机A相视在功率'].cast<double>();
    generatorApparentPowerB = json['发电机B相视在功率'].cast<double>();
    generatorApparentPowerC = json['发电机C相视在功率'].cast<double>();
    generatorPowerFactorAll = json['发电机总功率因数'].cast<double>();
    generatorPowerFactorA = json['发电机A相功率因数'].cast<double>();
    generatorPowerFactorB = json['发电机B相功率因数'].cast<double>();
    generatorPowerFactorC = json['发电机C相功率因数'].cast<double>();
    generatorVoltageFreq = json['发电机电压频率'].cast<double>();
    gridVoltageA = json['电网A相电压'].cast<double>();
    gridVoltageB = json['电网B相电压'].cast<double>();
    gridVoltageC = json['电网C相电压'].cast<double>();
    gridVoltageFreq = json['电网电压频率'].cast<double>();
    phaseDifference = json['发电机与电网电压相位差'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['发电机A相电压'] = this.generatorVoltageA;
    data['发电机B相电压'] = this.generatorVoltageB;
    data['发电机C相电压'] = this.generatorVoltageC;
    data['发电机A相电流'] = this.generatorCurrentA;
    data['发电机B相电流'] = this.generatorCurrentB;
    data['发电机C相电流'] = this.generatorCurrentC;
    data['发电机总有功功率'] = this.generatorActivePowerAll;
    data['发电机A相有功功率'] = this.generatorActivePowerA;
    data['发电机B相有功功率'] = this.generatorActivePowerB;
    data['发电机C相有功功率'] = this.generatorActivePowerC;
    data['发电机总无功功率'] = this.generatorReactivePowerAll;
    data['发电机A相无功功率'] = this.generatorReactivePowerA;
    data['发电机B相无功功率'] = this.generatorReactivePowerB;
    data['发电机C相无功功率'] = this.generatorReactivePowerC;
    data['发电机总视在功率'] = this.generatorApparentPowerAll;
    data['发电机A相视在功率'] = this.generatorApparentPowerA;
    data['发电机B相视在功率'] = this.generatorApparentPowerB;
    data['发电机C相视在功率'] = this.generatorApparentPowerC;
    data['发电机总功率因数'] = this.generatorPowerFactorAll;
    data['发电机A相功率因数'] = this.generatorPowerFactorA;
    data['发电机B相功率因数'] = this.generatorPowerFactorB;
    data['发电机C相功率因数'] = this.generatorPowerFactorC;
    data['发电机电压频率'] = this.generatorVoltageFreq;
    data['电网A相电压'] = this.gridVoltageA;
    data['电网B相电压'] = this.gridVoltageB;
    data['电网C相电压'] = this.gridVoltageC;
    data['电网电压频率'] = this.gridVoltageFreq;
    data['发电机与电网电压相位差'] = this.phaseDifference;
    return data;
  }
}

class TurbineControlState {
  bool isMaster;
  bool isAllowRemoteControl;
  String controlType;
  String needleControlScheme;
  String intelligentControlScheme;

  TurbineControlState(
      {this.isMaster,
      this.isAllowRemoteControl,
      this.controlType,
      this.needleControlScheme,
      this.intelligentControlScheme});

  TurbineControlState.fromJson(Map<String, dynamic> json) {
    isMaster = json['isMaster'];
    isAllowRemoteControl = json['isAllowRemoteControl'];
    controlType = json['controlType'];
    needleControlScheme = json['needleControlScheme'];
    intelligentControlScheme = json['intelligentControlScheme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMaster'] = this.isMaster;
    data['isAllowRemoteControl'] = this.isAllowRemoteControl;
    data['controlType'] = this.controlType;
    data['needleControlScheme'] = this.needleControlScheme;
    data['intelligentControlScheme'] = this.intelligentControlScheme;
    return data;
  }
}

class TrubineExcitationComponent {
  double fieldCurrent;
  double freq;
  double setPoint;
  double controlAngle;

  TrubineExcitationComponent(
      {this.fieldCurrent, this.freq, this.setPoint, this.controlAngle});

  TrubineExcitationComponent.fromJson(Map<String, dynamic> json) {
    fieldCurrent = json['励磁电流'].cast<double>();
    freq = json['freq'].cast<double>();
    setPoint = json['setPoint'].cast<double>();
    controlAngle = json['controlAngle'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['励磁电流'] = this.fieldCurrent;
    data['freq'] = this.freq;
    data['setPoint'] = this.setPoint;
    data['controlAngle'] = this.controlAngle;
    return data;
  }
}

class TurbineRuningStage {
  double measuringWaterLevel;
  double dropWaterLevel;
  List<double> openAngle;
  double speed;

  TurbineRuningStage(
      {this.measuringWaterLevel,
      this.dropWaterLevel,
      this.openAngle,
      this.speed});

  TurbineRuningStage.fromJson(Map<String, dynamic> json) {
    measuringWaterLevel = json['测量水位'].cast<double>();
    dropWaterLevel = json['落差水位'].cast<double>();
    openAngle = json['开度'].cast<List<double>>();
    speed = json['转速'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['测量水位'] = this.measuringWaterLevel;
    data['落差水位'] = this.dropWaterLevel;
    data['开度'] = this.openAngle;
    data['转速'] = this.speed;
    return data;
  }
}