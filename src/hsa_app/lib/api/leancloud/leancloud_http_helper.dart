import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

typedef LeanCloudHttpSuccCallback = void Function(dynamic data, String msg);
typedef LeanCloudHttpFailCallback = void Function(String msg);

class LeanCloudHttpHelper {

  // 开启代理模式,允许抓包
  static final isProxyModeOpen = false;
  // 代理地址
  static final proxyIP = 'PROXY 192.168.31.8:8888';
  // 超时时间
  static final kTimeOutSeconds = 20;

  // 应用账号
  static final leancloudID = 'EpxcLicRln8WLYYcQmQsXCkq-gzGzoHsz';
  static final leancloudKey = 'oMGYsAx7MdqxQ8v9M4WY2keo';

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


  // GET 
  static void getHttp(String path, Map<String, dynamic> queryParam,LeanCloudHttpSuccCallback onSucc,LeanCloudHttpFailCallback onFail) async { 

    final dio = LeanCloudHttpHelper.initDio();

    try {

      Response response = await dio.get(path,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
          sendTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
        ),
        queryParameters: queryParam,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }

  // POST 
  static void postHttp(String path, Map<String, dynamic> param,LeanCloudHttpSuccCallback onSucc,LeanCloudHttpFailCallback onFail) async { 

    final dio = LeanCloudHttpHelper.initDio();

    try {
      Response response = await dio.post(path,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.jsonContentType,
          receiveTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
          sendTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
        ),
        data:param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }

  // PUT
  static void putHttp(String path, Map<String, dynamic> param,LeanCloudHttpSuccCallback onSucc,LeanCloudHttpFailCallback onFail) async { 

    final dio = LeanCloudHttpHelper.initDio();

    try {
      Response response = await dio.put(path,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.jsonContentType,
          receiveTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
          sendTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
        ),
        data:param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }

  // Delete
  static void deleteHttp(String path, Map<String, dynamic> queryParam,LeanCloudHttpSuccCallback onSucc,LeanCloudHttpFailCallback onFail) async { 

    final dio = LeanCloudHttpHelper.initDio();

    try {
      Response response = await dio.delete(path,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
          sendTimeout: LeanCloudHttpHelper.kTimeOutSeconds,
        ),
        queryParameters:queryParam,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }
}