// 用户权限相关数据体
class Operation {
  // 用户权限
	List<String> accountAllRolesContainedFuncCodes;
  // 电站权限
	Map<String, dynamic> hyStationContainedFuncCodeDictionary;
	Operation({this.accountAllRolesContainedFuncCodes, this.hyStationContainedFuncCodeDictionary});
	Operation.fromJson(Map<String, dynamic> json) {
		accountAllRolesContainedFuncCodes    = json['accountAllRolesContainedFuncCodes'].cast<String>();
		hyStationContainedFuncCodeDictionary = json['hyStationContainedFuncCodeDictionary'] != null ?  json['hyStationContainedFuncCodeDictionary'] : Map<String, dynamic>();
	}
}