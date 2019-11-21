class Version {
  VersionInfo versionInfo;

  Version({this.versionInfo});

  Version.fromJson(Map<String, dynamic> json) {
    versionInfo = json['versionInfo'] != null
        ? VersionInfo.fromJson(json['versionInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.versionInfo != null) {
      data['versionInfo'] = this.versionInfo.toJson();
    }
    return data;
  }
}

class VersionInfo {
  VersionItem iOSDev;
  VersionItem androidDev;
  VersionItem iOSTest;
  VersionItem androidTest;
  VersionItem iOSProduct;
  VersionItem androidProduct;

  VersionInfo({this.iOSDev, this.androidDev,this.iOSTest, this.androidTest, this.iOSProduct, this.androidProduct});

  VersionInfo.fromJson(Map<String, dynamic> json) {
    iOSDev =
        json['iOSDev'] != null 
        ? VersionItem.fromJson(json['iOSDev']) : null;
    androidDev = json['androidDev'] != null
        ? VersionItem.fromJson(json['androidDev'])
        : null;
    iOSTest =
        json['iOSTest'] != null 
        ? VersionItem.fromJson(json['iOSTest']) : null;
    androidTest = json['androidTest'] != null
        ? VersionItem.fromJson(json['androidTest'])
        : null;
    iOSProduct = json['iOSProduct'] != null
        ? VersionItem.fromJson(json['iOSProduct'])
        : null;
    androidProduct = json['androidProduct'] != null
        ? VersionItem.fromJson(json['androidProduct'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.iOSDev != null) {
      data['iOSDev'] = this.iOSDev.toJson();
    }
    if (this.androidDev != null) {
      data['androidDev'] = this.androidDev.toJson();
    }
    if (this.iOSTest != null) {
      data['iOSTest'] = this.iOSTest.toJson();
    }
    if (this.androidTest != null) {
      data['androidTest'] = this.androidTest.toJson();
    }
    if (this.iOSProduct != null) {
      data['iOSProduct'] = this.iOSProduct.toJson();
    }
    if (this.androidProduct != null) {
      data['androidProduct'] = this.androidProduct.toJson();
    }
    return data;
  }
}

class VersionItem {
  String appName;
  String versionCode;
  String versionName;
  bool lastForce;
  String platform;
  String env;
  String fileUrl;
  String upgradeUrl;
  String upgradeInfo;

  VersionItem(
      {this.appName,
      this.versionCode,
      this.versionName,
      this.lastForce,
      this.platform,
      this.env,
      this.fileUrl,
      this.upgradeUrl,
      this.upgradeInfo});

  VersionItem.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    versionCode = json['versionCode'];
    versionName = json['versionName'];
    lastForce = json['lastForce'];
    platform = json['platform'];
    env = json['env'];
    fileUrl = json['fileUrl'];
    upgradeUrl = json['upgradeUrl'];
    upgradeInfo = json['upgradeInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['appName'] = this.appName;
    data['versionCode'] = this.versionCode;
    data['versionName'] = this.versionName;
    data['lastForce'] = this.lastForce;
    data['platform'] = this.platform;
    data['env'] = this.env;
    data['fileUrl'] = this.fileUrl;
    data['upgradeUrl'] = this.upgradeUrl;
    data['upgradeInfo'] = this.upgradeInfo;
    return data;
  }
}