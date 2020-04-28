import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/data.dart';

class StatisticalPowerResp {
  int code;
  int httpCode;
  Data data;
  
  StatisticalPowerResp({this.code, this.httpCode, this.data});

  StatisticalPowerResp.fromJson(Map<String, dynamic> json) {
    String str = 'statisticalPower';
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


class StatisticalPowerYearResp {
  int code;
  int httpCode;
  List<StatisticalPower> statisticalPowerList;
  
  StatisticalPowerYearResp({this.code, this.httpCode, this.statisticalPowerList});

  StatisticalPowerYearResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    if (json['data'] != null) {
      statisticalPowerList = List<StatisticalPower>();
      json['data'].forEach((v) {
        statisticalPowerList.add(StatisticalPower.fromJsonMonth(v));
      });
    }
  }
  
}