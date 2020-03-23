import 'package:hsa_app/debug/model/water_level.dart';

// 历史水位曲线返回数据体
class WaterLevelResp {
  int code;
  int httpCode;
  WaterLevelList data;

  WaterLevelResp({this.code, this.httpCode, this.data});

  WaterLevelResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? WaterLevelList.fromJson(json['data']) : null;
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
