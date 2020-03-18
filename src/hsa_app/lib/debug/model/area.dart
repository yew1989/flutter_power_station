// 地理信息
class AreaInfo {
  String areaId;
  String cityName;
  String areaName;
  String provinceName;

  AreaInfo({this.areaId, this.cityName, this.areaName, this.provinceName});

  AreaInfo.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'] ?? '';
    cityName = json['cityName'] ?? '';
    areaName = json['areaName'] ?? '';
    provinceName = json['provinceName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['areaId'] = this.cityName ?? '';
    data['cityName'] = this.cityName ?? '';
    data['areaName'] = this.areaName ?? '';
    data['provinceName'] = this.provinceName ?? '';
    return data;
  }
}