
class PasswordResp {
  int code;
  int httpCode;
  PasswordResp({this.code, this.httpCode});

  PasswordResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    return data;
  }
}

