import 'package:dio/dio.dart';
import 'package:hsa_app/debug/debug_api.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/debug_share_instance.dart';
import 'package:hsa_app/debug/response/all_resp.dart';
import 'package:hsa_app/util/encrypt.dart';

class DebugAPILogin {

  // 登录接口
  static void login(BuildContext context,{@required String name,@required String pswd,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {

    // 输入检查
    if(name == null || name.length == 0) {
      if(onFail != null) onFail('请输入用户名');
      return;
    }
    if(pswd == null || pswd.length == 0) {
      if(onFail != null) onFail('请输入密码');
      return;
    }
    
    // 加密
    final plain = name + ':' + DebugAPI.appKey + ':' + pswd;
    final encrypted = await LDEncrypt.encryptedRSA(context,plain);

    // 检测网络
    var isReachable = await DebugHttpHelper.isReachablity();
    if (isReachable == false) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
    }

    // 登录路径地址
    final path = DebugAPI.restHost + '/v1/Account/AuthenticationToken/Apply/' + DebugAPI.appKey;

    // 发起请求
    var dio = DebugHttpHelper.initDio();
    try {
      Response response = await dio.post(path,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: DebugHttpHelper.recvTimeOutSeconds,
          sendTimeout: DebugHttpHelper.sendTimeOutSeconds,
        ),
        data: {'':encrypted},
      );
      if (response == null) {
        if(onFail != null)  onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        if(onFail != null) onFail('登录失败 ( ' + response.statusCode.toString() + ' )');
        return;
      }

      // 存储 auth 到 全局单例
      final header = response.headers;
      final auth = header.value('set-authorization');
      DebugShareInstance.getInstance().auth = auth;

      if(onSucc != null) onSucc(auth,'登录成功');
      return;
    } catch (e) {
      if(onFail != null) onFail('登录失败');
      debugPrint(e.toString());
      return;
    }
  }

  // 获取帐号信息
  static void getAccountInfo({@required String name,AccountInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    // 输入检查
    if(name == null || name.length == 0) {
      if(onFail != null) onFail('请输入用户名');
      return;
    }
    
    // 获取帐号信息地址
    final path = DebugAPI.restHost + '/v1/Account/' + name;
    
    DebugHttpHelper.httpGET(path, null, (map,_){

      var resp = AccountInfoResp.fromJson(map);
      DebugShareInstance.getInstance().accountName = resp.data.accountName;
      
      if(onSucc != null) onSucc(resp.data);

    }, onFail);

  }

  // 修改登录密码
  static void resetLoginPassword(BuildContext context,{String accountName,String oldLoginPwd,String newLoginPwd,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
    // 输入检查
    if(oldLoginPwd == null) {
      if(onFail != null) onFail('请输入旧密码');
      return;
    }
    if(newLoginPwd == null) {
      if(onFail != null) onFail('请输入新密码');
      return;
    }
    final oldPwd = await LDEncrypt.encryptedRSA(context,oldLoginPwd);
    final newPwd = await LDEncrypt.encryptedRSA(context,newLoginPwd);
    // 获取修改密码地址
    final path = DebugAPI.restHost + '/v1/Account/'+'$accountName'+'/Reset/LoginPassword';

    var param = {'oldLoginPwd':oldPwd,'newLoginPwd':newPwd};
    
    DebugHttpHelper.httpPATCH(path, param, (map,_){

      if(onSucc != null) onSucc('','密码修改成功!');
    }, onFail);
  }
}