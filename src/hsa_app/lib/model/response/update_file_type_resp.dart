

class UpdateFileTypeResp {
  int code;
  int httpCode;
  List<String> data;
  UpdateFileTypeResp({this.code, this.httpCode, this.data});

  UpdateFileTypeResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
     if (json['data'] != null) {
      data = List<String>();
      json['data'].forEach((v) {
        data.add(v);
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

