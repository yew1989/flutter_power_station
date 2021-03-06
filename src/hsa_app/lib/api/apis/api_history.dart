import 'package:flutter/material.dart';
import 'package:hsa_app/api/api_helper.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/model/response/all_resp.dart';


class APIHistory{
  
  // 历史水位
  static void waterLevelPoints({
    @required String address,
    @required String startDate,
    @required String endDate,
    @required int minuteInterval,
    @required String hyStationWaterStageType,
    WaterLevelListCallback onSucc,HttpFailCallback onFail}) async {

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
    final path = API.liveDataHost + '/v1/HyStationWaterStage/' + address;
    
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

    HttpHelper.httpGET(path, param, (map,_){

      final resp = WaterLevelResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data.rows);
      
    }, onFail);
  }


  // 历史电能列表
  static void activePowerPoints({
    @required String address,
    @required String startDate,
    @required String endDate,
    ActivePowerListCallback onSucc,HttpFailCallback onFail}) async {

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
    final path = API.liveDataHost + '/v1/StatisticalPower/TurbineTotal/' + address;
    
    var param = Map<String, dynamic>();

    if(startDate != null) {
      param['startDate'] = startDate;
    }
    if(endDate != null) {
      param['endDate'] = endDate;
    }

    HttpHelper.httpGET(path, param, (map,_){

      final resp = ActivePowerResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data.rows);
      
    }, onFail);
  }
  

   // 历史月电能列表
  static void activePowerPointsMonth({
    @required String stationNos,
    String terminalAddress,
    @required String startDate,
    @required String endDate,
    StatisticalPowerListCallback onSucc,HttpFailCallback onFail}) async {

    // 输入检查
    if(stationNos == null) {
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
    final path = API.liveDataHost + '/v1/StatisticalPower/Day';
    
    var param = Map<String, dynamic>();

    if(startDate != null) {
      param['StartDate'] = startDate;
    }
    if(endDate != null) {
      param['EndDate'] = endDate;
    }
    if(stationNos != null) {
      param['StationNos'] = stationNos;
    }
    if(terminalAddress != null) {
      param['TerminalAddress'] = terminalAddress;
    }

    HttpHelper.httpGET(path, param, (map,_){

      final resp = StatisticalPowerResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data.statisticalPowerList);
      
    }, onFail);
  }

   // 历史年电能列表
  static void activePowerPointsYear({
    @required String stationNos,
    String terminalAddress,
    @required List<int> years,
    StatisticalPowerListCallback onSucc,HttpFailCallback onFail}) async {

    // 输入检查
    if(stationNos == null) {
      if(onFail != null) onFail('参数缺失');
      return;
    }

    if(years.isEmpty) {
      if(onFail != null) onFail('参数缺失');
      return;
    }

    // 获取帐号信息地址
    final path = API.liveDataHost + '/v1/StatisticalPower/Month';
    
    var param = Map<String, dynamic>();

    if(years != null) {
      param['years'] = years;
    }
    if(stationNos != null) {
      param['stationNos'] = stationNos;
    }
    if(terminalAddress != null) {
      param['terminalAddress'] = terminalAddress;
    }

    HttpHelper.httpGET(path, param, (map,_){

      final resp = StatisticalPowerYearResp.fromJson(map);
      if(onSucc != null) onSucc(resp.statisticalPowerList);
      
    }, onFail);
  }
}