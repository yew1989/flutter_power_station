// 推送返回数据体
class PushBindResp {
  int code;
  int httpCode;
  PushBindRespOperation data;

  PushBindResp({this.code, this.httpCode, this.data});

  PushBindResp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    httpCode = json['httpCode'] ?? 0;
    data = json['data'] != null ? PushBindRespOperation.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code ?? 0;
    data['httpCode'] = this.httpCode ?? 0;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PushBindRespOperation {
  bool operationResult;

  PushBindRespOperation({this.operationResult});

  PushBindRespOperation.fromJson(Map<String, dynamic> json) {
    operationResult = json['operationResult'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['operationResult'] = this.operationResult ?? false;
    return data;
  }
}