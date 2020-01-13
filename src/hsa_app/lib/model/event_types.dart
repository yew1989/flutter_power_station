class EventTypes {
  String eRCTitle;
  int eRCFlag;

  EventTypes({this.eRCTitle, this.eRCFlag});

  EventTypes.fromJson(Map<String, dynamic> json) {
    eRCTitle = json['ERCTitle'] ?? '';
    eRCFlag = json['ERCFlag'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ERCTitle'] = this.eRCTitle;
    data['ERCFlag'] = this.eRCFlag;
    return data;
  }
}