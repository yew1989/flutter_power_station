import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:flutter/material.dart';

// 设备信息
class DeviceInfo {

  // 是否是模拟器
  bool isSimulator = false;
  // 系统类型
  String systemType = '';
  // 系统版本
  String systemVersion = '';
  // 设备型号
  String deviceEquipmentModel = '';

  DeviceInfo._();

  static DeviceInfo _instance;

  static DeviceInfo getInstance() {
    if (_instance == null) {
      _instance = DeviceInfo._();
    }
    return _instance;
  }
}

// 设备检查器
class DeviceInspector {
  
  // 检查设备
  static void inspectDevice() async {

    var log = '';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if(Platform.isIOS) {

      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log += '设备类型:' + (iosInfo.isPhysicalDevice ? '真机' :'模拟器') + ' ';
      log += '操作系统:' + 'iOS' + ' ';
      log += '系统版本:' + iosInfo.systemVersion + ' ';
      log += '设备机型:' + iosInfo.model + ' ';

      DeviceInfo.getInstance().systemType = 'iOS';
      DeviceInfo.getInstance().systemVersion = iosInfo.systemVersion;
      DeviceInfo.getInstance().deviceEquipmentModel = iosInfo.model ?? '未知';
      DeviceInfo.getInstance().isSimulator = ! iosInfo.isPhysicalDevice;
      if(DeviceInfo.getInstance().isSimulator == true) DeviceInfo.getInstance().deviceEquipmentModel = '模拟器';
      
    }

    else if (Platform.isAndroid){

      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log += '设备类型:' + (androidInfo.isPhysicalDevice ? '真机' :'模拟器') + ' ';
      log += '操作系统:' + 'Android' + ' ';
      log += '系统版本:' + androidInfo.version.release + ' ';
      log += '设备机型:' + androidInfo.model + ' ';

      DeviceInfo.getInstance().systemType = 'Android';
      DeviceInfo.getInstance().systemVersion = androidInfo.version.release;
      DeviceInfo.getInstance().deviceEquipmentModel = androidInfo?.model ?? '未知';
      DeviceInfo.getInstance().isSimulator = ! androidInfo.isPhysicalDevice;
      if(DeviceInfo.getInstance().isSimulator == true) DeviceInfo.getInstance().deviceEquipmentModel = '模拟器';

    }
    debugPrint(log);
  }

}