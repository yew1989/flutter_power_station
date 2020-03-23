import 'package:hsa_app/debug/model/active_power.dart';

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