// 运行时数据
import 'package:hsa_app/model/model/electricity_price.dart';

class NearestRunningData{

  // 电压
  double voltage;
  double voltageB;
  double voltageC;
  // 电流
  double current;
  double currentB;
  double currentC;
  // 励磁电流
  double fieldCurrent;
  // 功率因数
  double powerFactor;
  // 频率
  double frequency;
  // 开度
  double openAngle;
  // 有功功率
  double power;
  double powerA;
  double powerB;
  double powerC;
  // 有功功率
  double reactivePower;
  double reactivePowerA;
  double reactivePowerB;
  double reactivePowerC;
  // 水位
  double waterStage;
  // 温度
  double temperature;
  // 转速
  double speed;
  //电网电压
  double netVoltage;
  //电网电压
  double netFrequency;

  //累计有功电能
  int totalActivePower;
  //累计无功电能
  int totalReactivePower;
  //当日有功电能
  int dayActivePower;
  //当日无功电能
  int dayReactivePower;
  //当月有功电能
  int monthActivePower;
  //当月无功电能
  int monthReactivePower;


  // 是否允许远程控制
  bool isAllowRemoteControl;
  // 控制类型
  String controlType;
  // 机组开关机状态
  String powerStatus;
  // 智能控制方案
  String intelligentControlProgram;
  // 预计收入 - 单位元 - 单水轮机收益
  double money;

  // 更新时间
  String dataCachedTime;

  NearestRunningData(
    { this.voltage,
      this.voltageB,
      this.voltageC,
      this.current,
      this.currentB,
      this.currentC,
      this.fieldCurrent,
      this.powerFactor,
      this.frequency,
      this.openAngle,
      this.power,
      this.powerA,
      this.powerB,
      this.powerC,
      this.temperature,
      this.speed,
      this.waterStage,
      this.netVoltage,
      this.netFrequency,
      this.totalActivePower,
      this.totalReactivePower,
      this.dayActivePower,
      this.dayReactivePower,
      this.monthActivePower,
      this.monthReactivePower,
      this.reactivePower,
      this.reactivePowerA,
      this.reactivePowerB,
      this.reactivePowerC,
    });


  NearestRunningData.fromJson(Map<String,dynamic> json,String terminalAddress,{bool isBase = true,ElectricityPrice price}) {

    // 电气量 BASE
    if(isBase == true) {
      voltage        = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电压'] ?? 0.0 : 0.0;
      voltageB       = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机B相电压'] ?? 0.0 : 0.0;
      voltageC       = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机C相电压'] ?? 0.0 : 0.0;
      current        = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电流'] ?? 0.0 : 0.0;
      currentB       = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机B相电流'] ?? 0.0 : 0.0;
      currentC       = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机C相电流'] ?? 0.0 : 0.0;
      frequency      = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机电压频率'] ?? 0.0 : 0.0;
      power          = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总有功功率'] ?? 0.0 : 0.0;
      powerA         = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相有功功率'] ?? 0.0 : 0.0;
      powerB         = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机B相有功功率'] ?? 0.0 : 0.0;
      powerC         = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机C相有功功率'] ?? 0.0 : 0.0;
      powerFactor    = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总功率因数'] ?? 0.0 : 0.0;
      dataCachedTime = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['dataCachedTime'] ?? '' : '' ;
      netVoltage     = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['电网电压'] ?? 0.0 : 0.0;
      netFrequency   = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['电网电压频率'] ?? 0.0 : 0.0;
      reactivePower  = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总无功功率'] ?? 0.0 : 0.0;
      reactivePowerA = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相无功功率'] ?? 0.0 : 0.0;
      reactivePowerB = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机B相无功功率'] ?? 0.0 : 0.0;
      reactivePowerC = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机C相无功功率'] ?? 0.0 : 0.0;
    }
    // 电气量 PRO
    else {
      voltage        = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相电压'] ?? 0.0 : 0.0;
      voltageB       = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机B相电压'] ?? 0.0 : 0.0;
      voltageC       = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机C相电压'] ?? 0.0 : 0.0;
      current        = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相电流'] ?? 0.0 : 0.0;
      currentB       = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机B相电流'] ?? 0.0 : 0.0;
      currentC       = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机C相电流'] ?? 0.0 : 0.0;
      frequency      = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机电压频率'] ?? 0.0 : 0.0;
      power          = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总有功功率'] ?? 0.0 : 0.0;
      powerA         = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相有功功率'] ?? 0.0 : 0.0;
      powerB         = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机B相有功功率'] ?? 0.0 : 0.0;
      powerC         = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机C相有功功率'] ?? 0.0 : 0.0;
      powerFactor    = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总功率因数'] ?? 0.0 : 0.0;
      dataCachedTime = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['dataCachedTime'] ?? '' : '' ;
      netVoltage     = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['电网电压'] ?? 0.0 : 0.0;
      netFrequency   = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['电网电压频率'] ?? 0.0 : 0.0;
      reactivePower  = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总无功功率'] ?? 0.0 : 0.0;
      reactivePowerA = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相无功功率'] ?? 0.0 : 0.0;
      reactivePowerB = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机B相无功功率'] ?? 0.0 : 0.0;
      reactivePowerC = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机C相无功功率'] ?? 0.0 : 0.0;
    }

    // 通用参数 : 

    // 励磁电流
    fieldCurrent   = json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0']['励磁电流'] ?? 0.0 : 0.0;
    // 水门开度
    openAngle      = getOpenAngle(json, terminalAddress);
    // 水位
    waterStage     = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['水位'] ?? 0.0 : 0.0;
    // 转速
    speed          = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['转速'] ?? 0.0 : 0.0;
    
    // 控制方案与开关机状态
    isAllowRemoteControl = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['isAllowRemoteControl'] ?? false : false;
    controlType = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['controlType'] ?? '未知' : '未知';
    powerStatus = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['机组开关机状态'] ?? '未定义' : '未定义';
    intelligentControlProgram = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['智能控制方案'] ?? '水位智能调节方案' : '水位智能调节方案';

    // 温度值获取
    temperature = getTemperature(json,terminalAddress);

    //有功电能  
    totalActivePower = json['terminal-'+'$terminalAddress'+'.afn0c.f22.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f22.p0']['正向总有功电能'] ?? 0 : 0;
    dayActivePower = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['正向总有功电能'] ?? 0 : 0;
    monthActivePower = json['terminal-'+'$terminalAddress'+'.afn0c.f21.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f21.p0']['正向总有功电能'] ?? 0 : 0;

    //有功电能  
    totalReactivePower = json['terminal-'+'$terminalAddress'+'.afn0c.f22.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f22.p0']['正向总无功电能'] ?? 0 : 0;
    dayReactivePower = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['正向总无功电能'] ?? 0 : 0;
    monthReactivePower = json['terminal-'+'$terminalAddress'+'.afn0c.f21.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f21.p0']['正向总无功电能'] ?? 0 : 0;

    // 发电收入值获取
    if(price == null) {
      money = 0.0;
    }
    else {
      money = getDailyMoney(json, terminalAddress,price);
    }

    // 非法数据容错与修正   因为有时候 服务器会返回负数
    voltage         = fix(voltage);
    current         = fix(current);
    frequency       = fix(frequency);
    power           = fix(power);
    powerFactor     = fix(powerFactor);
    fieldCurrent    = fix(fieldCurrent);
    openAngle       = fix(openAngle);
    waterStage      = fix(waterStage);
    temperature     = fix(temperature);
    money           = fix(money);
    speed           = fix(speed);

  }

  // 非法数据容错与修正 , 因为有时候 服务器会返回负数
  double fix(double value) {
    return value >= 0.0 ? value : 0.0;
  }

  // 获取开度
  double getOpenAngle(Map<String,dynamic> json,String terminalAddress) {
    double openAngle1 = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['开度1'] ?? 0.0 : 0.0;
    if(openAngle1 < 0) openAngle1 = 0.0;
    return openAngle1;
  }

  // 获取温度值
  double getTemperature(Map<String,dynamic> json,String terminalAddress) {

    double result = 0.0;
    // 温度值获取
    final tempCount = json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0']['温度路数'] ?? 0 : 0;
    // 温度 为 0
    if(tempCount == 0) {
       result = 0.0;
    }
    else {
      
      List tempStatus = json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0']['测量状态'] ?? [] : [];
      List tempDatas  = json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0']['温度数据'] ?? [] : [];
      
      // 温度获取 取首个 Normal 状态的温度值 (废弃)
      // int findIndex = 0;
      // for (int i = 0 ; i < tempStatus.length ; i ++) {
      //   final status = tempStatus[i];
      //   if(status == 'Normal') {
      //     findIndex = i;
      //     break;
      //   }
      // }
      // result = tempDatas[findIndex];


      // 温度获取 取 Normal 状态的温度值(多路) 中的最大值

      List temps = [];
      // 取出所有Norml状态的温度值
      for (var i = 0; i < tempStatus.length; i++) {
        final status = tempStatus[i];
        if(status == 'Normal') {
          final value = tempDatas[i];
          // 排除开路干扰 开路时温度大于 1000
          if(value < 1000) {
            temps.add(value);
          }
        }
      }
      // 取出最大值
      if(temps.length > 0) {
        temps.sort((a, b) => (b.toDouble()-a.toDouble()).toInt());
        result  = temps?.first ?? 0.0;
      }


    }
    // 排除开路干扰 开路时温度大于 1000
    if(result > 1000) {
      return 0.0;
    }
    return result;
  }

  // 获取当日电量收入 - 单位元
  double getDailyMoney(Map<String,dynamic> json,String terminalAddress,ElectricityPrice price) {

    double result = 0.0;
    // 启用复费率启用标志
    bool isMultipleRateEnabled = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['复费率启用标志'] ?? false : false;
    // 尖电量
    num peakElectricityEnergy    = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['费率1正向有功电能'] ?? 0.0 : 0.0;
    // 峰电量
    num spikeElectricityEnergy   = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['费率2正向有功电能'] ?? 0.0 : 0.0;
    // 平电量 
    num flatElectricityEnergy    = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['费率3正向有功电能'] ?? 0.0 : 0.0;
    // 谷电量
    num valleyElectricityEnergy  = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['费率4正向有功电能'] ?? 0.0 : 0.0;
    // 总正向电量
    num totalElectricityEnergy   = json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f20.p0']['正向总有功电能'] ?? 0.0 : 0.0;

    //  获取当日收益值
    result = ElectricityEnergy(
      price: price,
      peakElectricityEnergy:peakElectricityEnergy,
      spikeElectricityEnergy:spikeElectricityEnergy,
      flatElectricityEnergy:flatElectricityEnergy,
      valleyElectricityEnergy:valleyElectricityEnergy,
      totalElectricityEnergy:totalElectricityEnergy,
      isMultipleRateEnabled:isMultipleRateEnabled,
    ).money;

    return result;
  }


  @override
  String toString() {
    String msg = '运行时参数 : ' + '\n';
    msg += '电压:' + this.voltage.toStringAsFixed(1) +'\n';
    msg += '电流:' + this.current.toStringAsFixed(1) +'\n';
    msg += '励磁电流:' + this.fieldCurrent.toStringAsFixed(2) +'\n';
    msg += '功率因数:' + this.powerFactor.toStringAsFixed(2) +'\n';

    msg += '有功功率:' + this.power.toStringAsFixed(1) +'\n';
    msg += '频率:' + this.voltage.toStringAsFixed(2) +'\n';
    msg += '开度:' + this.voltage.toStringAsFixed(0) +'\n';

    msg += '温度:' + this.temperature.toStringAsFixed(1) +'\n';
    msg += '转速:' + this.speed.toStringAsFixed(1) +'\n';
    msg += '水位:' + this.waterStage.toStringAsFixed(1) +'\n';

   msg += '控制类型:' + this.controlType +'\n';
   msg += '开关机状态:' + this.powerStatus +'\n';
   msg += '智能控制方案:' + this.intelligentControlProgram +'\n';
   msg += '是否允许远程控制:' + (this.isAllowRemoteControl == true ? '' : '') +'\n';

    msg += '预计收入:' + this.money.toStringAsFixed(2) + '元'  +'\n';
    msg += '更新时间:' + this.dataCachedTime +'\n';

    return msg;

  }

}