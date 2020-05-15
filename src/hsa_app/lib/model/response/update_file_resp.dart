

import 'package:hsa_app/model/model/all_model.dart';

class UpdateFileResp {
  int code;
  int httpCode;
  List<UpdateFile> data;
  UpdateFileResp({this.code, this.httpCode, this.data});

  UpdateFileResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
     if (json['data'] != null) {
      data = List<UpdateFile>();
      json['data'].forEach((v) {
         data.add(UpdateFile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v).toList();
    }
    return data;
  }
}

