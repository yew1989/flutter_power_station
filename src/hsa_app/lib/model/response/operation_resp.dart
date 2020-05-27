import 'package:hsa_app/model/model/operation.dart';
// 用户权限返回
class OperationResp {
	int code;
	int httpCode;
  // 权限数据体
	Operation data;
	OperationResp({this.code, this.httpCode, this.data});
	OperationResp.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		httpCode = json['httpCode'];
		data = json['data'] != null ?  Operation.fromJson(json['data']) : null;
	}
  
}