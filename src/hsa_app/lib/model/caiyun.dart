class CaiyuWeatherResponse {
  String status;
  CaiyuResult result;

  CaiyuWeatherResponse({this.status, this.result});

  CaiyuWeatherResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result =
        json['result'] != null ? CaiyuResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class CaiyuResult {
  String status;
  num temperature;
  num humidity;
  num cloudrate;
  String skycon;

  CaiyuResult(
      {this.status,
      this.temperature,
      this.humidity,
      this.cloudrate,
      this.skycon});

  CaiyuResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    temperature = json['temperature'] ?? 0.0;
    humidity = json['humidity']  ?? 0.0;
    cloudrate = json['cloudrate']  ?? 0.0;
    skycon = json['skycon'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['cloudrate'] = this.cloudrate;
    data['skycon'] = this.skycon;
    return data;
  }
}