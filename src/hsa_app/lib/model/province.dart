class ProviceResponse {
  int code;
  int http;
  String msg;
  ProviceData data;

  ProviceResponse({this.code, this.http, this.msg, this.data});

  ProviceResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    http = json['http'];
    msg = json['msg'];
    data = json['data'] != null ? ProviceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['http'] = this.http;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ProviceData {
  List<String> province;

  ProviceData({this.province});

  ProviceData.fromJson(Map<String, dynamic> json) {
    province = json['province'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['province'] = this.province;
    return data;
  }
}