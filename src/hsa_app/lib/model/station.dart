class StationsResponse {
  
  int code;
  int http;
  String msg;
  StationData data;

  StationsResponse({this.code, this.http, this.msg, this.data});

  StationsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    http = json['http'];
    msg = json['msg'];
    data = json['data'] != null ? StationData.fromJson(json['data']) : null;
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

class StationData {
  int total;
  List<Stations> stations;

  StationData({this.total, this.stations});

  StationData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['stations'] != null) {
      stations = List<Stations>();
      json['stations'].forEach((v) {
        stations.add(Stations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    if (this.stations != null) {
      data['stations'] = this.stations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stations {
  int id;
  String name;
  String pinyin;
  StationItem power;
  StationItem water;
  String status;
  int eventCount;
  bool isFocus;

  Stations(
      {this.id,
      this.name,
      this.pinyin,
      this.power,
      this.water,
      this.status,
      this.eventCount,
      this.isFocus});

  Stations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pinyin = json['pinyin'];
    power = json['power'] != null ? StationItem.fromJson(json['power']) : null;
    water = json['water'] != null ? StationItem.fromJson(json['water']) : null;
    status = json['status'];
    eventCount = json['eventCount'];
    isFocus = json['isFocus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pinyin'] = this.pinyin;
    if (this.power != null) {
      data['power'] = this.power.toJson();
    }
    if (this.water != null) {
      data['water'] = this.water.toJson();
    }
    data['status'] = this.status;
    data['eventCount'] = this.eventCount;
    data['isFocus'] = this.isFocus;
    return data;
  }
}

class StationItem {
  int max;
  int current;

  StationItem({this.max, this.current});

  StationItem.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['max'] = this.max;
    data['current'] = this.current;
    return data;
  }
}