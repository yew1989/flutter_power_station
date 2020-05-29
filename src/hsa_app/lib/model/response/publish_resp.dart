// APP版本发布返回数据体
import 'package:hsa_app/model/model/all_model.dart';

class PublishResp {
	int code;
	int httpCode;
  // 权限数据体
	Publish data;
	PublishResp({this.code, this.httpCode, this.data});
	PublishResp.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		httpCode = json['httpCode'];
		data = json['data'] != null ?  Publish.fromJson(json['data']) : null;
	}
  
}