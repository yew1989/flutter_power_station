import 'package:hsa_app/model/model/erc_flag_type.dart';

// ERCFlag类型返回响应数据体
class ERCFlagTypeResp {
  int code;
  int httpCode;
  List<ERCFlagType> data;

  ERCFlagTypeResp({this.code, this.httpCode, this.data});

  ERCFlagTypeResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    if (json['data'] != null) {
      data = List<ERCFlagType>();
      json['data'].forEach((v) {
        data.add(ERCFlagType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}