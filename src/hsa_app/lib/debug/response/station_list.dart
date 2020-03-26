import 'package:hsa_app/debug/model/data.dart';

class StationListResp {
  int code;
  int httpCode;
  Data data;

  StationListResp({this.code, this.httpCode, this.data});

  StationListResp.fromJson(Map<String, dynamic> json) {
    String str = 'station';
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? new Data.fromJson(json['data'],str) : null;
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





