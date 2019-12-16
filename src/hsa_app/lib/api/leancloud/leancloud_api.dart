import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/leancloud/leancloud_http_helper.dart';
import 'package:hsa_app/model/package.dart';

typedef PackageSuccCallback = void Function(Package data, String msg);

enum LeanCloudEnv{
  dev,
  test,
  product,
}

class LeanCloudAPI {

  // leanCloud服务器主机地址
  static final host = 'https://leancloud.cn:443/1.1';
  // 包管理对象操作路径
  static final packagePath = '/classes/Pacakge';

  // 获取包信息
  static void getPackageVersionInfo(LeanCloudEnv env,PackageSuccCallback onSucc,LeanCloudHttpFailCallback onFail) { 
    final path = host + packagePath;
    var queryParam = Map<String,dynamic>();
    queryParam['count'] = '1';
    queryParam['keys'] = '-ACL,-updatedAt,-createdAt,-objectId';
    queryParam['where'] = buildPackageWhereParam(env);

    LeanCloudHttpHelper.getHttp(path, queryParam, (dynamic data, String msg){
        final map  = data as Map<String,dynamic>;
        final resp = PackageResp.fromJson(map);
        final packages = resp.results; 
        var first = packages.first;
        if(first != null) {
          if(onSucc != null) onSucc(first,msg);
        }
        else {
          if(onFail != null) onFail('查无版本信息');
        }
    }, onFail);

  }

  // 构建where字段
  static String buildPackageWhereParam(LeanCloudEnv env) {

    var whereMap = Map<String,dynamic>();
    var platformValue = 'unknow';

    if (TargetPlatform.iOS == defaultTargetPlatform) {
      platformValue = 'ios';
    } else if (TargetPlatform.android == defaultTargetPlatform) {
      platformValue = 'android';
    }

    whereMap['platform'] = platformValue;

    var envValue = 'unknow';
    if(LeanCloudEnv.dev == env) {
      envValue = 'dev';
    }
    else if(LeanCloudEnv.test == env) {
      envValue = 'test';
    }
    else if(LeanCloudEnv.product == env) {
      envValue = 'product';  
    }
    else {
      envValue = 'unknow';
    }

    whereMap['env'] = envValue;

    var whereStr = json.encode(whereMap);

    debugPrint(whereStr);
    return whereStr;
  }


}