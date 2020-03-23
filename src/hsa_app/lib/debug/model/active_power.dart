// 历史有功数据列表
class ActivePowerList {
  int total;
  List<ActivePower> rows;

  ActivePowerList({this.total, this.rows});

  ActivePowerList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = List<ActivePower>();
      json['rows'].forEach((v) {
        rows.add(ActivePower.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// 有功信息
class ActivePower {
  String id;
  String stationNo;
  String terminalAddress;
  String freezeTime;
  List<num> periodicElectricityPrice;
  num estimatedIncome;
  num activePower;

  ActivePower(
      {this.id,
      this.stationNo,
      this.terminalAddress,
      this.freezeTime,
      this.periodicElectricityPrice,
      this.estimatedIncome,
      this.activePower});

  ActivePower.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationNo = json['stationNo'];
    terminalAddress = json['terminalAddress'];
    freezeTime = json['freezeTime'];
    periodicElectricityPrice = json['periodicElectricityPrice'].cast<num>();
    estimatedIncome = json['estimatedIncome'];
    activePower = json['总正向有功电能'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['stationNo'] = this.stationNo;
    data['terminalAddress'] = this.terminalAddress;
    data['freezeTime'] = this.freezeTime;
    data['periodicElectricityPrice'] = this.periodicElectricityPrice;
    data['estimatedIncome'] = this.estimatedIncome;
    data['总正向有功电能'] = this.activePower;
    return data;
  }
}