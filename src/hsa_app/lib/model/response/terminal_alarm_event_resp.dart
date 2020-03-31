import 'package:hsa_app/model/model/terminal_alarm_event.dart';

// 终端告警事件列表响应数据体
class TerminalAlarmEventResp {
  int code;
  int httpCode;
  TerminalAlarmEventList data;

  TerminalAlarmEventResp({this.code, this.httpCode, this.data});

  TerminalAlarmEventResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    data = json['data'] != null ? TerminalAlarmEventList.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}