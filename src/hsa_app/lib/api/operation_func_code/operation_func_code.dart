import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/api_helper.dart';
import 'package:hsa_app/api/operation_func_code/operation_func_code_data.dart';
import 'package:hsa_app/api/operation_func_code/operation_manager.dart';

class OperationFuncCode {
  
  static void getOperationFuncCode({@required String accountName}) {
    if(accountName == null) return;
    final path = API.baseHost + '/v1/OperationFuncCode/RelationAccount/' + '$accountName';
    HttpHelper.httpGET(path, null, (map,_){
      var resp = OperationFuncCodeResp.fromJson(map);
      if(resp.code != 0) return;
      final data = resp.data;
      OperationManager.getInstance().data = data;
    }, null);
  }
}