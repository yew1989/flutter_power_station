import 'package:hsa_app/model/model/data.dart';

class TurbineResp {
  int code;
  int httpCode;
  Data data;

  TurbineResp({this.code, this.httpCode, this.data});

  TurbineResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? new Data.fromJson(json['data'],'turbine') : null;
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
