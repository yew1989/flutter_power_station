import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/util/share.dart';

typedef HttpSuccCallback = void Function(dynamic data, String msg);
typedef HttpFailCallback = void Function(String msg);

class HttpHelper {

  // 开启代理模式,允许抓包
  static final isProxyModeOpen = false;
  // 代理地址
  static final proxyIP = 'PROXY 192.168.31.74:8888';
  // 超时时间
  static final kTimeOutSeconds = 10000;

  // 创建 DIO 对象
  static Dio initDio() {
    var dio = Dio();
    var adapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
        client.findProxy = (_) => isProxyModeOpen ? proxyIP : 'DIRECT';
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
    return dio;
  }

  // 检测网络
  static Future<bool> isReachablity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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
        EventBird().emit(AppEvent.tokenExpiration);
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

  // GET 请求统一封装
  static void getHttp(
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
      var url = AppConfig.getInstance().remotePackage.hostApi + path;
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Authorization': ShareManager.instance.token},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
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
      if (response.data is! Map) {
        onFail('请求错误');
        return;
      }
      // 初步解析数据包
      Map<String, dynamic> map = response.data;
      var code = map['code'] ?? -1;
      if (code != 0) {
        var msg = map['msg'] ?? '请求错误';
        onFail(msg);
        return;
      }
      var msg = map['msg'] ?? '请求成功';
      onSucc(response.data, msg);
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
    }
  }

  // POST 请求统一封装
  static void postHttp(
      String path, 
      dynamic param, 
      HttpSuccCallback onSucc,
      HttpFailCallback onFail ) async {

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
      final url = AppConfig.getInstance().remotePackage.hostApi + path;
      Response response = await dio.post(
        url,
        options: Options(
          headers: {'Authorization': ShareManager.instance.token},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        queryParameters: param,
        // data: param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('请求错误');
        return;
      }
      // 初步解析数据包
      Map<String, dynamic> map = response.data;
      var code = map['code'] ?? -1;
      if (code != 0) {
        var msg = map['msg'] ?? '请求错误';
        onFail(msg);
        return;
      }
      var msg = map['msg'] ?? '请求成功';
      onSucc(response.data, msg);
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
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
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
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
      if (response.data is! Map) {
        onFail('请求错误');
        return;
      }
      // 初步解析数据包
      onSucc(response.data, '请求成功');
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
    }
  }

  // POST Application/Json 
  static void postHttpApplicationJson(String path, dynamic param, HttpSuccCallback onSucc,HttpFailCallback onFail)  async  {

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
      Response response = await dio.post(
        url,
        options: Options(
          headers: {'Authorization': ShareManager.instance.token},
          contentType: Headers.jsonContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        data: param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('请求错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
    }

  }

  // POST 请求通用封装
  static void postHttpForm(
      String path, 
      dynamic param, 
      HttpSuccCallback onSucc,
      HttpFailCallback onFail,
      ) async {

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
      Response response = await dio.post(
        url,
        options: Options(
          headers: {'Authorization': ShareManager.instance.token},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
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
      if (response.data is! Map) {
        onFail('请求错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
    }
  }

  // POST 请求通用封装 String 
  static void postHttpCommonString(
      String path, 
      String string, 
      HttpSuccCallback onSucc,
      HttpFailCallback onFail,
      ) async {

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
      Response response = await dio.post(
        url,
        options: Options(
          headers: {'Authorization': ShareManager.instance.token},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        data: {'':string},
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('请求错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
    }
  }

    // GET 请求通用请求封装
  static void getHttpCommonRespList(
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
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
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
      if (response.data is! List) {
        onFail('请求错误');
        return;
      }
      // 初步解析数据包
      onSucc(response.data, '请求成功');
    } catch (e) {
      handleDioError(e,(String msg) => onFail(msg));
      onFail('请求错误');
    }
  }

}


class HttpResult {
  String msg;
  bool success;
}
