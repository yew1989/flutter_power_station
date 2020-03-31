class HistoryPointResp {

  List<HistoryPoint> data;
  num equippedCapacitor;
  num ratedActivePower;
  num waterStageAlarmValue;
  num relativeMaxWaterStage;
  num altitudeWaterStage;

  HistoryPointResp(
      {this.data,
      this.equippedCapacitor,
      this.ratedActivePower,
      this.waterStageAlarmValue,
      this.relativeMaxWaterStage,
      this.altitudeWaterStage});

  HistoryPointResp.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<HistoryPoint>();
      json['data'].forEach((v) {
        data.add(HistoryPoint.fromJson(v));
      });
    }
    equippedCapacitor = json['EquippedCapacitor'] ?? 0.0;
    ratedActivePower = json['RatedActivePower'] ?? 0.0;
    waterStageAlarmValue = json['WaterStageAlarmValue'] ?? 0.0;
    relativeMaxWaterStage = json['RelativeMaxWaterStage'] ?? 0.0;
    altitudeWaterStage = json['AltitudeWaterStage'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['EquippedCapacitor'] = this.equippedCapacitor;
    data['RatedActivePower'] = this.ratedActivePower;
    data['WaterStageAlarmValue'] = this.waterStageAlarmValue;
    data['RelativeMaxWaterStage'] = this.relativeMaxWaterStage;
    data['AltitudeWaterStage'] = this.altitudeWaterStage;
    return data;
  }
}

class HistoryPoint {
  String freezeTime;
  int terminalCount;
  num tkW;
  num waterStage;
  num tkWMax;
  num waterStageMax;

  HistoryPoint({this.freezeTime, this.terminalCount, this.tkW, this.waterStage});

  HistoryPoint.fromJson(Map<String, dynamic> json) {
    freezeTime = json['FreezeTime'];
    terminalCount = json['TerminalCount'] ?? 0;
    tkW = json['TkW'] ?? 0.0;
    waterStage = json['WaterStage'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['FreezeTime'] = this.freezeTime;
    data['TerminalCount'] = this.terminalCount;
    data['TkW'] = this.tkW;
    data['WaterStage'] = this.waterStage;
    return data;
  }
}