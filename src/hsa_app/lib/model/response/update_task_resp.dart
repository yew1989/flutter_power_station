import 'package:hsa_app/model/model/data.dart';

class UpdateTaskResp {
  int code;
  int httpCode;
  Data data;

  UpdateTaskResp({this.code, this.httpCode, this.data});

  UpdateTaskResp.fromJson(Map<String, dynamic> json) {
    String str = 'updateTask';
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