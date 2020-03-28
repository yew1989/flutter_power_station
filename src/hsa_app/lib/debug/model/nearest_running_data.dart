// 运行时数据
import 'package:flutter/material.dart';

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
  //功率
  double power;
  // 水位
  double waterStage;

  // 温度
  double temperature;
  //推力
  double thrust;
  //水压
  double waterPressure;

  // 是否允许远程控制
  bool isAllowRemoteControl;
  // 控制类型
  String controlType;
  // 机组开关机状态
  String powerStatus;
  // 智能控制方案
  String intelligentControlProgram;

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

  NearestRunningData.fromJson(Map<String,dynamic> json,String terminalAddress,{bool isBase = true}) {

    // 电气量 BASE
    if(isBase == true) {
      voltage = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电压'] ?? 0.0 : 0.0;
      current = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机A相电流'] ?? 0.0 : 0.0;
      frequency = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['电网电压频率'] ?? 0.0 : 0.0;
      power = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总有功功率'] ?? 0.0 : 0.0;
      powerFactor = json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f9.p0']['发电机总功率因数'] ?? 0.0 : 0.0;
    }
    // 电气量 PRO
    else {
      voltage = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相电压'] ?? 0.0 : 0.0;
      current = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机A相电流'] ?? 0.0 : 0.0;
      frequency = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['电网电压频率'] ?? 0.0 : 0.0;
      power = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总有功功率'] ?? 0.0 : 0.0;
      powerFactor = json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f30.p0']['发电机总功率因数'] ?? 0.0 : 0.0;
    }

    // 通用参数
    fieldCurrent = json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f10.p0']['励磁电流'] ?? 0.0 : 0.0;
    openAngle = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['开度1'] ?? 0.0 : 0.0;
    waterStage = json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f11.p0']['水位'] ?? 0.0 : 0.0;
    
    // 温度值获取
    final tempCount = json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0'] != null ? json['terminal-'+'$terminalAddress'+'.afn0c.f13.p0']['温度路数'] ?? 0 : 0;

    if(tempCount == 0) {
       temperature = 0.0;
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

      temperature = tempDatas[findIndex];
    }



    // 非法数据容错与修正 , 因为有时候 服务器会返回负数
    voltage         = fix(voltage);
    current         = fix(current);
    frequency       = fix(frequency);
    power           = fix(power);
    powerFactor     = fix(powerFactor);
    fieldCurrent    = fix(fieldCurrent);
    openAngle       = fix(openAngle);
    waterStage      = fix(waterStage);
    temperature     = fix(temperature);

  }

  double fix(double value) {
    return value >= 0.0 ? value : 0.0;
  }

}