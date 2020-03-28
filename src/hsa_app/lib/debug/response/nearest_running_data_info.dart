import 'package:hsa_app/debug/model/nearest_running_data.dart';

class NearestRunningDataResp {

  bool isBase ;
  int code;
  int httpCode;
  NearestRunningData data;

  NearestRunningDataResp(this.isBase, {this.code, this.httpCode, this.data});

  NearestRunningDataResp.fromJson(Map<String, dynamic> json,String terminalAddress,this.isBase) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? NearestRunningData.fromJson(json['data'],terminalAddress,isBase:this.isBase) : null;
  }

}
