import 'package:hsa_app/api/api_helper.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/response/all_resp.dart';

// APP发布相关API
class APIPublish {

  // 获取发布版本号,并上报统计数据
  static void getMobileAppPublishInfo(PublishCallback onSucc,HttpFailCallback onFail ) {

    PublishInput input = PublishInput.create();

    if (isValidatePublishInput(input) == false) return;

    final path = API.baseHost + '/v1/MobileAppPublishInfo/AcquireLastVersionInfo/' + '${input.deviceUUID}';

     Map<String,dynamic> param = Map<String,dynamic>();
     param['deviceEquipmentModel'] = input.deviceEquipmentModel;
     param['systemPlatformType'] = input.systemPlatformType;
     param['systemVersion'] = input.systemVersion;
     param['appVersionType'] = input.appVersionType;
     param['appVersion'] = input.appVersion;

    HttpHelper.httpPOST(path, param, (map,_){
      var resp = PublishResp.fromJson(map);
      if(resp.code != 0) {
        if(onFail != null) onFail('版本信息获取失败');
        return;
      }
      Publish publish = resp.data;
      if(onSucc != null) onSucc(publish);
    }, (_){
      if(onFail != null) onFail('版本信息获取失败');
    },jumpAuthChek:true);
    
  }

  // 检测发布输入参数
  static bool isValidatePublishInput(PublishInput input) {
    if(input == null) return false;
    if(input.appVersion == null) return false;
    if(input.deviceEquipmentModel == null) return false;
    if(input.systemVersion == null) return false;
    if(input.systemPlatformType == null) return false;
    if(input.deviceUUID == null) return false;
    if(input.appVersionType == null) return false;
    return true;
  }
}