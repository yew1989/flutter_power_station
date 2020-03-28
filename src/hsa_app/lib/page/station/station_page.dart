import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/debug/API/debug_api_station.dart';
import 'package:hsa_app/debug/debug_api.dart';
import 'package:hsa_app/debug/model/all_model.dart';
import 'package:hsa_app/debug/model/station.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/station/device/station_device_list.dart';
import 'package:hsa_app/page/station/station_big_pool.dart';
import 'package:hsa_app/page/station/station_list_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ovprogresshud/progresshud.dart';

class StationPage extends StatefulWidget {
  
  final String stationId;

  StationPage(this.stationId);

  @override
  _StationPageState createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  
  StationInfo stationInfo = StationInfo();
  String weather = '晴';
  List<String> openLive = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    reqeustStationInfo();
    super.initState();
  }

  @override
  void dispose() {
    
    refreshController.dispose();
    Progresshud.dismiss();
    super.dispose();
  }

  // 请求电站概要
  void reqeustStationInfo() { 
    Progresshud.showWithStatus('读取数据中...');

    final stationId = widget?.stationId ?? '';

    if (stationId.length == 0) {
      Progresshud.showInfoWithStatus('获取电站信息失败');
      return;
    }
    List<String> param;
    DebugAPIStation.getStationInfo(stationNo:stationId,
      isIncludeCustomer:true,isIncludeWaterTurbine:true,isIncludeFMD:true,isIncludeLiveLink:true,onSucc: (StationInfo station) {
      
      Progresshud.dismiss();
      refreshController.refreshCompleted();

      if (station == null) return;
      EventBird().emit(AppEvent.eventGotStationInfo,station);

      setState(() {
        this.stationInfo = station;
        if(stationInfo.waterTurbines != null){
          for( int i = 0 ;stationInfo.waterTurbines.length > i; i++){
            String terminalAddress = stationInfo.waterTurbines[i]?.deviceTerminal?.terminalAddress ?? '';
            switch(stationInfo.waterTurbines[i]?.deviceTerminal?.deviceVersion){
              case 'S1-Base': 
                param =  ["AFN0C.F7.p0", "AFN0C.F9.p0", "AFN0C.F10.p0", "AFN0C.F11.p0", 
                          "AFN0C.F13.p0", "AFN0C.F24.p0", "AFN0C.F20.p0", "AFN0C.F21.p0", "AFN0C.F22.p0"] ;
              break;
              
              case 'S1-Pro':
                param = ["AFN0C.F28.p0", "AFN0C.F30.p0", "AFN0C.F10.p0", "AFN0C.F11.p0", 
                        "AFN0C.F13.p0", "AFN0C.F24.p0", "AFN0C.F20.p0", "AFN0C.F21.p0", "AFN0C.F22.p0"] ;
              break;
            }
            if(terminalAddress != ''){
              DebugAPIStation.getMultipleAFNFnpn(terminalAddress:terminalAddress,
              paramList:param,
              onSucc: (nearestRunningData){
                stationInfo.waterTurbines[i].deviceTerminal.nearestRunningData = nearestRunningData;
              },onFail: (msg){
                
              });
            }
          }
        }
        if (station.liveLinks != null) {
          station.liveLinks.map((liveLink){
            openLive.add(liveLink.m3u8Url ?? '' );
          }).toList();
        }
      });
    }, onFail: (String msg) {
      refreshController.refreshFailed();
      Progresshud.showInfoWithStatus('获取电站信息失败');
    });

    
  }

  void onTapPushToHistoryPage(StationInfo info) async {
    // final deviceIdList = info.waterTurbines.map((wt) {
    //   return wt?.deviceTerminal?.terminalAddress ?? '';
    // }).toList();
    // final addresses = deviceIdList.join(',');
    // final navTitle = info?.name ?? '';
    pushToPage(context, HistoryPage(title: '历史分析',stationInfo:info));
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
            StationBigPool(stationInfo),
            StationListHeader(weather, openLive, stationInfo.stationName),
            StationDeviceList(stationInfo),
          ],
        ),
      ),
    );
  }
}
