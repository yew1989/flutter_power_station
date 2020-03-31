// 远程代理命令返回数据体
class AgentReplyUnitResp {

  String terminalAddress;
  String cmdId;
  String currentState;
  int replyAFN;
  List<ReplyDataUnitList> replyDataUnitList;

  AgentReplyUnitResp(
      {
      this.terminalAddress,
      this.cmdId,
      this.currentState,
      this.replyAFN,
      this.replyDataUnitList});

  AgentReplyUnitResp.fromJson(Map<String, dynamic> json) {

    terminalAddress = json['terminalAddress'] ?? '' ;
    cmdId = json['cmdId'] ?? '' ;
    currentState = json['currentState'] ?? '' ;
    replyAFN = json['replyAFN'] ?? 0 ;
    if (json['replyDataUnitList'] != null) {
      replyDataUnitList = List<ReplyDataUnitList>();
      json['replyDataUnitList'].forEach((v) {
        replyDataUnitList.add(ReplyDataUnitList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['terminalAddress'] = this.terminalAddress ?? '' ;
    data['cmdId'] = this.cmdId ?? '' ;
    data['currentState'] = this.currentState ?? '' ;
    data['replyAFN'] = this.replyAFN ?? 0;
    if (this.replyDataUnitList != null) {
      data['replyDataUnitList'] =
          this.replyDataUnitList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReplyDataUnitList {
  int fn;
  int pn;
  AgentDataUnit dataUnit;

  ReplyDataUnitList({this.fn, this.pn, this.dataUnit});

  ReplyDataUnitList.fromJson(Map<String, dynamic> json) {
    fn = json['fn'] ?? 0;
    pn = json['pn'] ?? 0;
    dataUnit = json['dataUnit'] != null
        ? AgentDataUnit.fromJson(json['dataUnit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fn'] = this.fn ?? 0;
    data['pn'] = this.pn ?? 0;
    if (this.dataUnit != null) {
      data['dataUnit'] = this.dataUnit.toJson();
    }
    return data;
  }
}

class AgentDataUnit {
  String dataCachedTime;

  AgentDataUnit({this.dataCachedTime});

  AgentDataUnit.fromJson(Map<String, dynamic> json) {
    dataCachedTime = json['dataCachedTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dataCachedTime'] = this.dataCachedTime ?? '';
    return data;
  }
}