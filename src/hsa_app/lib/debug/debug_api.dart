import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/model/active_power.dart';
import 'package:hsa_app/debug/model/erc_flag_type.dart';
import 'package:hsa_app/debug/model/terminal_alarm_event.dart';
import 'package:hsa_app/debug/model/water_level.dart';

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
// 地址信息列表
typedef NearestRunningDataCallback = void Function(NearestRunningData nearestRunningData);
//List
typedef ListCallback = void Function(List<String> list);
// ERCFlag类型列表
typedef ERCFlagTypeListCallback = void Function(List<ERCFlagType> types);
// 告警事件列表
typedef AlertEventListCallback = void Function(List<TerminalAlarmEvent> events);
// 水位曲线列表
typedef WaterLevelListCallback = void Function(List<WaterLevel> points);
// 有功曲线列表
typedef ActivePowerListCallback = void Function(List<ActivePower> points);
// 水轮机信息
typedef WaterTurbineCallback = void Function(WaterTurbine waterTurbines);
// 终端信息
typedef DeviceTerminalCallback = void Function(DeviceTerminal deviceTerminal);
// 终端信息
typedef TurbineCallback = void Function(List<Turbine> turbines);


class DebugAPI {

  // 基础信息地址
  static final restHost = 'http://192.168.16.2:8281';

  // 动态数据地址
  static final liveDataHost = 'http://192.168.16.2:8282';

  // 固定应用ID AppKey 由平台下发
  static final appKey = '3a769958-098a-46ff-a76a-de6062e079ee'; 


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
  static void getTerminalAlertList({
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
        int limitSize,
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
  

  static void getTurbineWaterAndPowerAndState({
    @required String stationNo,
    String seachAnchorDateTime,
    String searchDirection,
    String startDateTime,
    String endDateTime,
    String minuteInterval,
    String terminalAddress,
    String limitSize,
    TurbineCallback onSucc,DebugHttpFailCallback onFail}) async {

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
    // TerminalAddress	string	否	终端地址
    if(terminalAddress != null) {
      param['terminalAddress'] = terminalAddress;
    }
    // LimitSize	int	否	查询条数，默认20
    if(limitSize != null) {
      param['limitSize'] = limitSize;
    }

    final path = liveDataHost + '/v1/TurbineWaterAndPowerAndState/'+'$stationNo';

    DebugHttpHelper.httpGET(path,param, (map,_){
      
      var resp = TurbineResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data.turbine);

    },onFail);
  }
     

}