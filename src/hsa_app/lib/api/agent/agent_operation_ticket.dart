// 操作票返回数据体
class AgentOperationTicketResp {
  int code;
  int httpCode;
  AgentOperationTicket data;

  AgentOperationTicketResp({this.code, this.httpCode, this.data});

  AgentOperationTicketResp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    httpCode = json['httpCode'] ?? 0;
    data = json['data'] != null ? AgentOperationTicket.fromJson(json['data']) : null;
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

// 操作票包装
class AgentOperationTicket {
  bool checkResult;
  String operationTicket;

  AgentOperationTicket({this.checkResult, this.operationTicket});

  AgentOperationTicket.fromJson(Map<String, dynamic> json) {
    checkResult = json['checkResult'] ?? false;
    operationTicket = json['operationTicket'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['checkResult'] = this.checkResult ?? false;
    data['operationTicket'] = this.operationTicket ?? '';
    return data;
  }
}