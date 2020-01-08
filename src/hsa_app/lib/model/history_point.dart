class HistoryPointResp {

  List<HistoryPoint> data;
  int equippedCapacitor;
  int ratedActivePower;
  int waterStageAlarmValue;
  int relativeMaxWaterStage;
  int altitudeWaterStage;

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
    equippedCapacitor = json['EquippedCapacitor'];
    ratedActivePower = json['RatedActivePower'];
    waterStageAlarmValue = json['WaterStageAlarmValue'];
    relativeMaxWaterStage = json['RelativeMaxWaterStage'];
    altitudeWaterStage = json['AltitudeWaterStage'];
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
  double tkW;
  double waterStage;

  HistoryPoint({this.freezeTime, this.terminalCount, this.tkW, this.waterStage});

  HistoryPoint.fromJson(Map<String, dynamic> json) {
    freezeTime = json['FreezeTime'];
    terminalCount = json['TerminalCount'];
    tkW = json['TkW'];
    waterStage = json['WaterStage'];
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