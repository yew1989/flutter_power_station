// 地址信息返回数据体
class AreaInfoResp {
  int code;
  int httpCode;
  List<AreaInfo> data;

  AreaInfoResp({this.code, this.httpCode, this.data});

  AreaInfoResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    httpCode = json['httpCode'];
    if (json['data'] != null) {
      data = List<AreaInfo>();
      json['data'].forEach((v) {
        data.add(AreaInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// 地理信息
class AreaInfo {
  String cityName;
  String areaName;
  String provinceName;

  AreaInfo({this.cityName, this.areaName, this.provinceName});

  AreaInfo.fromJson(Map<String, dynamic> json) {
    cityName = json['cityName'] ?? '';
    areaName = json['areaName'] ?? '';
    provinceName = json['provinceName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cityName'] = this.cityName ?? '';
    data['areaName'] = this.areaName ?? '';
    data['provinceName'] = this.provinceName ?? '';
    return data;
  }
}