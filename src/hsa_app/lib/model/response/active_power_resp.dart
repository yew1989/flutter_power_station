import 'package:hsa_app/model/model/active_power.dart';

// 历史有功信息响应数据体
class ActivePowerResp {
  int code;
  int httpCode;
  ActivePowerList data;

  ActivePowerResp({this.code, this.httpCode, this.data});

  ActivePowerResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? ActivePowerList.fromJson(json['data']) : null;
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

// 历史有功数据列表
class ActivePowerList {
  int total;
  List<ActivePower> rows;

  ActivePowerList({this.total, this.rows});

  ActivePowerList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = List<ActivePower>();
      json['rows'].forEach((v) {
        rows.add(ActivePower.fromJson(v));
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