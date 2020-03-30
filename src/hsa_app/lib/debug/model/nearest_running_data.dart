// 运行时数据
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/model/electricity_price.dart';

class NearestRunningData{

  // 电压
  double voltage;
  // 电流
  double current;
  // 励磁电流
  double fieldCurrent;
  // 功率因数
  double powerFactor;
  // 频率
  double frequency;
  // 开度
  double openAngle;
  // 功率
  double power;
  // 水位
  double waterStage;

  // 温度
  double temperature;
  // 推力
  double thrust;
  // 水压
  double waterPressure;

  // 是否允许远程控制
  bool isAllowRemoteControl;
  // 控制类型
  String controlType;
  // 机组开关机状态
  String powerStatus;
  // 智能控制方案
  String intelligentControlProgram;
  
  // 预计收入 - 单位元
  double money;

  NearestRunningData(
    { this.voltage,
      this.current,
      this.fieldCurrent,
      this.powerFactor,
      this.frequency,
      this.openAngle,
      this.thrust,
      this.waterPressure,
      this.power,
      this.temperature,
      this.waterStage
    });


  NearestRunningData.fromJson(Map<String,dynamic> json,String terminalAddress,{bool isBase = true,ElectricityPrice price}) {

    // 电气量 BASE
    if(isBase == true) {
      voltage       = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电压'] ?? 0.0 : 0.0;
      current       = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电流'] ?? 0.0 : 0.0;
      frequency     = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['电网电压频率'] ?? 0.0 : 0.0;
      power         = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总有功功率'] ?? 0.0 : 0.0;
      powerFactor   = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总功率因数'] ?? 0.0 : 0.0;
    }
    // 电气量 PRO
    else {
      voltage       = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相电压'] ?? 0.0 : 0.0;
      current       = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相电流'] ?? 0.0 : 0.0;
      frequency     = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['电网电压频率'] ?? 0.0 : 0.0;
      power         = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总有功功率'] ?? 0.0 : 0.0;
      powerFactor   = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总功率因数'] ?? 0.0 : 0.0;
    }

    // 通用参数 : 

    // 励磁电流
    fieldCurrent   = json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0']['励磁电流'] ?? 0.0 : 0.0;
    // 水门与水位
    openAngle      = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['开度1'] ?? 0.0 : 0.0;
    waterStage     = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['水位'] ?? 0.0 : 0.0;
    
    // 控制方案与开关机状态
    isAllowRemoteControl = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['isAllowRemoteControl'] ?? false : false;
    controlType = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['controlType'] ?? '手动' : '手动';
    powerStatus = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['机组开关机状态'] ?? '未定义' : '未定义';
    intelligentControlProgram = json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f24.p0']['智能控制方案'] ?? '水位智能调节方案' : '水位智能调节方案';

    // 温度值获取
    temperature = getTemperature(json,terminalAddress);

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

  }

  // 非法数据容错与修正 , 因为有时候 服务器会返回负数
  double fix(double value) {
    return value >= 0.0 ? value : 0.0;
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
      
      int findIndex = 0;
      
      for (int i = 0 ; i < tempStatus.length ; i ++) {
        final status = tempStatus[i];
        if(status == 'Normal') {
          findIndex = i;
          break;
        }
      }

      result = tempDatas[findIndex];

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

}