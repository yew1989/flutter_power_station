// ERCFlag类型
class ERCFlagType {
  int ercFlag;
  int version;
  String ercTitle;

  ERCFlagType({this.ercFlag, this.version, this.ercTitle});

  ERCFlagType.fromJson(Map<String, dynamic> json) {
    ercFlag  = json['ercFlag'] ?? 0 ;
    version  = json['version'] ?? 0 ;
    ercTitle = json['ercTitle'] ?? '' ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ercFlag']  = this.ercFlag ?? 0 ;
    data['version']  = this.version ?? 0 ;
    data['ercTitle'] = this.ercTitle ?? '' ;
    return data;
  }
}