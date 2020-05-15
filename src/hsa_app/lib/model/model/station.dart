import 'package:hsa_app/model/model/area.dart';
import 'package:hsa_app/model/model/device_terminal.dart';
import 'package:hsa_app/model/model/live_link.dart';
import 'package:hsa_app/model/model/water_turbines.dart';

class StationInfo {
  String stationNo; //电站号
  String stationName;  //电站名称
  AreaInfo areaInfo;  //地区
  List<LiveLink> liveLinks; 
  List<WaterTurbine> waterTurbines;  //水轮机
  List<DeviceTerminal> deviceTerminalsOfFMD;  //监测终端
  List<DeviceTerminal> deviceTerminalsOfOther;
  String address;
  int waterTurbineCount;
  int undisposedAlarmEventCount;
  int terminalOnLineCount;
  double hyStationLongtitude;
  double hyStationLatitude;
  double waterSourceLongtitude;
  double waterSourceLatitude;
  double totalEquippedKW;
  double totalEquippedKVA;
  String stationNamePinYin;
  double reservoirCurrentWaterStage;
  double reservoirAlarmWaterStage;
  double reservoirBasicWaterStage;
  double reservoirArea;
  double coolingPondWaterStage;
  double stagnantPoolWaterStage;
  double tailraceWaterStage;
  double peakElectricityPrice;
  double spikeElectricityPrice;
  double flatElectricityPrice;
  double valleyElectricityPrice;
  bool isCurrentAccountFavorite;

  double totalActivePower;   // 总有功
  double totalMoney;        // 总收益

  // 是否是力得样板电站 - 通过后台配置
  bool fjLeadBrandCertified;
  // 是否允许快速远程召测
  bool isAllowHighSpeedNetworkSwitching;

  StationInfo(
      {this.stationNo,
      this.stationName,
      this.areaInfo,
      this.liveLinks,
      this.waterTurbines,
      this.deviceTerminalsOfFMD,
      this.deviceTerminalsOfOther,
      this.address,
      this.waterTurbineCount,
      this.undisposedAlarmEventCount,
      this.terminalOnLineCount,
      this.hyStationLongtitude,
      this.hyStationLatitude,
      this.waterSourceLongtitude,
      this.waterSourceLatitude,
      this.totalEquippedKW,
      this.totalEquippedKVA,
      this.stationNamePinYin,
      this.reservoirCurrentWaterStage,
      this.reservoirAlarmWaterStage,
      this.reservoirBasicWaterStage,
      this.reservoirArea,
      this.coolingPondWaterStage,
      this.stagnantPoolWaterStage,
      this.tailraceWaterStage,
      this.peakElectricityPrice,
      this.spikeElectricityPrice,
      this.flatElectricityPrice,
      this.valleyElectricityPrice,
      this.isCurrentAccountFavorite,
      this.totalActivePower,
      this.totalMoney,
      this.fjLeadBrandCertified,
      this.isAllowHighSpeedNetworkSwitching,
      });

  StationInfo.fromJson(Map<String, dynamic> json) {
    stationNo = json['stationNo'];
    stationName = json['stationName'];
    areaInfo = json['city'] != null ? new AreaInfo.fromJson(json['city']) : null;
    if (json['liveLinks'] != null) {
      liveLinks = new List<LiveLink>();
      json['liveLinks'].forEach((v) {
        liveLinks.add(new LiveLink.fromJson(v));
      });
    }
    if (json['waterTurbines'] != null) {
      waterTurbines = new List<WaterTurbine>();
      json['waterTurbines'].forEach((v) {
        waterTurbines.add(new WaterTurbine.fromJson(v));
      });
    }
    if (json['deviceTerminalsOfFMD'] != null) {
      deviceTerminalsOfFMD = new List<DeviceTerminal>();
      json['deviceTerminalsOfFMD'].forEach((v) {
        deviceTerminalsOfFMD.add(new DeviceTerminal.fromJson(v));
      });
    }
    if (json['deviceTerminalsOfOther'] != null) {
      deviceTerminalsOfOther = new List<DeviceTerminal>();
      json['deviceTerminalsOfOther'].forEach((v) {
        deviceTerminalsOfOther.add(new DeviceTerminal.fromJson(v));
      });
    }
    address = json['address'];
    waterTurbineCount = json['waterTurbineCount'];
    undisposedAlarmEventCount = json['undisposedAlarmEventCount'];
    terminalOnLineCount = json['terminalOnLineCount'];
    hyStationLongtitude = json['hyStationLongtitude'];
    hyStationLatitude = json['hyStationLatitude'];
    waterSourceLongtitude = json['waterSourceLongtitude'];
    waterSourceLatitude = json['waterSourceLatitude'];
    totalEquippedKW = json['totalEquippedKW'] is double ? json['totalEquippedKW'] : json['totalEquippedKW'] != null ? json['totalEquippedKW'].toDouble() : 0.0 ;
    totalEquippedKVA = json['totalEquippedKVA'] is double ? json['totalEquippedKVA'] : json['totalEquippedKVA'] != null ? json['totalEquippedKVA'].toDouble() : 0.0 ;
    stationNamePinYin = json['stationNamePinYin'];
    reservoirCurrentWaterStage = json['reservoirCurrentWaterStage'] is double ? json['reservoirCurrentWaterStage'] : json['reservoirCurrentWaterStage'] != null ? json['reservoirCurrentWaterStage'].toDouble() : 0.0 ;
    reservoirAlarmWaterStage = json['reservoirAlarmWaterStage'];
    reservoirBasicWaterStage = json['reservoirBasicWaterStage'];
    reservoirArea = json['reservoirArea'];
    coolingPondWaterStage = json['coolingPondWaterStage'] ?? 0.0;
    stagnantPoolWaterStage = json['stagnantPoolWaterStage'] ?? 0.0;
    tailraceWaterStage = json['tailraceWaterStage'] ?? 0.0;
    peakElectricityPrice = json['peakElectricityPrice'] ?? 0.0;
    spikeElectricityPrice = json['spikeElectricityPrice'] ?? 0.0;
    flatElectricityPrice = json['flatElectricityPrice'] ?? 0.0;
    valleyElectricityPrice = json['valleyElectricityPrice'] ?? 0.0;
    isCurrentAccountFavorite = json['isCurrentAccountFavorite'] ?? false;
    totalActivePower = json['totalActivePower'] ?? 0.0;
    totalMoney = json['totoalMoney']  ?? 0.0;
    fjLeadBrandCertified = json['fjLeadBrandCertified'] ?? false;
    isAllowHighSpeedNetworkSwitching = json['isAllowHighSpeedNetworkSwitching']  ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stationNo'] = this.stationNo;
    data['stationName'] = this.stationName;
    if (this.areaInfo != null) {
      data['city'] = this.areaInfo.toJson();
    }
    if (this.liveLinks != null) {
      data['liveLinks'] = this.liveLinks.map((v) => v.toJson()).toList();
    }
    if (this.waterTurbines != null) {
      data['waterTurbines'] =
          this.waterTurbines.map((v) => v.toJson()).toList();
    }
    if (this.deviceTerminalsOfFMD != null) {
      data['deviceTerminalsOfFMD'] =
          this.deviceTerminalsOfFMD.map((v) => v.toJson()).toList();
    }
    if (this.deviceTerminalsOfOther != null) {
      data['deviceTerminalsOfOther'] =
          this.deviceTerminalsOfOther.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['waterTurbineCount'] = this.waterTurbineCount;
    data['undisposedAlarmEventCount'] = this.undisposedAlarmEventCount;
    data['terminalOnLineCount'] = this.terminalOnLineCount;
    data['hyStationLongtitude'] = this.hyStationLongtitude;
    data['hyStationLatitude'] = this.hyStationLatitude;
    data['waterSourceLongtitude'] = this.waterSourceLongtitude;
    data['waterSourceLatitude'] = this.waterSourceLatitude;
    data['totalEquippedKW'] = this.totalEquippedKW;
    data['totalEquippedKVA'] = this.totalEquippedKVA;
    data['stationNamePinYin'] = this.stationNamePinYin;
    data['reservoirCurrentWaterStage'] = this.reservoirCurrentWaterStage;
    data['reservoirAlarmWaterStage'] = this.reservoirAlarmWaterStage;
    data['reservoirBasicWaterStage'] = this.reservoirBasicWaterStage;
    data['reservoirArea'] = this.reservoirArea;
    data['coolingPondWaterStage'] = this.coolingPondWaterStage;
    data['stagnantPoolWaterStage'] = this.stagnantPoolWaterStage;
    data['tailraceWaterStage'] = this.tailraceWaterStage;
    data['peakElectricityPrice'] = this.peakElectricityPrice;
    data['spikeElectricityPrice'] = this.spikeElectricityPrice;
    data['flatElectricityPrice'] = this.flatElectricityPrice;
    data['valleyElectricityPrice'] = this.valleyElectricityPrice;
    data['isCurrentAccountFavorite'] = this.isCurrentAccountFavorite;
    data['totalActivePower'] = this.totalActivePower;
    data['totalMoney'] = this.totalMoney;
    data['fjLeadBrandCertified'] = this.fjLeadBrandCertified;
    data['isAllowHighSpeedNetworkSwitching'] = this.isAllowHighSpeedNetworkSwitching;
    return data;
  }


}