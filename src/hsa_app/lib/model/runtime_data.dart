class RuntimeDataResponse {

  String address;
  VoltageAndCurrent voltageAndCurrent;
  RuntimeDataPower power;
  WorkSupportData workSupportData;
  TerminalInfo terminalInfo;

  RuntimeDataResponse(
    {this.address,
      this.voltageAndCurrent,
      this.power,
      this.workSupportData,
      this.terminalInfo});

  RuntimeDataResponse.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    voltageAndCurrent = json['VoltageAndCurrent'] != null
        ? VoltageAndCurrent.fromJson(json['VoltageAndCurrent'])
        : null;
    power = json['Power'] != null ? RuntimeDataPower.fromJson(json['Power']) : null;
    workSupportData = json['WorkSupportData'] != null
        ? WorkSupportData.fromJson(json['WorkSupportData'])
        : null;
    terminalInfo = json['TerminalInfo'] != null
        ? TerminalInfo.fromJson(json['TerminalInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Address'] = this.address;
    if (this.voltageAndCurrent != null) {
      data['VoltageAndCurrent'] = this.voltageAndCurrent.toJson();
    }
    if (this.power != null) {
      data['Power'] = this.power.toJson();
    }
    if (this.workSupportData != null) {
      data['WorkSupportData'] = this.workSupportData.toJson();
    }
    if (this.terminalInfo != null) {
      data['TerminalInfo'] = this.terminalInfo.toJson();
    }
    return data;
  }
}

class VoltageAndCurrent {
  String freezeTime;
  double gV;
  double aV;
  double bV;
  double cV;
  double aA;
  double bA;
  double cA;
  double gVHz;
  double vHz;

  VoltageAndCurrent(
      {this.freezeTime,
      this.gV,
      this.aV,
      this.bV,
      this.cV,
      this.aA,
      this.bA,
      this.cA,
      this.gVHz,
      this.vHz});

  VoltageAndCurrent.fromJson(Map<String, dynamic> json) {
    freezeTime = json['FreezeTime'];
    gV = json['GV'];
    aV = json['AV'];
    bV = json['BV'];
    cV = json['CV'];
    aA = json['AA'];
    bA = json['BA'];
    cA = json['CA'];
    gVHz = json['GVHz'];
    vHz = json['VHz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['FreezeTime'] = this.freezeTime;
    data['GV'] = this.gV;
    data['AV'] = this.aV;
    data['BV'] = this.bV;
    data['CV'] = this.cV;
    data['AA'] = this.aA;
    data['BA'] = this.bA;
    data['CA'] = this.cA;
    data['GVHz'] = this.gVHz;
    data['VHz'] = this.vHz;
    return data;
  }
}

class RuntimeDataPower {
  String freezeTime;
  double tPf;
  double tkvar;
  double tkW;
  double akW;
  double bkW;
  double ckW;
  double tkVA;
  double akvar;
  double bkvar;
  double ckvar;

  RuntimeDataPower(
      {this.freezeTime,
      this.tPf,
      this.tkvar,
      this.tkW,
      this.akW,
      this.bkW,
      this.ckW,
      this.tkVA,
      this.akvar,
      this.bkvar,
      this.ckvar});

  RuntimeDataPower.fromJson(Map<String, dynamic> json) {
    freezeTime = json['FreezeTime'];
    tPf = json['TPf'];
    tkvar = json['Tkvar'];
    tkW = json['TkW'];
    akW = json['AkW'];
    bkW = json['BkW'];
    ckW = json['CkW'];
    tkVA = json['TkVA'];
    akvar = json['Akvar'];
    bkvar = json['Bkvar'];
    ckvar = json['Ckvar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['FreezeTime'] = this.freezeTime;
    data['TPf'] = this.tPf;
    data['Tkvar'] = this.tkvar;
    data['TkW'] = this.tkW;
    data['AkW'] = this.akW;
    data['BkW'] = this.bkW;
    data['CkW'] = this.ckW;
    data['TkVA'] = this.tkVA;
    data['Akvar'] = this.akvar;
    data['Bkvar'] = this.bkvar;
    data['Ckvar'] = this.ckvar;
    return data;
  }
}

class WorkSupportData {
  String freezeTime;
  double gateOpening;
  List<double> gateOpenings;
  int relativeMaxWaterStage;
  int waterStageAlarmValue;
  double waterStage;
  int altitudeWaterStage;
  Null coolingWaterStage;
  double rPM;
  double excitationCurrentA;
  bool gateHLimit;
  bool gateLLimit;
  List<Temperatures> temperatures;
  Null waterPressures;
  List<RecentAlarmEventRecord> recentAlarmEventRecord;

  WorkSupportData(
      {this.freezeTime,
      this.gateOpening,
      this.gateOpenings,
      this.relativeMaxWaterStage,
      this.waterStageAlarmValue,
      this.waterStage,
      this.altitudeWaterStage,
      this.coolingWaterStage,
      this.rPM,
      this.excitationCurrentA,
      this.gateHLimit,
      this.gateLLimit,
      this.temperatures,
      this.waterPressures,
      this.recentAlarmEventRecord});

  WorkSupportData.fromJson(Map<String, dynamic> json) {
    freezeTime = json['FreezeTime'];
    gateOpening = json['GateOpening'];
    gateOpenings = json['GateOpenings'].cast<double>();
    relativeMaxWaterStage = json['RelativeMaxWaterStage'];
    waterStageAlarmValue = json['WaterStageAlarmValue'];
    waterStage = json['WaterStage'];
    altitudeWaterStage = json['AltitudeWaterStage'];
    coolingWaterStage = json['CoolingWaterStage'];
    rPM = json['RPM'];
    excitationCurrentA = json['ExcitationCurrentA'];
    gateHLimit = json['GateHLimit'];
    gateLLimit = json['GateLLimit'];
    if (json['Temperatures'] != null) {
      temperatures = List<Temperatures>();
      json['Temperatures'].forEach((v) {
        temperatures.add(Temperatures.fromJson(v));
      });
    }
    waterPressures = json['WaterPressures'];
    if (json['RecentAlarmEventRecord'] != null) {
      recentAlarmEventRecord = List<RecentAlarmEventRecord>();
      json['RecentAlarmEventRecord'].forEach((v) {
        recentAlarmEventRecord.add(RecentAlarmEventRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['FreezeTime'] = this.freezeTime;
    data['GateOpening'] = this.gateOpening;
    data['GateOpenings'] = this.gateOpenings;
    data['RelativeMaxWaterStage'] = this.relativeMaxWaterStage;
    data['WaterStageAlarmValue'] = this.waterStageAlarmValue;
    data['WaterStage'] = this.waterStage;
    data['AltitudeWaterStage'] = this.altitudeWaterStage;
    data['CoolingWaterStage'] = this.coolingWaterStage;
    data['RPM'] = this.rPM;
    data['ExcitationCurrentA'] = this.excitationCurrentA;
    data['GateHLimit'] = this.gateHLimit;
    data['GateLLimit'] = this.gateLLimit;
    if (this.temperatures != null) {
      data['Temperatures'] = this.temperatures.map((v) => v.toJson()).toList();
    }
    data['WaterPressures'] = this.waterPressures;
    if (this.recentAlarmEventRecord != null) {
      data['RecentAlarmEventRecord'] =
          this.recentAlarmEventRecord.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Temperatures {
  String mItem1;
  String mItem2;
  bool mItem3;

  Temperatures({this.mItem1, this.mItem2, this.mItem3});

  Temperatures.fromJson(Map<String, dynamic> json) {
    mItem1 = json['m_Item1'];
    mItem2 = json['m_Item2'];
    mItem3 = json['m_Item3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['m_Item1'] = this.mItem1;
    data['m_Item2'] = this.mItem2;
    data['m_Item3'] = this.mItem3;
    return data;
  }
}

class RecentAlarmEventRecord {
  int iD;
  String terminalAddress;
  String freezeTime;
  int eRCFlag;
  bool needToEnsure;
  String ensureUserRealName;
  String eRCTitle;
  int version;

  RecentAlarmEventRecord(
      {this.iD,
      this.terminalAddress,
      this.freezeTime,
      this.eRCFlag,
      this.needToEnsure,
      this.ensureUserRealName,
      this.eRCTitle,
      this.version});

  RecentAlarmEventRecord.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    terminalAddress = json['TerminalAddress'];
    freezeTime = json['FreezeTime'];
    eRCFlag = json['ERCFlag'];
    needToEnsure = json['NeedToEnsure'];
    ensureUserRealName = json['EnsureUserRealName'];
    eRCTitle = json['ERCTitle'];
    version = json['Version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.iD;
    data['TerminalAddress'] = this.terminalAddress;
    data['FreezeTime'] = this.freezeTime;
    data['ERCFlag'] = this.eRCFlag;
    data['NeedToEnsure'] = this.needToEnsure;
    data['EnsureUserRealName'] = this.ensureUserRealName;
    data['ERCTitle'] = this.eRCTitle;
    data['Version'] = this.version;
    return data;
  }
}

class TerminalInfo {
  String customerNo;
  String stationNo;
  String terminalAddress;
  bool isConnected;
  bool isNetworkLink;
  bool isRemoteControl;
  String lastSwitchNetTime;
  bool disabled;
  List<int> periodicElectricityPrices;
  List<int> dayGeneratedEnergys;
  List<int> monthGeneratedEnergys;
  List<int> accumulatedGeneratedEnergys;
  bool circuitBreakerClosing;
  String workModel;
  String controlModel;
  String intelligentControlScheme;
  int waterTurbineEquippedCapacitor;
  int waterTurbineRatedActivePower;
  int waterTurbineRatedRPM;
  int waterTurbineRatedA;
  int waterTurbineRatedV;
  int waterTurbineExcitationCurrentA;
  String waterTurbineAliasName;
  Null waterTurbineGovernorPressure;
  String waterTurbineStartStopState;
  String terminalType;

  TerminalInfo(
      {this.customerNo,
      this.stationNo,
      this.terminalAddress,
      this.isConnected,
      this.isNetworkLink,
      this.isRemoteControl,
      this.lastSwitchNetTime,
      this.disabled,
      this.periodicElectricityPrices,
      this.dayGeneratedEnergys,
      this.monthGeneratedEnergys,
      this.accumulatedGeneratedEnergys,
      this.circuitBreakerClosing,
      this.workModel,
      this.controlModel,
      this.intelligentControlScheme,
      this.waterTurbineEquippedCapacitor,
      this.waterTurbineRatedActivePower,
      this.waterTurbineRatedRPM,
      this.waterTurbineRatedA,
      this.waterTurbineRatedV,
      this.waterTurbineExcitationCurrentA,
      this.waterTurbineAliasName,
      this.waterTurbineGovernorPressure,
      this.waterTurbineStartStopState,
      this.terminalType});

  TerminalInfo.fromJson(Map<String, dynamic> json) {
    customerNo = json['CustomerNo'];
    stationNo = json['StationNo'];
    terminalAddress = json['TerminalAddress'];
    isConnected = json['IsConnected'];
    isNetworkLink = json['IsNetworkLink'];
    isRemoteControl = json['IsRemoteControl'];
    lastSwitchNetTime = json['LastSwitchNetTime'];
    disabled = json['Disabled'];
    periodicElectricityPrices = json['PeriodicElectricityPrices'].cast<int>();
    dayGeneratedEnergys = json['DayGeneratedEnergys'].cast<int>();
    monthGeneratedEnergys = json['MonthGeneratedEnergys'].cast<int>();
    accumulatedGeneratedEnergys =
        json['AccumulatedGeneratedEnergys'].cast<int>();
    circuitBreakerClosing = json['CircuitBreakerClosing'];
    workModel = json['WorkModel'];
    controlModel = json['ControlModel'];
    intelligentControlScheme = json['IntelligentControlScheme'];
    waterTurbineEquippedCapacitor = json['WaterTurbineEquippedCapacitor'];
    waterTurbineRatedActivePower = json['WaterTurbineRatedActivePower'];
    waterTurbineRatedRPM = json['WaterTurbineRatedRPM'];
    waterTurbineRatedA = json['WaterTurbineRatedA'];
    waterTurbineRatedV = json['WaterTurbineRatedV'];
    waterTurbineExcitationCurrentA = json['WaterTurbineExcitationCurrentA'];
    waterTurbineAliasName = json['WaterTurbineAliasName'];
    waterTurbineGovernorPressure = json['WaterTurbineGovernorPressure'];
    waterTurbineStartStopState = json['WaterTurbineStartStopState'];
    terminalType = json['TerminalType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CustomerNo'] = this.customerNo;
    data['StationNo'] = this.stationNo;
    data['TerminalAddress'] = this.terminalAddress;
    data['IsConnected'] = this.isConnected;
    data['IsNetworkLink'] = this.isNetworkLink;
    data['IsRemoteControl'] = this.isRemoteControl;
    data['LastSwitchNetTime'] = this.lastSwitchNetTime;
    data['Disabled'] = this.disabled;
    data['PeriodicElectricityPrices'] = this.periodicElectricityPrices;
    data['DayGeneratedEnergys'] = this.dayGeneratedEnergys;
    data['MonthGeneratedEnergys'] = this.monthGeneratedEnergys;
    data['AccumulatedGeneratedEnergys'] = this.accumulatedGeneratedEnergys;
    data['CircuitBreakerClosing'] = this.circuitBreakerClosing;
    data['WorkModel'] = this.workModel;
    data['ControlModel'] = this.controlModel;
    data['IntelligentControlScheme'] = this.intelligentControlScheme;
    data['WaterTurbineEquippedCapacitor'] = this.waterTurbineEquippedCapacitor;
    data['WaterTurbineRatedActivePower'] = this.waterTurbineRatedActivePower;
    data['WaterTurbineRatedRPM'] = this.waterTurbineRatedRPM;
    data['WaterTurbineRatedA'] = this.waterTurbineRatedA;
    data['WaterTurbineRatedV'] = this.waterTurbineRatedV;
    data['WaterTurbineExcitationCurrentA'] =
        this.waterTurbineExcitationCurrentA;
    data['WaterTurbineAliasName'] = this.waterTurbineAliasName;
    data['WaterTurbineGovernorPressure'] = this.waterTurbineGovernorPressure;
    data['WaterTurbineStartStopState'] = this.waterTurbineStartStopState;
    data['TerminalType'] = this.terminalType;
    return data;
  }
}