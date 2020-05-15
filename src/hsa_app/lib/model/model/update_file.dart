class UpdateFile {
  String upgradeFileId;
  String deviceType;
  String deviceVersion;
  String upgradeFileName;
  String upgradeFileType;
  int upgradeFileSize;
  String uploadDateTime;
  String upgradeFileMD5;
  String upgradeFileDescription;

  UpdateFile(
      {this.upgradeFileId,
      this.deviceType,
      this.deviceVersion,
      this.upgradeFileName,
      this.upgradeFileType,
      this.upgradeFileSize,
      this.uploadDateTime,
      this.upgradeFileMD5,
      this.upgradeFileDescription});

  UpdateFile.fromJson(Map<String, dynamic> json) {
    upgradeFileId = json['upgradeFileId'];
    deviceType = json['deviceType'];
    deviceVersion = json['deviceVersion'];
    upgradeFileName = json['upgradeFileName'];
    upgradeFileType = json['upgradeFileType'];
    upgradeFileSize = json['upgradeFileSize'];
    uploadDateTime = json['uploadDateTime'];
    upgradeFileMD5 = json['upgradeFileMD5'];
    upgradeFileDescription = json['upgradeFileDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upgradeFileId'] = this.upgradeFileId;
    data['deviceType'] = this.deviceType;
    data['deviceVersion'] = this.deviceVersion;
    data['upgradeFileName'] = this.upgradeFileName;
    data['upgradeFileType'] = this.upgradeFileType;
    data['upgradeFileSize'] = this.upgradeFileSize;
    data['uploadDateTime'] = this.uploadDateTime;
    data['upgradeFileMD5'] = this.upgradeFileMD5;
    data['upgradeFileDescription'] = this.upgradeFileDescription;
    return data;
  }
}