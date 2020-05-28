import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/share_instance.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/util/share_manager.dart';

// 失败回调
typedef HttpFailCallback = void Function(String msg);
// 成功 且 类型 为 Map的回调
typedef HttpSuccMapCallback = void Function(Map<String, dynamic> data, String msg);
// 成功 且 类型 为 String 的回调
typedef HttpSuccStrCallback = void Function(String str, String msg);
// 成功 且 类型 为 Void 的回调
typedef HttpSuccVoidCallback = void Function(String msg);
//通用回调
typedef HttpSuccCallback = void Function(dynamic data, String msg);

class HttpHelper {

  // 开启代理模式,允许抓包
  static final isProxyModeOpen = false;
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
  static void httpGET(String path, Map<String, dynamic> param, HttpSuccMapCallback onSucc,HttpFailCallback onFail) async { 
    
    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(ShareInstance.getInstance().auth.length == null || ShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }
    
    // 发起请求
    final dio = HttpHelper.initDio();

    try {
      Response response = await dio.get(
        path,
        options: Options(
          headers: {'Authorization': ShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.recvTimeOutSeconds,
          sendTimeout: HttpHelper.sendTimeOutSeconds,
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

      debugPrint(e.toString());
      handleDioError(e,(String msg) {
        if(onFail != null) onFail(msg);
      });
    }
  }

  // POST 请求
  static void httpPOST(String path, dynamic param, HttpSuccMapCallback onSucc,HttpFailCallback onFail ,{Map<String,dynamic> header}) async {

    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(ShareInstance.getInstance().auth.length == null || ShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }

    var headers = Map<String, dynamic> ();
    // Authorization 拼接
    if(ShareInstance.getInstance().auth.length > 0) {
      headers['Authorization'] = ShareInstance.getInstance().auth;
    }
    // 外部 header  拼接
    if(header != null) {
      for (String key in header.keys) {
        headers[key] = header[key];
      }
    }

    // 发起请求
    final dio = HttpHelper.initDio();

    try {
      Response response = await dio.post(
        path,
        options: Options(
          headers: headers,
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.recvTimeOutSeconds,
          sendTimeout: HttpHelper.sendTimeOutSeconds,
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
      debugPrint(e.toString());
      handleDioError(e,(String msg) {
       if(onFail != null)  onFail(msg);
      });
    }
  }

  // Patch 请求
  static void httpPATCH(String path, dynamic param, HttpSuccMapCallback onSucc,HttpFailCallback onFail ) async {

    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(ShareInstance.getInstance().auth.length == null || ShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }

    // 发起请求
    final dio = HttpHelper.initDio();

    try {
      Response response = await dio.patch(
        path,
        options: Options(
          headers: {'Authorization': ShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.recvTimeOutSeconds,
          sendTimeout: HttpHelper.sendTimeOutSeconds,
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
      debugPrint(e.toString());
      handleDioError(e,(String msg) {
       if(onFail != null)  onFail(msg);
      });
    }
  }

  // Put 请求
  static void httpPUT(String path, dynamic param, HttpSuccMapCallback onSucc,HttpFailCallback onFail ) async {

    // 网络检测
    final isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        if(onFail != null)onFail('网络异常,请检查网络');
        return;
      }
    }

    // Auth检测
    if(ShareInstance.getInstance().auth.length == null || ShareInstance.getInstance().auth.length == 0) {
      if(onFail != null) onFail('Auth为空,请先登录');
      return;
    }

    // 发起请求
    final dio = HttpHelper.initDio();

    try {
      Response response = await dio.put(
        path,
        options: Options(
          headers: {'Authorization': ShareInstance.getInstance().auth},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.recvTimeOutSeconds,
          sendTimeout: HttpHelper.sendTimeOutSeconds,
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
      debugPrint(e.toString());
      handleDioError(e,(String msg) {
       if(onFail != null)  onFail(msg);
      });
    }
  }

  // GET 请求通用请求封装
  static void getHttpCommon(
      String path, 
      Map<String, dynamic> param, 
      HttpSuccCallback onSucc,
      HttpFailCallback onFail) async {

    // 检测网络
    var isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        onFail('网络异常,请检查网络');
        return;
      }
    }

    var dio = HttpHelper.initDio();

    // 尝试请求
    try {
      var url = path ?? '';
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Authorization': ShareManager.instance.token},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.recvTimeOutSeconds,
          sendTimeout: HttpHelper.sendTimeOutSeconds,
        ),
        queryParameters: param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      debugPrint(e.toString());
      handleDioError(e,(String msg) {
       if(onFail != null)  onFail(msg);
      });
    }
  }

  // 处理 DioError
  static void handleDioError(dynamic e,HttpFailCallback onFail) {

    // DIO 错误
    if (e is DioError) {

      DioError dioError = e;
      var code = dioError.response?.statusCode;
      debugPrint('DioError ❌ : '+ dioError.toString());

      // 请求错误
      if(code == null) {
        if(onFail == null) onFail('请求错误');
        return;
      }
      // 401 Authorization 过期
      if (code == 401) {
        debugPrint('🔑 Authorization 过期错误');
        if(onFail == null) onFail('请求错误');
        eventBird?.emit(AppEvent.tokenExpiration);
        return;
      } 
      if(onFail == null) onFail('请求错误');
      return;
    }
    // DIO 错误
    else {
        if(onFail == null) onFail('请求错误');
        return;
    }
  }
}


