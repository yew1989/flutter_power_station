// 账户信息
class AccountInfo {
  String accountId;
  String accountName;
  String accountNickName;
  bool isEnabled;
  String description;
  List<String> accountStationRelation;
  bool isAutoRelateHyStation;

  AccountInfo(
      {this.accountId,
      this.accountName,
      this.accountNickName,
      this.isEnabled,
      this.description,
      this.accountStationRelation,
      this.isAutoRelateHyStation});

  AccountInfo.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    accountName = json['accountName'];
    accountNickName = json['accountNickName'];
    isEnabled = json['isEnabled'];
    description = json['description'];
    accountStationRelation = json['accountStationRelation'].cast<String>();
    isAutoRelateHyStation = json['isAutoRelateHyStation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['accountName'] = this.accountName;
    data['accountNickName'] = this.accountNickName;
    data['isEnabled'] = this.isEnabled;
    data['description'] = this.description;
    data['accountStationRelation'] = this.accountStationRelation;
    data['isAutoRelateHyStation'] = this.isAutoRelateHyStation;
    return data;
  }
}