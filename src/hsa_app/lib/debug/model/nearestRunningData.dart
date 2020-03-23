class NearestRunningData{
  //电压
  double voltage;
  //电流
  double current;
  //励磁电流
  double fieldCurrent;
  //功率因数
  double powerFactor;
  //频率
  double frequency;
  //开度
  double openAngle;
  //推力
  double thrust;
  //水压
  double waterPressure;
  //功率
  double power;

  NearestRunningData(
    { this.voltage,
      this.current,
      this.fieldCurrent,
      this.powerFactor,
      this.frequency,
      this.openAngle,
      this.thrust,
      this.waterPressure,
      this.power
    });

  NearestRunningData.fromJson(Map<String,dynamic> json,String terminalAddress){
    voltage = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电压'] ?? 0.0;
    current = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电流'] ?? 0.0;
    fieldCurrent = json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0']['励磁电流'] ?? 0.0;
    powerFactor = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总功率因数'] ?? 0.0;
    frequency = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['电网电压频率'] ?? 0.0;
    openAngle = json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0']['开度1'] ?? 0.0;
    thrust = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'][''] ?? 0.0;
    waterPressure = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'][''] ?? 0.0;
    power = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总有功功率'] ?? 0.0;

  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['发电机A相电压'] = this.voltage;
    data['发电机A相电流'] = this.current;
    data['励磁电流'] = this.fieldCurrent;
    data['发电机总功率因数'] = this.powerFactor;
    data['电网电压频率'] = this.frequency;
    data['开度1'] = this.openAngle;


    data['发电机总有功功率'] = this.power;
    return data;
   }
}