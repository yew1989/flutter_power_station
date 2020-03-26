import 'package:hsa_app/debug/model/area.dart';
import 'package:hsa_app/debug/model/device_terminal.dart';
import 'package:hsa_app/debug/model/live_link.dart';
import 'package:hsa_app/debug/model/water_turbines.dart';

class StationInfo {
  String stationNo; //电站号
  String stationName;  //电站名称
  AreaInfo areaInfo;  //地区
  List<LiveLink> liveLinks; 
  List<WaterTurbine> waterTurbines;  //水轮机
  List<DeviceTerminal> deviceTerminalsOfFMD;  //监测终端
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
  

  StationInfo(
      {this.stationNo,
      this.stationName,
      this.areaInfo,
      this.liveLinks,
      this.waterTurbines,
      this.deviceTerminalsOfFMD,
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
    address = json['address'];
    waterTurbineCount = json['waterTurbineCount'];
    undisposedAlarmEventCount = json['undisposedAlarmEventCount'];
    terminalOnLineCount = json['terminalOnLineCount'];
    hyStationLongtitude = json['hyStationLongtitude'];
    hyStationLatitude = json['hyStationLatitude'];
    waterSourceLongtitude = json['waterSourceLongtitude'];
    waterSourceLatitude = json['waterSourceLatitude'];
    totalEquippedKW = json['totalEquippedKW'].toDouble();
    totalEquippedKVA = json['totalEquippedKVA'].toDouble();
    stationNamePinYin = json['stationNamePinYin'];
    reservoirCurrentWaterStage = json['reservoirCurrentWaterStage'].toDouble();
    reservoirAlarmWaterStage = json['reservoirAlarmWaterStage'];
    reservoirBasicWaterStage = json['reservoirBasicWaterStage'];
    reservoirArea = json['reservoirArea'];
    coolingPondWaterStage = json['coolingPondWaterStage'];
    stagnantPoolWaterStage = json['stagnantPoolWaterStage'];
    tailraceWaterStage = json['tailraceWaterStage'];
    peakElectricityPrice = json['peakElectricityPrice'];
    spikeElectricityPrice = json['spikeElectricityPrice'];
    flatElectricityPrice = json['flatElectricityPrice'];
    valleyElectricityPrice = json['valleyElectricityPrice'];
    isCurrentAccountFavorite = json['isCurrentAccountFavorite'];
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
    return data;
  }


}