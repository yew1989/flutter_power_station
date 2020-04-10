import 'dart:math';
import 'package:hsa_app/model/model/nearest_running_data.dart';
import 'package:hsa_app/model/model/station.dart';

class AgentFake {

  double savedMoney = 1024.0;

  AgentFake._internal();
  static AgentFake _singleton = AgentFake._internal();
  factory AgentFake()=> _singleton;

  static fakeNearestRunningData(NearestRunningData data) {
    var result = data;

    var random = Random();
    var sign = random.nextBool() ? 1.0 : -1.0;
    var pointLeft =random.nextInt(2);
    var pointRight = random.nextDouble();

    // 频率变化
    result.frequency = 50 + (sign * pointLeft) + (sign * pointRight);
    result.frequency = fixDouble(result.frequency);
    // 功率
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(120); pointRight = random.nextDouble();
    result.power= 500 + (sign * pointLeft) + (sign * pointRight);
    result.power = fixDouble(result.power);
    // 开度
    pointRight  = random.nextDouble();
    result.openAngle=  pointRight;
    result.openAngle = fixDouble(result.openAngle);
    // 电压
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(100); pointRight  = random.nextDouble();
    result.voltage= 200 + (sign * pointLeft) + (sign * pointRight);
    result.voltage = fixDouble(result.voltage);
    // 电流
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(50); pointRight  = random.nextDouble();
    result.current= 300 + (sign * pointLeft) + (sign * pointRight);
    result.current = fixDouble(result.current);
    // 励磁电流
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(5); pointRight  = random.nextDouble();
    result.fieldCurrent = 18 + (sign * pointLeft) + (sign * pointRight);
    result.fieldCurrent = fixDouble(result.fieldCurrent);
    // 功率因数
    pointRight  = random.nextDouble();
    result.powerFactor = 0.5 + (pointRight / 2);
    result.powerFactor = fixDouble(result.powerFactor);
    // 温度
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(5); pointRight  = random.nextDouble();
    result.temperature = 35 + (sign * pointLeft) + (sign * pointRight);
    result.temperature = fixDouble(result.temperature);

    // 转速
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(20); pointRight  = random.nextDouble();
    result.speed = 200 + (sign * pointLeft) + (sign * pointRight);
    result.speed = fixDouble(result.speed);
    // 水位
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(1); pointRight  = random.nextDouble();
    result.waterStage = 2.0 + (sign * pointLeft) + (sign * pointRight);
    result.waterStage = fixDouble(result.waterStage);

    return result;
  }

  static fakeStationInfo(StationInfo station) {
    var result = station;
    var random = Random();
    var sign = 1.0;
    var pointLeft = 0;
    var pointRight = 0.0;
    
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(10); pointRight  = random.nextDouble();
    var delka = 3 + pointLeft + (sign * pointRight * 7);
    AgentFake().savedMoney += delka;
    result.totalMoney = AgentFake().savedMoney;
    result.waterTurbines = station.waterTurbines.map((f){
       sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(50); pointRight  = random.nextDouble();
       var power = 300 + (sign * pointLeft) + (sign * pointRight);
       f?.deviceTerminal?.nearestRunningData?.power = power ?? 0.0;
       f?.deviceTerminal?.isOnLine = true;
       return f;
    }).toList();

    return result;
  }

  static double fixDouble(double old) {
    var source = old.toStringAsFixed(2);
    return double.parse(source);
  }
}
