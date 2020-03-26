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
  int generatorVoltageB;
  double generatorVoltageC;
  int generatorCurrentA;
  int generatorCurrentB;
  int generatorCurrentC;
  int generatorActivePowerAll;
  int generatorActivePowerA;
  int generatorActivePowerB;
  int generatorActivePowerC;
  int generatorReactivePowerAll;
  int generatorReactivePowerA;
  int generatorReactivePowerB;
  int generatorReactivePowerC;
  int generatorApparentPowerAll;
  int generatorApparentPowerA;
  int generatorApparentPowerB;
  int generatorApparentPowerC;
  int generatorPowerFactorAll;
  int generatorPowerFactorA;
  int generatorPowerFactorB;
  int generatorPowerFactorC;
  int generatorVoltageFreq;
  int gridVoltageA;
  int gridVoltageB;
  int gridVoltageC;
  double gridVoltageFreq;
  int phaseDifference;

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
    generatorVoltageA = json['generatorVoltageA'].cast<double>();
    generatorVoltageB = json['generatorVoltageB'].cast<double>();
    generatorVoltageC = json['generatorVoltageC'].cast<double>();
    generatorCurrentA = json['generatorCurrentA'].cast<double>();
    generatorCurrentB = json['generatorCurrentB'].cast<double>();
    generatorCurrentC = json['generatorCurrentC'].cast<double>();
    generatorActivePowerAll = json['generatorActivePowerAll'].cast<double>();
    generatorActivePowerA = json['generatorActivePowerA'].cast<double>();
    generatorActivePowerB = json['generatorActivePowerB'].cast<double>();
    generatorActivePowerC = json['generatorActivePowerC'].cast<double>();
    generatorReactivePowerAll = json['generatorReactivePowerAll'].cast<double>();
    generatorReactivePowerA = json['generatorReactivePowerA'].cast<double>();
    generatorReactivePowerB = json['generatorReactivePowerB'].cast<double>();
    generatorReactivePowerC = json['generatorReactivePowerC'].cast<double>();
    generatorApparentPowerAll = json['generatorApparentPowerAll'].cast<double>();
    generatorApparentPowerA = json['generatorApparentPowerA'].cast<double>();
    generatorApparentPowerB = json['generatorApparentPowerB'].cast<double>();
    generatorApparentPowerC = json['generatorApparentPowerC'].cast<double>();
    generatorPowerFactorAll = json['generatorPowerFactorAll'].cast<double>();
    generatorPowerFactorA = json['generatorPowerFactorA'].cast<double>();
    generatorPowerFactorB = json['generatorPowerFactorB'].cast<double>();
    generatorPowerFactorC = json['generatorPowerFactorC'].cast<double>();
    generatorVoltageFreq = json['generatorVoltageFreq'].cast<double>();
    gridVoltageA = json['gridVoltageA'].cast<double>();
    gridVoltageB = json['gridVoltageB'].cast<double>();
    gridVoltageC = json['gridVoltageC'].cast<double>();
    gridVoltageFreq = json['gridVoltageFreq'].cast<double>();
    phaseDifference = json['phaseDifference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generatorVoltageA'] = this.generatorVoltageA;
    data['generatorVoltageB'] = this.generatorVoltageB;
    data['generatorVoltageC'] = this.generatorVoltageC;
    data['generatorCurrentA'] = this.generatorCurrentA;
    data['generatorCurrentB'] = this.generatorCurrentB;
    data['generatorCurrentC'] = this.generatorCurrentC;
    data['generatorActivePowerAll'] = this.generatorActivePowerAll;
    data['generatorActivePowerA'] = this.generatorActivePowerA;
    data['generatorActivePowerB'] = this.generatorActivePowerB;
    data['generatorActivePowerC'] = this.generatorActivePowerC;
    data['generatorReactivePowerAll'] = this.generatorReactivePowerAll;
    data['generatorReactivePowerA'] = this.generatorReactivePowerA;
    data['generatorReactivePowerB'] = this.generatorReactivePowerB;
    data['generatorReactivePowerC'] = this.generatorReactivePowerC;
    data['generatorApparentPowerAll'] = this.generatorApparentPowerAll;
    data['generatorApparentPowerA'] = this.generatorApparentPowerA;
    data['generatorApparentPowerB'] = this.generatorApparentPowerB;
    data['generatorApparentPowerC'] = this.generatorApparentPowerC;
    data['generatorPowerFactorAll'] = this.generatorPowerFactorAll;
    data['generatorPowerFactorA'] = this.generatorPowerFactorA;
    data['generatorPowerFactorB'] = this.generatorPowerFactorB;
    data['generatorPowerFactorC'] = this.generatorPowerFactorC;
    data['generatorVoltageFreq'] = this.generatorVoltageFreq;
    data['gridVoltageA'] = this.gridVoltageA;
    data['gridVoltageB'] = this.gridVoltageB;
    data['gridVoltageC'] = this.gridVoltageC;
    data['gridVoltageFreq'] = this.gridVoltageFreq;
    data['phaseDifference'] = this.phaseDifference;
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
  int fieldCurrent;
  int freq;
  int setPoint;
  int controlAngle;

  TrubineExcitationComponent(
      {this.fieldCurrent, this.freq, this.setPoint, this.controlAngle});

  TrubineExcitationComponent.fromJson(Map<String, dynamic> json) {
    fieldCurrent = json['fieldCurrent'];
    freq = json['freq'];
    setPoint = json['setPoint'];
    controlAngle = json['controlAngle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldCurrent'] = this.fieldCurrent;
    data['freq'] = this.freq;
    data['setPoint'] = this.setPoint;
    data['controlAngle'] = this.controlAngle;
    return data;
  }
}

class TurbineRuningStage {
  int measuringWaterLevel;
  int dropWaterLevel;
  List<int> openAngle;
  int speed;

  TurbineRuningStage(
      {this.measuringWaterLevel,
      this.dropWaterLevel,
      this.openAngle,
      this.speed});

  TurbineRuningStage.fromJson(Map<String, dynamic> json) {
    measuringWaterLevel = json['measuringWaterLevel'];
    dropWaterLevel = json['dropWaterLevel'];
    openAngle = json['openAngle'].cast<int>();
    speed = json['speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['measuringWaterLevel'] = this.measuringWaterLevel;
    data['dropWaterLevel'] = this.dropWaterLevel;
    data['openAngle'] = this.openAngle;
    data['speed'] = this.speed;
    return data;
  }
}