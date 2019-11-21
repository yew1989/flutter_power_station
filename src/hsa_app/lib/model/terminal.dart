class Terminal {
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
  String waterTurbineGovernorPressure;
  String waterTurbineStartStopState;
  String terminalType;

  Terminal(
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

  Terminal.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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