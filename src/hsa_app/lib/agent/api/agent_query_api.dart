// 查询 API
import 'package:flutter/material.dart';
import 'package:hsa_app/debug/debug_api.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/model/all_model.dart';
import 'package:hsa_app/debug/model/electricity_price.dart';
import 'package:hsa_app/debug/response/all_resp.dart';

// 查询成功返回
typedef AgentQuerySuccCallback = void Function(NearestRunningData data, String msg);
// 查询失败返回
typedef AgentQueryFailCallback = void Function(String msg);

class AgentQueryAPI {

  // 单条查询 终端最近数据 
  static void qureryTerminalNearestRunningData(BuildContext context, { 
      @required String address, // 终端地址
      @required bool isBase,       // 是否是标准版,默认标准版
      AgentQuerySuccCallback onSucc, // 成功回调
      AgentQueryFailCallback onFail, // 失败回调
    }) {

        final path = DebugAPI.liveDataHost + '/v1/NearestRunningData/' + address + '/MultipleAFNFnpn';
        // 通用参数
        var param = [
        'AFN0C.F1.p0', // 硬件版本软件版本
        'AFN0C.F10.p0', // 励磁电流
        'AFN0C.F11.p0', // 开度、相对水位、转速
        'AFN0C.F13.p0', // 温度路数、温度值
        'AFN0C.F20.p0', // 当日发电量
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

        DebugHttpHelper.httpPOST(path, { '' : param }, (map,msg){
          
          var resp = NearestRunningDataResp.fromJson(map, address, isBase: true,price: ElectricityPrice(
            peakElectricityPrice:1.0,
            spikeElectricityPrice: 2.0,
            flatElectricityPrice: 3.0,
            valleyElectricityPrice: 4.0,
          ));
          if(onSucc != null) onSucc(resp.data,msg);
          
        }, onFail);

  }



}