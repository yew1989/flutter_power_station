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
    if(partStationNamePinYin != null ){
      param['partStationNamePinYin'] = partStationNamePinYin;
    }

    //用.号分隔的电站所在地（省.地区.市）（三段模式匹配,*为通配符)
    if(proviceAreaCityNameOfDotSeparated != '' && proviceAreaCityNameOfDotSeparated != null){
      param['proviceAreaCityNameOfDotSeparated'] = proviceAreaCityNameOfDotSeparated;
    }

    //客户号数组 匹配数组中的任一值
    if(arrayOfCustomerNoOptAny != [] && arrayOfCustomerNoOptAny != null){
      param['arrayOfCustomerNoOptAny'] = arrayOfCustomerNoOptAny;
    }

    //电站号数组 匹配数组中的任一值
    if(arrayOfStationNoOptAny != [] && arrayOfStationNoOptAny != null){
      param['arrayOfStationNoOptAny'] = arrayOfStationNoOptAny;
    }

    param['page'] = (page != null ? page : 1 );
    param['pageSize'] = (pageSize != null ? pageSize : 20 );

    // 获取电站列表信息地址
    final path = restHost + '/v1/HydropowerStation';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationListResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
    }, onFail);
  }

  //单条电站信息
  static void getStationInfo({String stationNo,
    bool isIncludeCustomer,bool isIncludeWaterTurbine,bool isIncludeFMD,bool isIncludeLiveLink,
    StationInfoCallback onSucc,DebugHttpFailCallback onFail})async {

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


    // 获取电站列表信息地址
    final path = restHost + '/v1/HydropowerStation/' + '$stationNo';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationInfoResp.fromJson(map);
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
    WaterLevelListCallback onSucc,DebugHttpFailCallback onFail}) async {

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

      final resp = WaterLevelResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data.rows);
      
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


  // 历史电能列表
  static void activePowerPoints({
    @required String address,
    @required String startDate,
    @required String endDate,
    ActivePowerListCallback onSucc,DebugHttpFailCallback onFail}) async {

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

    // 获取帐号信息地址
    final path = liveDataHost + '/v1/StatisticalPower/TurbineTotal/' + address;
    
    var param = Map<String, dynamic>();

    if(startDate != null) {
      param['startDate'] = startDate;
    }
    if(endDate != null) {
      param['endDate'] = endDate;
    }

    DebugHttpHelper.httpGET(path, param, (map,_){

      final resp = ActivePowerResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data.rows);
      
    }, onFail);
  }

     

  //取当前帐号关注的电站号列表
  static void currentAccountFavoriteStationNos({DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    final path = restHost + '/v1/HydropowerStation/CurrentAccountFavoriteStationNos';
    
    DebugHttpHelper.httpPUT(path, null, (map,_){

      if(onSucc != null) onSucc('','');
      
    }, onFail);
  }

  //取终端最近运行时通讯的数据(多)
  static void getMultipleAFNFnpn({String terminalAddress,List<String> paramList,NearestRunningDataCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    final path = liveDataHost + '/v1/NearestRunningData/'+'$terminalAddress'+'/MultipleAFNFnpn';
    
    var param = {'':paramList};

    DebugHttpHelper.httpPOST(path, param, (map,_){

      var resp = NearestRunningDataResp.fromJson(map,terminalAddress);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

  //获取关注电站的电站编号数组
  static void getFavoriteStationNos({ListCallback onSucc,DebugHttpFailCallback onFail}) async {

    final path = restHost + '/v1/HydropowerStation/CurrentAccountFavoriteStationNos';
    
    DebugHttpHelper.httpGET(path, null, (map,_){
      //List<String> list = [];
      var resp =  map['data'].cast<String>();
      if(onSucc != null) onSucc(resp);
      
    }, onFail);
  }

  static void getWaterTurbinesInfo({String terminalAddress,
    bool isIncludeCustomer,bool isIncludeWaterTurbine,bool isIncludeHydropowerStation,
    DeviceTerminalCallback onSucc,DebugHttpFailCallback onFail})async {

    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否含有电站信息
    if(isIncludeHydropowerStation != null){
      param['isIncludeHydropowerStation'] = isIncludeHydropowerStation;
    }


    // 获取电站列表信息地址
    final path = restHost + '/v1/DeviceTerminal/' + '$terminalAddress';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp =  DeviceTerminal.fromJson(map);
      if(onSucc != null) onSucc(resp);
    }, onFail);
  }
  
}