// 查询 API
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/api_helper.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/response/all_resp.dart';

// 查询成功返回
typedef AgentQuerySuccCallback = void Function(NearestRunningData data, String msg);
// 查询失败返回
typedef AgentQueryFailCallback = void Function(String msg);

class AgentQueryAPI {

  // 召测试在线终端的实时运行数据
  static void remoteMeasuringRunTimeData(String terminalAddress,bool isBase) {

    var url =  API.agentHost + '/v1/Cmd/Send/' + terminalAddress + '/AFN0C_Combine/';
    url += 'f10p0,';      // 励磁板信息 励磁电流
    url += 'f11p0,';      // 开度、相对水位、转速,非电气量
    url += 'f13p0,';      // 温度路数、温度值
    url += 'f20p0,';      // 当日 有功 无功
    url += 'f21p0,';      // 当月 有功 无功
    url += 'f22p0,';      // 累计 有功 无功
    url += 'f24p0,';      // 开关机状态,是否支持远程、是否自动、智能方案
    url += isBase == true ? 'f9p0':'f30p0'; // 电气量、电压电流 电气量

    HttpHelper.httpPOST(url, null, null, null);

    // debugPrint('实时运行召测中:' + DateTime.now().toString() + '  '  + terminalAddress + '  ' + (isBase ? '基础版' : '标准版') + '   ');
  }

  // 仅召测电量和电气参数 - For 电站概要页
  static void remoteMeasuringElectricParam(String terminalAddress,bool isBase) {

    var url =  API.agentHost + '/v1/Cmd/Send/' + terminalAddress + '/AFN0C_Combine/';
    url += 'f20p0,';                        // 当日发电量 用于计算金额
    url += isBase == true ? 'f9p0':'f30p0'; // 电气量、电压电流 电气量
    
    HttpHelper.httpPOST(url, null, null, null);

    // debugPrint('电气参数召测中:' + DateTime.now().toString() + '  '  + terminalAddress + '  ' + (isBase ? '基础版' : '标准版') + '   ');

  }


  static String createPath(String terminalAddress,String afnFunc) {
    return API.agentHost + '/v1/Cmd/Send/' + terminalAddress + '/' +  afnFunc  + '/0';
  }


  // 单条查询 终端最近运行数据 
  static void qureryTerminalNearestRunningData({ 
      @required String address, // 终端地址
      @required bool isBase,       // 是否是标准版,默认标准版
      ElectricityPrice price, // 电价列表
      AgentQuerySuccCallback onSucc, // 成功回调
      AgentQueryFailCallback onFail, // 失败回调
    }) {

        final path = API.liveDataHost + '/v1/NearestRunningData/' + address + '/MultipleAFNFnpn';
        // 通用参数
        var param = [
        'AFN0C.F1.p0', // 硬件版本软件版本
        'AFN0C.F10.p0', // 励磁电流
        'AFN0C.F11.p0', // 开度、相对水位、转速
        'AFN0C.F13.p0', // 温度路数、温度值
        'AFN0C.F20.p0', // 当日发电量
        'AFN0C.F21.p0', // 当月发电量
        'AFN0C.F22.p0', // 累计发电量
        'AFN0C.F24.p0', // 开关机状态、是否支持远程、是否自动、智能方案
        ];
        // 电气量、电压电流 -  BASE 特定
        if(isBase) {
          param.add('AFN0C.F9.p0');
        }
        // 电气量、电压电流 -  PRO 特定
        else {
          param.add('AFN0C.F30.p0');
        }

        HttpHelper.httpPOST(path, { '' : param }, (map,msg){
          
          var resp = NearestRunningDataResp.fromJson(map, address, isBase: isBase,price: price);
          if(onSucc != null) onSucc(resp.data,msg);
          
        }, onFail);

  }



}