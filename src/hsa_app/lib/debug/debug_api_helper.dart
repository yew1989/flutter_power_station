import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_share_instance.dart';

// 失败回调
typedef DebugHttpFailCallback = void Function(String msg);
// 成功 且 类型 为 Map的回调
typedef DebugHttpSuccMapCallback = void Function(Map<String, dynamic> data, String msg);
// 成功 且 类型 为 String 的回调
typedef DebugHttpSuccStrCallback = void Function(String str, String msg);
// 成功 且 类型 为 Void 的回调
typedef DebugHttpSuccVoidCallback = void Function(String msg);

class DebugHttpHelper {

  // 开启代理模式,允许抓包
  static final isProxyModeOpen = true;
  // 代理主机地址
  static final proxyHost = '192.168.31.208:8888';
  // 接受超时时间
  static final recvTimeOutSeconds = 10000;
  // 发送超时时间
  static final sendTimeOutSeconds = 10000;

  // 创建 DIO 对象
  static Dio initDio() { 
    var dio = Dio();
    var adapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
        client.findProxy = (_) => isProxyModeOpen ? 'PROXY ' + proxyHost : 'DIRECT';
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
    return dio;
  }

  // 检测网络可用性
  static Future<bool> isReachablity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // GET 请求
  static void httpGET(String path, Map<String, dynamic> param, DebugHttpSuccMapCallback onSucc,DebugHttpFailCallback onFail) async { 
    
    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(DebugShareInstance.getInstance().auth.length == null || DebugShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }
    
    // 发起请求
    final dio = DebugHttpHelper.initDio();

    try {
      Response response = await dio.get(
        path,
        options: Options(
          headers: {'Authorization': DebugShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: DebugHttpHelper.recvTimeOutSeconds,
          sendTimeout: DebugHttpHelper.sendTimeOutSeconds,
        ),
        queryParameters: param,
      );
      if (response == null) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        if(onFail != null) onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if(onSucc != null) onSucc(response.data, '请求成功');
      return;
    } catch (e) {
      if(onFail != null) onFail('请求错误');
      debugPrint(e.toString());
      return;
    }
  }

  // POST 请求
  static void httpPOST(String path, dynamic param, DebugHttpSuccMapCallback onSucc,DebugHttpFailCallback onFail ) async {

    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(DebugShareInstance.getInstance().auth.length == null || DebugShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }

    // 发起请求
    final dio = DebugHttpHelper.initDio();

    try {
      Response response = await dio.post(
        path,
        options: Options(
          headers: {'Authorization': DebugShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: DebugHttpHelper.recvTimeOutSeconds,
          sendTimeout: DebugHttpHelper.sendTimeOutSeconds,
        ),
        data: param,
      );
      if (response == null) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        if(onFail != null) onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if(onSucc != null) onSucc(response.data, '请求成功');
    } catch (e) {
      if(onFail != null) onFail('请求错误');
      debugPrint(e.toString());
      return;
    }
  }

  // Patch 请求
  static void httpPATCH(String path, dynamic param, DebugHttpSuccMapCallback onSucc,DebugHttpFailCallback onFail ) async {

    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(DebugShareInstance.getInstance().auth.length == null || DebugShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }

    // 发起请求
    final dio = DebugHttpHelper.initDio();

    try {
      Response response = await dio.patch(
        path,
        options: Options(
          headers: {'Authorization': DebugShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: DebugHttpHelper.recvTimeOutSeconds,
          sendTimeout: DebugHttpHelper.sendTimeOutSeconds,
        ),
        data: param,
      );
      if (response == null) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        if(onFail != null) onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if(onSucc != null) onSucc(response.data, '请求成功');
    } catch (e) {
      if(onFail != null) onFail('请求错误');
      debugPrint(e.toString());
      return;
    }
  }

  // Put 请求
  static void httpPUT(String path, dynamic param, DebugHttpSuccMapCallback onSucc,DebugHttpFailCallback onFail ) async {

    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(DebugShareInstance.getInstance().auth.length == null || DebugShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }

    // 发起请求
    final dio = DebugHttpHelper.initDio();

    try {
      Response response = await dio.put(
        path,
        options: Options(
          headers: {'Authorization': DebugShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: DebugHttpHelper.recvTimeOutSeconds,
          sendTimeout: DebugHttpHelper.sendTimeOutSeconds,
        ),
        data: param,
      );
      if (response == null) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        if(onFail != null) onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if(onSucc != null) onSucc(response.data, '请求成功');
    } catch (e) {
      if(onFail != null) onFail('请求错误');
      debugPrint(e.toString());
      return;
    }
  }
}


