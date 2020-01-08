class HistoryEvent {
  int id;
  String terminalAddress;
  String freezeTime;
  int eRCFlag;
  bool needToEnsure;
  String ensureUserRealName;
  String eRCTitle;
  int version;

  HistoryEvent(
      {this.id,
      this.terminalAddress,
      this.freezeTime,
      this.eRCFlag,
      this.needToEnsure,
      this.ensureUserRealName,
      this.eRCTitle,
      this.version});

  HistoryEvent.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    terminalAddress = json['TerminalAddress'];
    freezeTime = json['FreezeTime'];
    eRCFlag = json['ERCFlag'];
    needToEnsure = json['NeedToEnsure'];
    ensureUserRealName = json['EnsureUserRealName'];
    eRCTitle = json['ERCTitle'];
    version = json['Version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.id;
    data['TerminalAddress'] = this.terminalAddress;
    data['FreezeTime'] = this.freezeTime;
    data['ERCFlag'] = this.eRCFlag;
    data['NeedToEnsure'] = this.needToEnsure;
    data['EnsureUserRealName'] = this.ensureUserRealName;
    data['ERCTitle'] = this.eRCTitle;
    data['Version'] = this.version;
    return data;
  }
}