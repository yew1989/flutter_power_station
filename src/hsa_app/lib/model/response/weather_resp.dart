import 'package:hsa_app/model/model/all_model.dart';

class WeatherResp {
  String status;
  String apiVersion;
  String apiStatus;
  String lang;
  String unit;
  int tzshift;
  String timezone;
  int serverTime;
  Result result;

  WeatherResp(
      {this.status,
      this.apiVersion,
      this.apiStatus,
      this.lang,
      this.unit,
      this.tzshift,
      this.timezone,
      this.serverTime,
      this.result});

  WeatherResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    apiVersion = json['api_version'];
    apiStatus = json['api_status'];
    lang = json['lang'];
    unit = json['unit'];
    tzshift = json['tzshift'];
    timezone = json['timezone'];
    serverTime = json['server_time'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['api_version'] = this.apiVersion;
    data['api_status'] = this.apiStatus;
    data['lang'] = this.lang;
    data['unit'] = this.unit;
    data['tzshift'] = this.tzshift;
    data['timezone'] = this.timezone;
    data['server_time'] = this.serverTime;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  Weather realtime;
  int primary;

  Result({this.realtime, this.primary});

  Result.fromJson(Map<String, dynamic> json) {
    realtime = json['realtime'] != null
        ? new Weather.fromJson(json['realtime'])
        : null;
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.realtime != null) {
      data['realtime'] = this.realtime.toJson();
    }
    data['primary'] = this.primary;
    return data;
  }
}