// 终端告警事件列表
class TerminalAlarmEventList {
  int total;
  List<TerminalAlarmEvent> rows;

  TerminalAlarmEventList({this.total, this.rows});

  TerminalAlarmEventList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = List<TerminalAlarmEvent>();
      json['rows'].forEach((v) {
        rows.add(TerminalAlarmEvent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// 终端告警事件
class TerminalAlarmEvent {
  String id;
  String stationNo;
  String stationName;
  String terminalAddress;
  String deviceTerminalType;
  String deviceTerminalHardware;
  int ercVersion;
  int eventHandler;
  String eventTime;
  bool isFatal;
  int eventFlag;
  bool eventOccurOrRecoverSignal;
  String eventTitle;
  bool needToEnsure;
  String ensureByAccountNickName;
  bool needToPushApp;
  bool needToPushSMS;
  bool needToPushWeixin;
  bool needToDialPhone;
  int undisposedAlarmEventCount;

  TerminalAlarmEvent(
      {this.id,
      this.stationNo,
      this.stationName,
      this.terminalAddress,
      this.deviceTerminalType,
      this.deviceTerminalHardware,
      this.ercVersion,
      this.eventHandler,
      this.eventTime,
      this.isFatal,
      this.eventFlag,
      this.eventOccurOrRecoverSignal,
      this.eventTitle,
      this.needToEnsure,
      this.ensureByAccountNickName,
      this.needToPushApp,
      this.needToPushSMS,
      this.needToPushWeixin,
      this.needToDialPhone,
      this.undisposedAlarmEventCount});

  TerminalAlarmEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationNo = json['stationNo'];
    stationName = json['stationName'];
    terminalAddress = json['terminalAddress'];
    deviceTerminalType = json['deviceTerminalType'];
    deviceTerminalHardware = json['deviceTerminalHardware'];
    ercVersion = json['ercVersion'];
    eventHandler = json['eventHandler'];
    eventTime = json['eventTime'];
    isFatal = json['isFatal'];
    eventFlag = json['eventFlag'];
    eventOccurOrRecoverSignal = json['eventOccurOrRecoverSignal'];
    eventTitle = json['eventTitle'];
    needToEnsure = json['needToEnsure'];
    ensureByAccountNickName = json['ensureByAccountNickName'];
    needToPushApp = json['needToPushApp'];
    needToPushSMS = json['needToPushSMS'];
    needToPushWeixin = json['needToPushWeixin'];
    needToDialPhone = json['needToDialPhone'];
    undisposedAlarmEventCount = json['undisposedAlarmEventCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['stationNo'] = this.stationNo;
    data['stationName'] = this.stationName;
    data['terminalAddress'] = this.terminalAddress;
    data['deviceTerminalType'] = this.deviceTerminalType;
    data['deviceTerminalHardware'] = this.deviceTerminalHardware;
    data['ercVersion'] = this.ercVersion;
    data['eventHandler'] = this.eventHandler;
    data['eventTime'] = this.eventTime;
    data['isFatal'] = this.isFatal;
    data['eventFlag'] = this.eventFlag;
    data['eventOccurOrRecoverSignal'] = this.eventOccurOrRecoverSignal;
    data['eventTitle'] = this.eventTitle;
    data['needToEnsure'] = this.needToEnsure;
    data['ensureByAccountNickName'] = this.ensureByAccountNickName;
    data['needToPushApp'] = this.needToPushApp;
    data['needToPushSMS'] = this.needToPushSMS;
    data['needToPushWeixin'] = this.needToPushWeixin;
    data['needToDialPhone'] = this.needToDialPhone;
    data['undisposedAlarmEventCount'] = this.undisposedAlarmEventCount;
    return data;
  }
}