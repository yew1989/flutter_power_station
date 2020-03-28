import 'package:hsa_app/debug/model/all_model.dart';

class BannerResp {
  int code;
  int httpCode;
  Data data;

  BannerResp({this.code, this.httpCode, this.data});

  BannerResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? new Data.fromJson(json['data'],'banner') : null;
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