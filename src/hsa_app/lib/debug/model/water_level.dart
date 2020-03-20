// 历史水位曲线返回数据体
class WaterLevelResp {
  int code;
  int httpCode;
  WaterLevelList data;

  WaterLevelResp({this.code, this.httpCode, this.data});

  WaterLevelResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? WaterLevelList.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

// 历史水位列表
class WaterLevelList {
  int total;
  List<WaterLevel> rows;

  WaterLevelList({this.total, this.rows});

  WaterLevelList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = List<WaterLevel>();
      json['rows'].forEach((v) {
        rows.add(WaterLevel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// 历史水位数据项
class WaterLevel {
  String id;
  String stationNo;
  String terminalAddress;
  String deviceTerminalType;
  String deviceTerminalHardware;
  String freezeTime;
  String waterType;
  double measureLevel;
  double relativeLevel;
  int baseLevel;

  WaterLevel(
      {this.id,
      this.stationNo,
      this.terminalAddress,
      this.deviceTerminalType,
      this.deviceTerminalHardware,
      this.freezeTime,
      this.waterType,
      this.measureLevel,
      this.relativeLevel,
      this.baseLevel});

  WaterLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationNo = json['stationNo'];
    terminalAddress = json['terminalAddress'];
    deviceTerminalType = json['deviceTerminalType'];
    deviceTerminalHardware = json['deviceTerminalHardware'];
    freezeTime = json['freezeTime'];
    waterType = json['waterType'];
    measureLevel = json['measureLevel'];
    relativeLevel = json['relativeLevel'];
    baseLevel = json['baseLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['stationNo'] = this.stationNo;
    data['terminalAddress'] = this.terminalAddress;
    data['deviceTerminalType'] = this.deviceTerminalType;
    data['deviceTerminalHardware'] = this.deviceTerminalHardware;
    data['freezeTime'] = this.freezeTime;
    data['waterType'] = this.waterType;
    data['measureLevel'] = this.measureLevel;
    data['relativeLevel'] = this.relativeLevel;
    data['baseLevel'] = this.baseLevel;
    return data;
  }
}