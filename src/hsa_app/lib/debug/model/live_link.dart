class LiveLink {
  String liveLinkId;  //在线设备序号
  String stationNo;  //电站编号
  String deviceType;  //设备类型代号
  String deviceVersion;  //设备类型（Base、Pro）
  String deviceName;  //设备名称
  String liveLinkName;  //在线名字
  String liveLinkUrl;  //在线地址url）
  String m3u8Url;
  String rtmpUrl;
  String ezopenUrl;

  LiveLink(
      {this.liveLinkId,
      this.stationNo,
      this.deviceType,
      this.deviceVersion,
      this.deviceName,
      this.liveLinkName,
      this.liveLinkUrl,
      this.m3u8Url,
      this.rtmpUrl,
      this.ezopenUrl});

  LiveLink.fromJson(Map<String, dynamic> json) {
    liveLinkId = json['liveLinkId'];
    stationNo = json['stationNo'];
    deviceType = json['deviceType'];
    deviceVersion = json['deviceVersion'];
    deviceName = json['deviceName'];
    liveLinkName = json['liveLinkName'];
    liveLinkUrl = json['liveLinkUrl'];
    m3u8Url = json['m3u8Url'];
    rtmpUrl = json['rtmpUrl'];
    ezopenUrl = json['ezopenUrl'];
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
    data['m3u8Url'] = this.m3u8Url;
    data['rtmpUrl'] = this.rtmpUrl;
    data['ezopenUrl'] = this.ezopenUrl;
    return data;
  }
}