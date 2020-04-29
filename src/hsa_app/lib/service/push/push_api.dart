import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/api_helper.dart';
import 'package:hsa_app/api/share_instance.dart';
import 'package:hsa_app/service/push/push_bind.dart';

class PushAPI {

  // 绑定极光推送RegID 到用户
  static void bindRegId(void Function(String) onSucc, void Function(String) onFail) {
    final regId = ShareInstance.getInstance().regId;
      if(regId == null) return;
      if(regId.length == 0) return;
      final path = API.baseHost + '/v1/Account/JGRegId/' + regId;

      HttpHelper.httpPATCH(path, null, (map,_){

      var resp = PushBindResp.fromJson(map);

      if(resp.code != 0 || resp.httpCode != 200) {
        if(onFail != null) onFail('推送绑定失败');
        return;
      }

      // 推送绑定获取
      final isBinded = resp?.data?.operationResult ?? false;
      if(isBinded == false) {
        if(onFail != null) onFail('推送绑定失败');
        return;
      }
      // 操作票获取成功
      if(onSucc != null) onSucc('推送绑定成功');

    }, (_){
      if(onFail != null) onFail('推送绑定失败');
    }
    );

  }
}