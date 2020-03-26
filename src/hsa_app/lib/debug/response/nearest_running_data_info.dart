import 'package:hsa_app/debug/model/nearest_running_data.dart';

class NearestRunningDataResp {
  int code;
  int httpCode;
  NearestRunningData data;

  NearestRunningDataResp({this.code, this.httpCode, this.data});

  NearestRunningDataResp.fromJson(Map<String, dynamic> json,String terminalAddress) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? NearestRunningData.fromJson(json['data'],terminalAddress) : null;
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
