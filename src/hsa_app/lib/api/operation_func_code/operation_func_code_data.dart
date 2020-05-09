class OperationFuncCodeResp {
	int code;
	int httpCode;
	OperationFuncCodeData data;

	OperationFuncCodeResp({this.code, this.httpCode, this.data});

	OperationFuncCodeResp.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		httpCode = json['httpCode'];
		data = json['data'] != null ? new OperationFuncCodeData.fromJson(json['data']) : null;
	}
  
}

class OperationFuncCodeData {
	List<String> accountAllRolesContainedFuncCodes;
	Map<String, dynamic> hyStationContainedFuncCodeDictionary;

	OperationFuncCodeData({this.accountAllRolesContainedFuncCodes, this.hyStationContainedFuncCodeDictionary});

	OperationFuncCodeData.fromJson(Map<String, dynamic> json) {
		accountAllRolesContainedFuncCodes    = json['accountAllRolesContainedFuncCodes'].cast<String>();
		hyStationContainedFuncCodeDictionary = json['hyStationContainedFuncCodeDictionary'] != null ?  json['hyStationContainedFuncCodeDictionary'] : Map<String, dynamic>();
	}

}
