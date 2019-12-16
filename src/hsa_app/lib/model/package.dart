class PackageResp {
  List<Package> results;
  int count;

  PackageResp({this.results, this.count});

  PackageResp.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<Package>();
      json['results'].forEach((v) {
        results.add(Package.fromJson(v));
      });
    }
    count = json['count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Package {
  String phoneSOS;
  String displayVersion;
  String hostApi;
  String hostWeb;
  String upgradeInfo;
  String upgradeTitle;
  String env;
  int buildVersion;
  bool isForced;
  String platform;

  Package(
      {this.phoneSOS,
      this.displayVersion,
      this.hostApi,
      this.hostWeb,
      this.upgradeInfo,
      this.upgradeTitle,
      this.env,
      this.buildVersion,
      this.isForced,
      this.platform});

  Package.fromJson(Map<String, dynamic> json) {
    phoneSOS = json['phoneSOS'] ?? '';
    displayVersion = json['displayVersion'] ?? '';
    hostApi = json['hostApi'] ?? '';
    hostWeb = json['hostWeb'] ?? '';
    upgradeInfo = json['upgradeInfo'] ??'';
    upgradeTitle = json['upgradeTitle'] ?? '';
    env = json['env'] ?? '';
    buildVersion = json['buildVersion'] ?? 0;
    isForced = json['isForced'] ?? false;
    platform = json['platform'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phoneSOS'] = this.phoneSOS;
    data['displayVersion'] = this.displayVersion;
    data['hostApi'] = this.hostApi;
    data['hostWeb'] = this.hostWeb;
    data['upgradeInfo'] = this.upgradeInfo;
    data['upgradeTitle'] = this.upgradeTitle;
    data['env'] = this.env;
    data['buildVersion'] = this.buildVersion;
    data['isForced'] = this.isForced;
    data['platform'] = this.platform;
    return data;
  }
}