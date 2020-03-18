import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/debug_share_instance.dart';
import 'package:hsa_app/util/encrypt.dart';

import 'model/all_model.dart';
import 'response/all_resp.dart';

// 返回回调 : 
// 获取账户信息
typedef AccountInfoCallback = void Function(AccountInfo account);
// 地址信息列表
typedef AreaInfoCallback = void Function(List<AreaInfo> areas);
// 地址信息列表
typedef StationListCallback = void Function(Data stations);
// 地址信息列表
typedef StationInfoCallback = void Function(StationInfo stationInfo);

class DebugAPI {

  // 主机地址
  static final restHost = 'http://192.168.16.2:8281';

  // 固定应用ID AppKey 由平台下发
  static final appKey = '3a769958-098a-46ff-a76a-de6062e079ee'; 

  // 登录接口
  static void login(BuildContext context,{String name, String pswd,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {

    // 输入检查
    if(name == null || name.length == 0) {
      if(onFail != null) onFail('请输入用户名');
      return;
    }
    if(pswd == null || pswd.length == 0) {
      if(onFail != null) onFail('请输入密码');
      return;
    }

    // 加密
    final plain = name + ':' + appKey + ':' + pswd;
    final encrypted = await LDEncrypt.encryptedRSA(context,plain);

    // 检测网络
    var isReachable = await DebugHttpHelper.isReachablity();
    if (isReachable == false) {
        if(onFail != null) onFail('网络异常,请检查网络');
        return;
    }

    // 登录路径地址
    final path = restHost + '/v1/Account/AuthenticationToken/Apply/' + appKey;

    // 发起请求
    var dio = DebugHttpHelper.initDio();
    try {
      Response response = await dio.post(path,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: DebugHttpHelper.recvTimeOutSeconds,
          sendTimeout: DebugHttpHelper.sendTimeOutSeconds,
        ),
        data: {'':encrypted},
      );
      if (response == null) {
        if(onFail != null)  onFail('网络异常,请检查网络');
        return;
      }
      if (response.statusCode != 200) {
        if(onFail != null) onFail('登录失败 ( ' + response.statusCode.toString() + ' )');
        return;
      }

      // 存储 auth 到 全局单例
      final header = response.headers;
      final auth = header.value('set-authorization');
      DebugShareInstance.getInstance().auth = auth;

      if(onSucc != null) onSucc(auth,'登录成功');
      return;

    } catch (e) {
      if(onFail != null) onFail('登录失败');
      return;
    }

  }

  // 获取帐号信息
  static void getAccountInfo({String name,AccountInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    // 输入检查
    if(name == null || name.length == 0) {
      if(onFail != null) onFail('请输入用户名');
      return;
    }
    
    // 获取帐号信息地址
    final path = restHost + '/v1/Account/' + name;
    
    DebugHttpHelper.httpGET(path, null, (map,_){

      var resp = AccountInfoResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);

    }, onFail);

  }

  
  // 获取省份列表信息
  static void getAreaList({String rangeLevel,AreaInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
        // 输入检查
    if(rangeLevel == null) {
      if(onFail != null) onFail('地址范围参数缺失');
      return;
    }
    
    // 获取帐号信息地址
    final path = restHost + '/v1/City/CurrentAccountHyStation/' + '$rangeLevel';
    
    DebugHttpHelper.httpGET(path, null, (map,_){

      var resp = AreaInfoResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

  
  // 修改登录密码
  static void resetLoginPassword(BuildContext context,{String accountName,String oldLoginPwd,String newLoginPwd,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
    // 输入检查
    if(oldLoginPwd == null) {
      if(onFail != null) onFail('请输入旧密码');
      return;
    }
    if(newLoginPwd == null) {
      if(onFail != null) onFail('请输入新密码');
      return;
    }
    final oldPwd = await LDEncrypt.encryptedRSA(context,oldLoginPwd);
    final newPwd = await LDEncrypt.encryptedRSA(context,newLoginPwd);
    // 获取修改密码地址
    final path = restHost + '/v1/Account/'+'$accountName'+'/Reset/LoginPassword';

    var param = {'oldLoginPwd':oldPwd,'newLoginPwd':newPwd};
    
    DebugHttpHelper.httpPATCH(path, param, (map,_){

      if(onSucc != null) onSucc('','密码修改成功');
      
    }, onFail);
  }

  // 获取电站列表信息
  static void getStationList({bool isIncludeCustomer,bool isIncludeWaterTurbine,bool isIncludeFMD,bool isIncludeLiveLink,
      String partStationName,String partStationNamePinYin,String proviceAreaCityNameOfDotSeparated,
      List<String> arrayOfCustomerNoOptAny, List<String> arrayOfStationNoOptAny,
      int page,int pageSize, StationListCallback onSucc,DebugHttpFailCallback onFail}) async {
       
    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否要包含生态下泄信息
    if(isIncludeFMD != null){
      param['isIncludeFMD'] = isIncludeFMD;
    }

    //结果中是否要包含监控地址
    if(isIncludeLiveLink != null){
      param['isIncludeLiveLink'] = isIncludeLiveLink;
    }

    //部分电站名 模糊匹配
    if(partStationName != null){
      param['partStationName'] = partStationName;
    }

    //部分电站拼音 模糊匹配
    if(partStationNamePinYin != null){
      param['partStationNamePinYin'] = partStationNamePinYin;
    }

    //用.号分隔的电站所在地（省.地区.市）（三段模式匹配,*为通配符)
    if(proviceAreaCityNameOfDotSeparated != null){
      param['proviceAreaCityNameOfDotSeparated'] = proviceAreaCityNameOfDotSeparated;
    }

    //客户号数组 匹配数组中的任一值
    if(arrayOfCustomerNoOptAny != null){
      param['arrayOfCustomerNoOptAny'] = arrayOfCustomerNoOptAny;
    }

    //电站号数组 匹配数组中的任一值
    if(arrayOfStationNoOptAny != null){
      param['arrayOfStationNoOptAny'] = arrayOfStationNoOptAny;
    }

    param['page'] = (page != null ? page : 1 );
    param['pageSize'] = (pageSize != null ? pageSize : 10 );

    // 获取电站列表信息地址
    final path = restHost + '/v1/HydropowerStation';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationListResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

  // 获取水轮机组信息
  static void getWaterTurbineList({String stationNo,bool isIncludeCustomer,bool isIncludeWaterTurbine,
    bool isIncludeFMD,bool isIncludeLiveLink,StationInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
        // 输入检查
    if(stationNo == null) {
      if(onFail != null) onFail('');
      return;
    }

    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否要包含生态下泄信息
    if(isIncludeFMD != null){
      param['isIncludeFMD'] = isIncludeFMD;
    }

    //结果中是否要包含监控地址
    if(isIncludeLiveLink != null){
      param['isIncludeLiveLink'] = isIncludeLiveLink;
    }

    
    // 获取帐号信息地址
    final path = restHost + '/v1/HydropowerStation/' + '$stationNo';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationInfoResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

   //操作电站关注/取消关注
  static void setFavorite({String stationNo,bool isFavorite,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
        // 输入检查
    if(stationNo == null) {
      if(onFail != null) onFail('错误电站');
      return;
    }
    
   
    final path = restHost + '/v1/HydropowerStation/' + '$stationNo'+'/SetFavorite/'+'$isFavorite';
    
    DebugHttpHelper.httpPUT(path, null, (map,_){

      if(onSucc != null) onSucc('',isFavorite ? '关注成功':'取消成功');
      
    }, onFail);
  }

  //取当前帐号关注的电站号列表
  static void currentAccountFavoriteStationNos({DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    final path = restHost + '/v1/HydropowerStation/CurrentAccountFavoriteStationNos';
    
    DebugHttpHelper.httpPUT(path, null, (map,_){

      if(onSucc != null) onSucc('','');
      
    }, onFail);
  }
}