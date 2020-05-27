import 'package:flutter/material.dart';
import 'package:hsa_app/api/api_helper.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/operation_helper.dart';
import 'package:hsa_app/model/response/all_resp.dart';

// 权限相关
class APIOperation {
  
  // 获取用户权限功能码
  static void getOperationFuncCode({@required Function onFinish,@required String accountName}) {
    if(accountName == null) return;
    final path = API.baseHost + '/v1/OperationFuncCode/RelationAccount/' + '$accountName';
    HttpHelper.httpGET(path, null, (map,_){
      var resp = OperationResp.fromJson(map);
      if(resp.code != 0) {
        if(onFinish != null) onFinish();
        return;
      }
      final operation = resp.data;
      OperationHelper.getInstance().operation = operation;
      if(onFinish != null) onFinish();
    }, (msg){
      if(onFinish != null) onFinish();
    });
  }
}