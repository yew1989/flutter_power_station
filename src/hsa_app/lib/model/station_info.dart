import 'package:hsa_app/model/station.dart';

class StationInfoResponse {
  int code;
  int http;
  String msg;
  StationInfoData data;

  StationInfoResponse({this.code, this.http, this.msg, this.data});

  StationInfoResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    http = json['http'];
    msg = json['msg'];
    data = json['data'] != null ? StationInfoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['http'] = this.http;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class StationInfoData {

  StationInfo station;

  StationInfoData({this.station});

  StationInfoData.fromJson(Map<String, dynamic> json) {
    station =
        json['station'] != null ? StationInfo.fromJson(json['station']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.station != null) {
      data['station'] = this.station.toJson();
    }
    return data;
  }
}

class StationInfo {

  int id;
  String name;
  String pinyin;
  num profit;
  Geo geo;
  StationItem reservoir;
  StationItem tailWater;
  Water water;
  List<String> openlive;
  StationItem power;
  List<Devices> devices;

  StationInfo(
      {this.id,
      this.name,
      this.pinyin,
      this.profit,
      this.geo,
      this.reservoir,
      this.tailWater,
      this.water,
      this.openlive,
      this.power,
      this.devices});

  StationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pinyin = json['pinyin'];
    profit = json['profit'] ?? 0.0;
    geo = json['geo'] != null ? Geo.fromJson(json['geo']) : null;
    reservoir = json['reservoir'] != null
        ? StationItem.fromJson(json['reservoir'])
        : null;
    tailWater = json['tailWater'] != null
        ? StationItem.fromJson(json['tailWater'])
        : null;
    water = json['water'] != null ? Water.fromJson(json['water']) : null;
    openlive = json['openlive'].cast<String>();
    power =
        json['power'] != null ? StationItem.fromJson(json['power']) : null;
    if (json['devices'] != null) {
      devices = List<Devices>();
      json['devices'].forEach((v) {
        devices.add(Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pinyin'] = this.pinyin;
    data['profit'] = this.profit;
    if (this.geo != null) {
      data['geo'] = this.geo.toJson();
    }
    if (this.reservoir != null) {
      data['reservoir'] = this.reservoir.toJson();
    }
    if (this.tailWater != null) {
      data['tailWater'] = this.tailWater.toJson();
    }
    if (this.water != null) {
      data['water'] = this.water.toJson();
    }
    data['openlive'] = this.openlive;
    if (this.power != null) {
      data['power'] = this.power.toJson();
    }
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Geo {
  num longitude;
  num latitude;

  Geo({this.longitude, this.latitude});

  Geo.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'] ?? 0.0;
    latitude = json['latitude'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}



class Water {
  num max;
  num current;
  num altitude;

  Water({this.max, this.current, this.altitude});

  Water.fromJson(Map<String, dynamic> json) {
    max = json['max'] ?? 0.0;
    current = json['current'] ?? 0.0;
    altitude = json['altitude'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['max'] = this.max;
    data['current'] = this.current;
    data['altitude'] = this.altitude;
    return data;
  }
}

class Devices {
  String address;
  String name;
  bool isMaster;
  StationItem power;
  String status;
  int eventCount;
  String updateTime;

  Devices(
      {this.address,
      this.name,
      this.isMaster,
      this.power,
      this.status,
      this.eventCount,
      this.updateTime});

  Devices.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
    isMaster = json['isMaster'];
    power =
        json['power'] != null ? StationItem.fromJson(json['power']) : null;
    status = json['status'];
    eventCount = json['eventCount'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    data['isMaster'] = this.isMaster;
    if (this.power != null) {
      data['power'] = this.power.toJson();
    }
    data['status'] = this.status;
    data['eventCount'] = this.eventCount;
    data['updateTime'] = this.updateTime;
    return data;
  }
}