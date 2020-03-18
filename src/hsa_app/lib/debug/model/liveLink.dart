class LiveLink {
  String liveLinkId;  //在线设备序号
  String stationNo;  //电站编号
  String deviceType;  //设备类型代号
  String deviceVersion;  //设备类型（Base、Pro）
  String deviceName;  //设备名称
  String liveLinkName;  //在线名字
  String liveLinkUrl;  //在线地址url）

  LiveLink(
      {this.liveLinkId,
      this.stationNo,
      this.deviceType,
      this.deviceVersion,
      this.deviceName,
      this.liveLinkName,
      this.liveLinkUrl});

  LiveLink.fromJson(Map<String, dynamic> json) {
    liveLinkId = json['liveLinkId'];
    stationNo = json['stationNo'];
    deviceType = json['deviceType'];
    deviceVersion = json['deviceVersion'];
    deviceName = json['deviceName'];
    liveLinkName = json['liveLinkName'];
    liveLinkUrl = json['liveLinkUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liveLinkId'] = this.liveLinkId;
    data['stationNo'] = this.stationNo;
    data['deviceType'] = this.deviceType;
    data['deviceVersion'] = this.deviceVersion;
    data['deviceName'] = this.deviceName;
    data['liveLinkName'] = this.liveLinkName;
    data['liveLinkUrl'] = this.liveLinkUrl;
    return data;
  }
}