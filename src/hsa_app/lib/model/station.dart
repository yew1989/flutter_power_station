class StationSection {
  String sectionName;
  List<Station> stations;
}

class Station {
  // 水电平台数据
  String terminalAddress;
  bool isConnected;
  bool disabled;
  bool isNetworkLink;
  String hardwareVersion;
  int terminalWorkModel;
  String terminalType;
  String waterTurbineAliasName;
  int waterTurbineEquippedCapacitor;
  int waterTurbineGateOpeningDeviceCount;
  int waterTurbineControllerCabinetType;
  String customerName;
  String customerCodeID;
  String stationName;
  String stationNamePinYin;
  int hydropowerStationID;
  String hydropowerStationCodeID;
  String stationOwnerName;
  String cityName;
  String areaName;
  String provinceName;

  // 收藏记录
  bool isCollected;

  Station(
      {this.terminalAddress,
      this.isConnected,
      this.disabled,
      this.isNetworkLink,
      this.hardwareVersion,
      this.terminalWorkModel,
      this.terminalType,
      this.waterTurbineAliasName,
      this.waterTurbineEquippedCapacitor,
      this.waterTurbineGateOpeningDeviceCount,
      this.waterTurbineControllerCabinetType,
      this.customerName,
      this.customerCodeID,
      this.stationName,
      this.stationNamePinYin,
      this.hydropowerStationID,
      this.hydropowerStationCodeID,
      this.stationOwnerName,
      this.cityName,
      this.areaName,
      this.provinceName,
      this.isCollected,
      });

  Station.fromJson(Map<String, dynamic> json) {
    terminalAddress = json['TerminalAddress'] ?? '';
    isConnected = json['IsConnected'] ?? false;
    disabled = json['Disabled'] ?? false;
    isNetworkLink = json['IsNetworkLink'] ?? false;
    hardwareVersion = json['HardwareVersion'] ?? '';
    terminalWorkModel = json['TerminalWorkModel'] ?? 0;
    terminalType = json['TerminalType'] ?? '';
    waterTurbineAliasName = json['WaterTurbineAliasName'] ?? '';
    waterTurbineEquippedCapacitor = json['WaterTurbineEquippedCapacitor'] ?? 0;
    waterTurbineGateOpeningDeviceCount =
        json['WaterTurbineGateOpeningDeviceCount'] ?? 0;
    waterTurbineControllerCabinetType =
        json['WaterTurbineControllerCabinetType'] ?? 0;
    customerName = json['CustomerName'] ?? '';
    customerCodeID = json['CustomerCodeID'] ?? '';
    stationName = json['StationName'] ?? '';
    stationNamePinYin = json['StationNamePinYin'] ??'';
    hydropowerStationID = json['HydropowerStationID'] ?? 0;
    hydropowerStationCodeID = json['HydropowerStationCodeID'] ?? '';
    stationOwnerName = json['StationOwnerName'] ??'';
    cityName = json['CityName'] ?? '';
    areaName = json['AreaName'] ?? '';
    provinceName = json['ProvinceName'] ?? '';
    isCollected = json['isCollected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TerminalAddress'] = this.terminalAddress;
    data['IsConnected'] = this.isConnected;
    data['Disabled'] = this.disabled;
    data['IsNetworkLink'] = this.isNetworkLink;
    data['HardwareVersion'] = this.hardwareVersion;
    data['TerminalWorkModel'] = this.terminalWorkModel;
    data['TerminalType'] = this.terminalType;
    data['WaterTurbineAliasName'] = this.waterTurbineAliasName;
    data['WaterTurbineEquippedCapacitor'] = this.waterTurbineEquippedCapacitor;
    data['WaterTurbineGateOpeningDeviceCount'] =
        this.waterTurbineGateOpeningDeviceCount;
    data['WaterTurbineControllerCabinetType'] =
        this.waterTurbineControllerCabinetType;
    data['CustomerName'] = this.customerName;
    data['CustomerCodeID'] = this.customerCodeID;
    data['StationName'] = this.stationName;
    data['StationNamePinYin'] = this.stationNamePinYin;
    data['HydropowerStationID'] = this.hydropowerStationID;
    data['HydropowerStationCodeID'] = this.hydropowerStationCodeID;
    data['StationOwnerName'] = this.stationOwnerName;
    data['CityName'] = this.cityName;
    data['AreaName'] = this.areaName;
    data['ProvinceName'] = this.provinceName;
    return data;
  }
}