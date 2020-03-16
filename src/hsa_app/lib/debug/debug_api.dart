import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/debug_share_instance.dart';
import 'package:hsa_app/util/encrypt.dart';

class DebugAPI {

  // 主机地址
  static final restHost = 'http://192.168.16.2:8281';

  // 固定应用ID AppKey 由平台下发
  static final appKey = '3a769958-098a-46ff-a76a-de6062e079ee'; 

  // 登录接口
  static void login(BuildContext context,{String name, String pswd,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {

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
    final plain = name + ':' + appKey + ':' + pswd;
    final encrypted = await LDEncrypt.encryptedRSA(context,plain);

    // 检测网络
    var isReachable = await DebugHttpHelper.isReachablity();
    if (isReachable == false) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
    }

    // 登录路径地址
    final path = restHost + '/v1/Account/AuthenticationToken/Apply/' + appKey;

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
      return;
    }

  }

  // 获取帐号信息
  static void getAccountInfo({String name,DebugHttpSuccMapCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    // 输入检查
    if(name == null || name.length == 0) {
      if(onFail != null) onFail('请输入用户名');
      return;
    }
    
    // 获取帐号信息地址
    final path = restHost + '/v1/Account/' + name;

    DebugHttpHelper.httpGET(path, null, onSucc, onFail);
  }





}