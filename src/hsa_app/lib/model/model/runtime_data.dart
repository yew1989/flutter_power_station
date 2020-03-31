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
  num gV;
  num aV;
  num bV;
  num cV;
  num aA;
  num bA;
  num cA;
  num gVHz;
  num vHz;

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
    gV = json['GV'] ?? 0.0 ;
    aV = json['AV'] ?? 0.0 ;
    bV = json['BV'] ?? 0.0 ;
    cV = json['CV'] ?? 0.0 ;
    aA = json['AA'] ?? 0.0 ;
    bA = json['BA'] ?? 0.0 ;
    cA = json['CA'] ?? 0.0 ;
    gVHz = json['GVHz'] ?? 0.0 ;
    vHz = json['VHz'] ?? 0.0 ;
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
  num tPf;
  num tkvar;
  num tkW;
  num akW;
  num bkW;
  num ckW;
  num tkVA;
  num akvar;
  num bkvar;
  num ckvar;

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
    tPf = json['TPf'] ?? 0.0 ;
    tkvar = json['Tkvar'] ?? 0.0 ;
    tkW = json['TkW'] ?? 0.0 ;
    akW = json['AkW'] ?? 0.0 ;
    bkW = json['BkW'] ?? 0.0 ;
    ckW = json['CkW'] ?? 0.0 ;
    tkVA = json['TkVA'] ?? 0.0 ;
    akvar = json['Akvar'] ?? 0.0 ;
    bkvar = json['Bkvar'] ?? 0.0 ;
    ckvar = json['Ckvar'] ?? 0.0 ;
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
  num gateOpening;
  List<num> gateOpenings;
  num relativeMaxWaterStage;
  num waterStageAlarmValue;
  num waterStage;
  num altitudeWaterStage;
  num coolingWaterStage;
  num rPM;
  num excitationCurrentA;
  bool gateHLimit;
  bool gateLLimit;
  List<Temperatures> temperatures;
  List<num> waterPressures;
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
    gateOpening = json['GateOpening'] ?? 0.0;
    gateOpenings = json['GateOpenings'].cast<num>();
    relativeMaxWaterStage = json['RelativeMaxWaterStage'] ?? 0.0;
    waterStageAlarmValue = json['WaterStageAlarmValue'] ?? 0.0;
    waterStage = json['WaterStage'] ?? 0.0;
    altitudeWaterStage = json['AltitudeWaterStage'] ?? 0.0;
    coolingWaterStage = json['CoolingWaterStage'] ?? 0.0;
    rPM = json['RPM'] ?? 0.0;
    excitationCurrentA = json['ExcitationCurrentA'] ?? 0.0;
    gateHLimit = json['GateHLimit'] ?? false;
    gateLLimit = json['GateLLimit'] ?? false;
    if (json['Temperatures'] != null) {
      temperatures = List<Temperatures>();
      json['Temperatures'].forEach((v) {
        temperatures.add(Temperatures.fromJson(v));
      });
    }
    if(json['WaterPressures'] != null) {
      waterPressures = json['WaterPressures'].cast<num>();
    }
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
    data['WaterPressures'] = this.waterPressures;
    
    if (this.temperatures != null) {
      data['Temperatures'] = this.temperatures.map((v) => v.toJson()).toList();
    }

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
    mItem1 = json['m_Item1'] ?? '';
    mItem2 = json['m_Item2'] ?? '';
    mItem3 = json['m_Item3'] ?? false;
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
  List<num> periodicElectricityPrices;
  List<num> dayGeneratedEnergys;
  List<num> monthGeneratedEnergys;
  List<num> accumulatedGeneratedEnergys;
  bool circuitBreakerClosing;
  String workModel;
  String controlModel;
  String intelligentControlScheme;
  num waterTurbineEquippedCapacitor;
  num waterTurbineRatedActivePower;
  num waterTurbineRatedRPM;
  num waterTurbineRatedA;
  num waterTurbineRatedV;
  num waterTurbineExcitationCurrentA;
  String waterTurbineAliasName;
  num waterTurbineGovernorPressure;
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
    customerNo = json['CustomerNo'] ?? '';
    stationNo = json['StationNo'] ?? '';
    terminalAddress = json['TerminalAddress'] ??'';
    isConnected = json['IsConnected'] ?? false;
    isNetworkLink = json['IsNetworkLink'] ?? false;
    isRemoteControl = json['IsRemoteControl'] ?? false;
    lastSwitchNetTime = json['LastSwitchNetTime'] ?? '';
    disabled = json['Disabled'] ?? false;
    periodicElectricityPrices = json['PeriodicElectricityPrices'].cast<num>();
    dayGeneratedEnergys = json['DayGeneratedEnergys'].cast<num>();
    monthGeneratedEnergys = json['MonthGeneratedEnergys'].cast<num>();
    accumulatedGeneratedEnergys = json['AccumulatedGeneratedEnergys'].cast<num>();
    circuitBreakerClosing = json['CircuitBreakerClosing'] ?? false;
    workModel = json['WorkModel'] ?? '';
    controlModel = json['ControlModel'] ?? '';
    intelligentControlScheme = json['IntelligentControlScheme'] ?? '';
    waterTurbineEquippedCapacitor = json['WaterTurbineEquippedCapacitor'] ?? 0.0;
    waterTurbineRatedActivePower = json['WaterTurbineRatedActivePower'] ?? 0.0;
    waterTurbineRatedRPM = json['WaterTurbineRatedRPM'] ?? 0.0;
    waterTurbineRatedA = json['WaterTurbineRatedA'] ?? 0.0;
    waterTurbineRatedV = json['WaterTurbineRatedV'] ?? 0.0;
    waterTurbineExcitationCurrentA = json['WaterTurbineExcitationCurrentA'] ?? 0.0;
    waterTurbineAliasName = json['WaterTurbineAliasName'] ?? '';
    waterTurbineGovernorPressure = json['WaterTurbineGovernorPressure'] ?? 0.0;
    waterTurbineStartStopState = json['WaterTurbineStartStopState'] ?? '';
    terminalType = json['TerminalType'] ?? '';
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