import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent_timer_tasker.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/station/caiyun_weather.dart';
import 'package:hsa_app/page/station/device/station_device_list.dart';
import 'package:hsa_app/page/station/station_big_pool.dart';
import 'package:hsa_app/page/station/station_list_header.dart';
import 'package:hsa_app/service/life_cycle/lifecycle_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ovprogresshud/progresshud.dart';

class StationPage extends StatefulWidget {
  
  final String stationId;
  final CaiyunWeatherData weather;
  StationPage(this.stationId, this.weather);

  @override
  _StationPageState createState() => _StationPageState();
}

class _StationPageState extends LifecycleState<StationPage> {
  
  StationInfo stationInfo = StationInfo();
  
  List<LiveLink> liveLinkList = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // 实时有功和收益任务
  AgentStationInfoDataLoopTimerTasker stationTasker;
  List<String> terminalAddressList = List<String>();
  List<bool> isBaseList = List<bool>();
  List<num> profitList = [0.0,0.0];

 @override
  void onResume() {
    super.onResume();
    getRealtimeData();
  }

  @override
  void onPause() {
    stationTasker?.dispose();
    Progresshud.dismiss();
    super.onPause();
  }

  @override
  void initState() {
    reqeustStationInfo();
    super.initState();
  }

  @override
  void dispose() {
    refreshController?.dispose();
    stationTasker?.dispose();
    Progresshud.dismiss();
    super.dispose();
  }

  // 过滤掉没有绑定过的设备
  StationInfo filtUnBindDevices(StationInfo station) {
    var result = station;
    List<WaterTurbine> turbines = [];
    for (var turbine in station.waterTurbines) {
      if(turbine.deviceTerminal != null) {
        turbines.add(turbine);
      }
    }
    if(station.waterTurbines.length > 0) {
       result.waterTurbines = turbines;
    }
    return result;
  }

  // 请求电站概要
  void reqeustStationInfo() { 

    stationTasker?.dispose();

    Progresshud.showWithStatus('读取数据中...');

    final stationId = widget?.stationId ?? '';

    if (stationId.length == 0) {
      Progresshud.showInfoWithStatus('获取电站信息失败');
      return;
    }
    List<String> param;
    APIStation.getStationInfo(stationNo:stationId,
      isIncludeCustomer:true,isIncludeWaterTurbine:true,isIncludeFMD:true,isIncludeLiveLink:true,onSucc: (StationInfo station) {
      
      station  = filtUnBindDevices(station);

      Progresshud.dismiss();
      refreshController.refreshCompleted();

      if (station == null) return;
      eventBird?.emit(AppEvent.eventGotStationInfo,station);
      if(mounted) {
        setState(() {
          this.stationInfo = station;
          if(stationInfo.waterTurbines != null){
            for( int i = 0 ;stationInfo.waterTurbines.length > i; i++){

              String terminalAddress = stationInfo.waterTurbines[i]?.deviceTerminal?.terminalAddress ?? '';
              terminalAddressList.add(terminalAddress);
              bool isBase = true;
              switch(stationInfo.waterTurbines[i]?.deviceTerminal?.deviceVersion){
                case 'S1-Base': 
                  param =  ["AFN0C.F7.p0", "AFN0C.F9.p0", "AFN0C.F10.p0", "AFN0C.F11.p0", 
                            "AFN0C.F13.p0", "AFN0C.F24.p0", "AFN0C.F20.p0", "AFN0C.F21.p0", "AFN0C.F22.p0"] ;
                  isBase = true;
                break;
                
                case 'S1-Pro':
                  param = ["AFN0C.F28.p0", "AFN0C.F30.p0", "AFN0C.F10.p0", "AFN0C.F11.p0",
                          "AFN0C.F13.p0", "AFN0C.F24.p0", "AFN0C.F20.p0", "AFN0C.F21.p0", "AFN0C.F22.p0"] ;
                  isBase = false;
                break;
              }
              isBaseList.add(isBase);
              if(terminalAddress != ''){
                APIStation.getMultipleAFNFnpn(terminalAddress:terminalAddress,
                paramList:param,
                isBase:isBase,
                onSucc: (nearestRunningData){
                  stationInfo.waterTurbines[i].deviceTerminal.nearestRunningData = nearestRunningData;
                },onFail: (msg){
                  
                });
              }
            }
          }
          if (station.liveLinks != null) {
            liveLinkList = station.liveLinks;
          }
        });
      }
      getRealtimeData();
    }, onFail: (String msg) {
      refreshController.refreshFailed();
      Progresshud.showInfoWithStatus('获取电站信息失败');
    });
  }
  
  //实时数据获取
  void getRealtimeData() async{
    stationTasker?.dispose();
    await Future.delayed(Duration(milliseconds: 500)); 
    if(this.stationInfo.waterTurbines == null) return;
    stationTasker = AgentStationInfoDataLoopTimerTasker();
    stationTasker.listen(
      this.stationInfo,
      this.stationInfo?.isAllowHighSpeedNetworkSwitching ?? false,
      AppConfig.getInstance().deviceQureyTimeInterval,(stationInfo){
      if(mounted) {
        setState(() {
          // 若开启此处,用于假数据调试动画
          // this.stationInfo = AgentFake.fakeStationInfo(stationInfo);
          this.stationInfo = stationInfo;
          profitList.add(stationInfo.totalMoney);
          if(profitList.length > 2){
            profitList.removeAt(0);
          }
          eventBird?.emit('REFLASH_DATA');
        });
        eventBird?.emit(AppEvent.onRefreshProfit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: SmartRefresher(
        header: appRefreshHeader(),
        enablePullDown: true,
        onRefresh: reqeustStationInfo,
        controller: refreshController,
        child: ListView(
          children: <Widget>[
            StationBigPool(stationInfo:stationInfo,profitList:profitList),
            StationListHeader(widget.weather.name, liveLinkList, stationInfo.stationName),
            StationDeviceList(stationInfo),
          ],
        ),
      ),
    );
  }
}
