import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/debug_share_instance.dart';
import 'package:hsa_app/debug/model/account_info.dart';
import 'package:hsa_app/debug/model/area_info.dart';
import 'package:hsa_app/debug/model/erc_flag_type.dart';
import 'package:hsa_app/debug/model/terminal_alarm_event.dart';
import 'package:hsa_app/util/encrypt.dart';

// 返回回调 : 

// 获取账户信息
typedef AccountInfoCallback = void Function(AccountInfo account);
// 地址信息列表
typedef AreaInfoCallback = void Function(List<AreaInfo> areas);
// ERCFlag类型列表
typedef ERCFlagTypeListCallback = void Function(List<ERCFlagType> types);
// 告警事件列表
typedef AlertEventListCallback = void Function(List<TerminalAlarmEvent> events);

class DebugAPI {

  // 基础信息地址
  static final restHost = 'http://192.168.16.2:8281';
  // 实时数据地址
  static final liveDataHost = 'http://192.168.16.2:8282';

  // 固定应用ID AppKey 由平台下发
  static final appKey = '3a769958-098a-46ff-a76a-de6062e079ee'; 

  // 登录接口
  static void login(BuildContext context,{@required String name,@required String pswd,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {

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
      debugPrint(e.toString());
      return;
    }

  }

  // 获取帐号信息
  static void getAccountInfo({@required String name,AccountInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
    
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
  static void getAreaList({@required String rangeLevel,AreaInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
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

  // 获取告警事件类型列表 type = 0 水轮机 1 生态下泄
  static void getErcFlagTypeList({@required String type,ERCFlagTypeListCallback onSucc,DebugHttpFailCallback onFail}) async {
    // 输入检查
    if(type == null) {
      if(onFail != null) onFail('终端告警类型参数缺失');
      return;
    }
    
    // 获取帐号信息地址
    final path = restHost + '/v1/EnumAlarmEventERC/' + '$type';
    
    DebugHttpHelper.httpGET(path, null, (map,_){

      var resp = ERCFlagTypeResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

  // 获取终端告警列表
    static void getTerminalAlertList(
  {
  String seachAnchorDateTime,
  String searchDirection,
  String startDateTime,
  String endDateTime,
  String stationNos,
  String ercVersions,
  String eventFlags,
  String deviceTerminalType,
  String deviceTerminalHardware,
  String terminalAddress,
  String limitSize,
  bool isIncludedDetail, 
  AlertEventListCallback onSucc,DebugHttpFailCallback onFail}) async {

var param = Map<String, dynamic>();

// SeachAnchorDateTime	string	否	时间锚点
if(seachAnchorDateTime != null) {
  param['seachAnchorDateTime'] = seachAnchorDateTime;
}
// SearchDirection	string	否	Backward(上一页)或Forward(下一页) 依赖于时间锚点，默认Forward
if(searchDirection != null) {
  param['searchDirection'] = searchDirection;
}
// StartDateTime	DateTime	否	起始时间
if(startDateTime != null) {
  param['startDateTime'] = startDateTime;
}
// EndDateTime	DateTime	否	结束时间
if(endDateTime != null) {
  param['endDateTime'] = endDateTime;
}
// StationNos	string[]	否	电站号
if(stationNos != null) {
  param['stationNos'] = stationNos;
}
// ErcVersions	byte[]	否	告警版本号
if(ercVersions != null) {
  param['ercVersions'] = ercVersions;
}
// EventFlags	ushort[]	否	告警标识，前置条件：ErcVersions
if(eventFlags != null) {
  param['eventFlags'] = eventFlags;
}
// DeviceTerminalType	DeviceTerminalTypeEnum	否	设备类型
if(deviceTerminalType != null) {
  param['deviceTerminalType'] = deviceTerminalType;
}
// DeviceTerminalHardware	string	否	设备版本
if(deviceTerminalHardware != null) {
  param['deviceTerminalHardware'] = deviceTerminalHardware;
}
// TerminalAddress	string	否	终端地址
if(terminalAddress != null) {
  param['terminalAddress'] = terminalAddress;
}
// LimitSize	int	否	查询条数，默认20
if(limitSize != null) {
  param['limitSize'] = limitSize;
}
// IsIncludedDetail	bool	否	是否包含详情数据，默认false
if(isIncludedDetail != null) {
  param['isIncludedDetail'] = isIncludedDetail;
}
    
// 获取帐号信息地址
final path = liveDataHost + '/v1/TerminalAlarmEvent';

DebugHttpHelper.httpGET(path, param, (map,_){
  
    var resp = TerminalAlarmEventResp.fromJson(map);
    if(onSucc != null) onSucc(resp.data.rows);
      
  }, onFail);
}
  

  // 历史水位
  static void waterLevelPoints({
    @required String address,
    @required String startDate,
    @required String endDate,
    @required int minuteInterval,
    @required String hyStationWaterStageType,
  
  
  ERCFlagTypeListCallback onSucc,DebugHttpFailCallback onFail}) async {
    // 输入检查
    if(address == null) {
      if(onFail != null) onFail('参数缺失');
      return;
    }

    if(startDate == null) {
      if(onFail != null) onFail('参数缺失');
      return;
    }

    if(endDate == null) {
      if(onFail != null) onFail('参数缺失');
      return;
    }

    if(hyStationWaterStageType == null) {
      if(onFail != null) onFail('参数缺失');
      return;
    }
    
    // 获取帐号信息地址
    final path = liveDataHost + '/v1/HyStationWaterStage/' + address;
    
    var param = Map<String, dynamic>();

    if(startDate != null) {
      param['startDate'] = startDate;
    }
    if(endDate != null) {
      param['endDate'] = endDate;
    }
    if(minuteInterval != null) {
      param['minuteInterval'] = minuteInterval.toString();
    }
    if(hyStationWaterStageType != null) {
      param['hyStationWaterStageType'] = hyStationWaterStageType;
    }

    DebugHttpHelper.httpGET(path, param, (map,_){

      // var resp = ERCFlagTypeResp.fromJson(map);
      // if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

  // 历史有功
  static void activePowerPoints({@required String type,ERCFlagTypeListCallback onSucc,DebugHttpFailCallback onFail}) async {
    // 输入检查
    if(type == null) {
      if(onFail != null) onFail('终端告警类型参数缺失');
      return;
    }
    
    // 获取帐号信息地址
    final path = restHost + '/v1/EnumAlarmEventERC/' + '$type';
    
    DebugHttpHelper.httpGET(path, null, (map,_){

      var resp = ERCFlagTypeResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }




}