import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:flutter/material.dart';

// 设备信息
class DeviceInfo {

  // 是否是模拟器
  bool isSimulator = false;

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
  static void inspectDevice(BuildContext context) async {

    var log = '----设备信息----\n';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if(Platform.isIOS) {

      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log += '设备类型:' + (iosInfo.isPhysicalDevice ? '真机' :'模拟器') + '\n';
      log += '操作系统:' + iosInfo.systemName + '\n';
      log += '系统版本:' + iosInfo.systemVersion + '\n';
      log += '设备名称:' + iosInfo.name ;
      DeviceInfo.getInstance().isSimulator = ! iosInfo.isPhysicalDevice;
    }

    else if (Platform.isAndroid){

      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log += '设备类型:' + (androidInfo.isPhysicalDevice ? '真机' :'模拟器') + '\n';
      log += '操作系统:' + androidInfo.version.baseOS + '\n';
      log += '系统版本:' + androidInfo.version.release + '\n';
      log += '设备名称:' + androidInfo.device ;
      DeviceInfo.getInstance().isSimulator = ! androidInfo.isPhysicalDevice;
    }
    mesureDeviceBoundSize(context);
    debugPrint(log);
  }

  // 测量设备宽高
  static void mesureDeviceBoundSize(BuildContext context) async {
    await Future.delayed(Duration(seconds:1));
    var deviceWidth  = MediaQuery.of(context).size.width.toString();
    var deivceHeight = MediaQuery.of(context).size.height.toString();

    debugPrint(
      '🏷️设备尺寸 :'+
      '宽 = ' + deviceWidth + ','
      '高 = ' + deivceHeight);
  }

}