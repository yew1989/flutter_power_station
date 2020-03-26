import 'package:hsa_app/debug/model/turbine.dart';

class TurbineResp {
  int code;
  int httpCode;
  Data data;

  TurbineResp({this.code, this.httpCode, this.data});

  TurbineResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int total;
  int reservoirAlarmWaterStage;
  int reservoirBasicWaterStage;
  List<Turbine> rows;

  Data(
      {this.total,
      this.reservoirAlarmWaterStage,
      this.reservoirBasicWaterStage,
      this.rows});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    reservoirAlarmWaterStage = json['reservoirAlarmWaterStage'];
    reservoirBasicWaterStage = json['reservoirBasicWaterStage'];
    if (json['rows'] != null) {
      rows = new List<Turbine>();
      json['rows'].forEach((v) {
        rows.add(new Turbine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['reservoirAlarmWaterStage'] = this.reservoirAlarmWaterStage;
    data['reservoirBasicWaterStage'] = this.reservoirBasicWaterStage;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}