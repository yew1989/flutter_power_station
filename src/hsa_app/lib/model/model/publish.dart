// 版本发布数据体 - 上报给平台的
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/util/device_inspector.dart';

class PublishInput {

  // 设备唯一标识
  String deviceUUID;
  // 设备平台类型
  String systemPlatformType;
  // APP 版本类型  "Canary","Dev","Beta","Stable".
  String appVersionType;
  // 设备型号
  String deviceEquipmentModel;
  // 系统版本
  String systemVersion; 
  // 软件版本
  int appVersion; 

  PublishInput();

  static PublishInput create() {
    PublishInput input = PublishInput();
    input.deviceUUID = AppConfig.getInstance().uuid;
    input.appVersionType = AppConfig.getInstance().appVersionType;
    input.systemPlatformType = AppConfig.getInstance().platform;
    input.appVersion = AppConfig.getInstance().localBuildVersion;
    input.deviceEquipmentModel = DeviceInfo.getInstance().deviceEquipmentModel;
    input.systemVersion = DeviceInfo.getInstance().systemVersion;
    return input;
  }

}

// 版本发布数据体 - 平台返回的
class Publish {

  String publishId;
  String systemPlatformType;
  String publishVersionType;
  int publishVersion;
  int cmptVersion;
  bool isForceUpdate;
  String displayVersionInfo;
  String updateDescription;
  String installationPackageUrl;
  bool isPublish;
  String createTime;

  Publish( {this.publishId,
      this.systemPlatformType,
      this.publishVersionType,
      this.publishVersion,
      this.cmptVersion,
      this.isForceUpdate,
      this.displayVersionInfo,
      this.updateDescription,
      this.installationPackageUrl,
      this.isPublish,
      this.createTime});

  Publish.fromJson(Map<String, dynamic> json) {
    publishId = json['publishId'];
    systemPlatformType = json['systemPlatformType'];
    publishVersionType = json['publishVersionType'];
    publishVersion = json['publishVersion'];
    cmptVersion = json['cmptVersion'];
    isForceUpdate = json['isForceUpdate'];
    displayVersionInfo = json['displayVersionInfo'];
    updateDescription = json['updateDescription'];
    installationPackageUrl = json['installationPackageUrl'];
    isPublish = json['isPublish'];
    createTime = json['createTime'];
  }
}