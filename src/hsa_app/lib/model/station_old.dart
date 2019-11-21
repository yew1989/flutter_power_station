
class StatinGroup {
  String secionName;
  List<StationOld> stations;
}

class StationOld {
  String customerName;
  String stationName;
  String customerNo;
  String stationNo;
  String stationCityID;
  String provinceName;
  String areaName;
  String cityName;

  StationOld(
      {this.customerName,
      this.stationName,
      this.customerNo,
      this.stationNo,
      this.stationCityID,
      this.provinceName,
      this.areaName,
      this.cityName});

  StationOld.fromJson(Map<String, dynamic> json) {
    customerName = json['CustomerName'] ?? '';
    stationName = json['StationName'] ?? '';
    customerNo = json['CustomerNo'] ?? '';
    stationNo = json['StationNo'] ?? '';
    stationCityID = json['StationCityID'] ?? '';
    provinceName = json['ProvinceName'] ?? '';
    areaName = json['AreaName'] ?? '';
    cityName = json['CityName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CustomerName'] = this.customerName;
    data['StationName'] = this.stationName;
    data['CustomerNo'] = this.customerNo;
    data['StationNo'] = this.stationNo;
    data['StationCityID'] = this.stationCityID;
    data['ProvinceName'] = this.provinceName;
    data['AreaName'] = this.areaName;
    data['CityName'] = this.cityName;
    return data;
  }
}