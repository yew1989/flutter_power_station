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
  double baseLevel;

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
    waterType = json['水位类型'];
    measureLevel = json['测量水位'];
    relativeLevel = json['相对水位'];
    baseLevel = json['基础海拔'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['stationNo'] = this.stationNo;
    data['terminalAddress'] = this.terminalAddress;
    data['deviceTerminalType'] = this.deviceTerminalType;
    data['deviceTerminalHardware'] = this.deviceTerminalHardware;
    data['freezeTime'] = this.freezeTime;
    data['水位类型'] = this.waterType;
    data['测量水位'] = this.measureLevel;
    data['相对水位'] = this.relativeLevel;
    data['基础海拔'] = this.baseLevel;
    return data;
  }
}