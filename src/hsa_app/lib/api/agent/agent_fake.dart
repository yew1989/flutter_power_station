import 'dart:math';
import 'package:hsa_app/model/model/nearest_running_data.dart';
import 'package:hsa_app/model/model/station.dart';

class AgentFake {

  static fakeNearestRunningData(NearestRunningData data) {
    var result = data;

    var random = Random();
    var sign = random.nextBool() ? 1.0 : -1.0;
    var pointLeft =random.nextInt(2);
    var pointRight = random.nextDouble();
    // 频率变化
    result.frequency= 50 + (sign * pointLeft) + (sign * pointRight);

    // 功率
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(120); pointRight = random.nextDouble();
    result.power= 500 + (sign * pointLeft) + (sign * pointRight);

    // 开度
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(5); pointRight  = random.nextDouble();
    result.openAngle= 75 + (sign * pointLeft) + (sign * pointRight);
     
    // 电压
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(100); pointRight  = random.nextDouble();
    result.voltage= 200 + (sign * pointLeft) + (sign * pointRight);

    // 电流
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(50); pointRight  = random.nextDouble();
    result.current= 300 + (sign * pointLeft) + (sign * pointRight);

    // 励磁电流
    sign = random.nextBool() ? 1.0 : -1.0; pointLeft  =random.nextInt(5); pointRight  = random.nextDouble();
    result.fieldCurrent = 18 + (sign * pointLeft) + (sign * pointRight);
    
    // 功率因数
    pointRight  = random.nextDouble();
    result.powerFactor = 0.5 + (pointRight / 2);

    return result;
  }

  static fakeStationInfo(StationInfo station) {

  }
}
