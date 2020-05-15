class UpdateTask {
  String deviceUpgradeMissionId;
  String terminalAddress;
  String upgradeFileId;
  String upgradeFileName;
  String upgradeFileMD5;
  double progressValue;
  String upgradeTaskState;
  String initiatorAccountName;
  String missionCreateTime;
  String missionStopTime;

  UpdateTask(
      {this.deviceUpgradeMissionId,
      this.terminalAddress,
      this.upgradeFileId,
      this.upgradeFileName,
      this.upgradeFileMD5,
      this.progressValue,
      this.upgradeTaskState,
      this.initiatorAccountName,
      this.missionCreateTime,
      this.missionStopTime});

  UpdateTask.fromJson(Map<String, dynamic> json) {
    deviceUpgradeMissionId = json['deviceUpgradeMissionId'];
    terminalAddress = json['terminalAddress'];
    upgradeFileId = json['upgradeFileId'];
    upgradeFileName = json['upgradeFileName'];
    upgradeFileMD5 = json['upgradeFileMD5'];
    progressValue = json['progressValue'];
    upgradeTaskState = json['upgradeTaskState'];
    initiatorAccountName = json['initiatorAccountName'];
    missionCreateTime = json['missionCreateTime'];
    missionStopTime = json['missionStopTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceUpgradeMissionId'] = this.deviceUpgradeMissionId;
    data['terminalAddress'] = this.terminalAddress;
    data['upgradeFileId'] = this.upgradeFileId;
    data['upgradeFileName'] = this.upgradeFileName;
    data['upgradeFileMD5'] = this.upgradeFileMD5;
    data['progressValue'] = this.progressValue;
    data['upgradeTaskState'] = this.upgradeTaskState;
    data['initiatorAccountName'] = this.initiatorAccountName;
    data['missionCreateTime'] = this.missionCreateTime;
    data['missionStopTime'] = this.missionStopTime;
    return data;
  }
}