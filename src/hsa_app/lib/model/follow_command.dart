class FollowCommandResp {
  int afn;
  String address;
  String cmdId;
  int currentState;
  int replyAFN;
  List<ReplyDataUnit> replyDataUnitList;
  List<SendDataUnit> sendDataUnitList;

  FollowCommandResp({this.afn, this.address,this.cmdId,this.currentState,this.replyAFN,this.replyDataUnitList,this.sendDataUnitList});

  FollowCommandResp.fromJson(Map<String, dynamic> json) {

    afn = json['AFN'];
    address = json['Address'];
    cmdId = json['CmdId'];
    currentState = json['CurrentState'];
    replyAFN = json['replyAFN'];

    if (json['replyDataUnitList'] != null) {
      replyDataUnitList = List<ReplyDataUnit>();
      json['replyDataUnitList'].forEach((v) {
        replyDataUnitList.add(ReplyDataUnit.fromJson(v));
      });
    }

    if (json['sendDataUnitList'] != null) {
      sendDataUnitList = List<SendDataUnit>();
      json['sendDataUnitList'].forEach((v) {
        sendDataUnitList.add(SendDataUnit.fromJson(v));
      });
    }
  }
}

class ReplyDataUnit {
  int fn;
  int pn;

  ReplyDataUnit({this.fn,this.pn});

  ReplyDataUnit.fromJson(Map<String, dynamic> json) {
    fn = json['Fn'] ?? 0;
    pn = json['pn'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Fn'] = this.fn;
    data['pn'] = this.pn;
    return data;
  }

}

class SendDataUnit {
  int fn;
  int pn;
  SendDataUnit({this.fn,this.pn});

  SendDataUnit.fromJson(Map<String, dynamic> json) {
    fn = json['Fn'] ?? 0;
    pn = json['pn'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Fn'] = this.fn;
    data['pn'] = this.pn;
    return data;
  }
}