
import 'package:hsa_app/debug/model/account.dart';

class AccountInfoResp {
  int code;
  int httpCode;
  AccountInfo data;
  AccountInfoResp({this.code, this.httpCode, this.data});

  AccountInfoResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? AccountInfo.fromJson(json['data']) : null;
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

