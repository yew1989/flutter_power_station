import 'package:hsa_app/model/model/station.dart';

class StationInfoResp {
  int code;
  int httpCode;
  StationInfo data;

  StationInfoResp({this.code, this.httpCode, this.data});

  StationInfoResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? new StationInfo.fromJson(json['data']) : null;
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