import 'package:flutter/material.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/station/device/station_device_list.dart';
import 'package:hsa_app/page/station/station_big_pool.dart';
import 'package:hsa_app/page/station/station_list_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/components/public_tool.dart';
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

    API.stationInfo(stationId, (StationInfo station) {
      
      Progresshud.dismiss();
      refreshController.refreshCompleted();

      if (station == null) return;

      EventBird().emit(AppEvent.eventGotStationInfo,station);

      setState(() {
        this.stationInfo = station;
        if (station.openlive != null) {
          this.openLive = station.openlive;
        }
      });

    }, (String msg) {
      refreshController.refreshFailed();
      Progresshud.showInfoWithStatus('获取电站信息失败');
    });
  }

  void onTapPushToHistoryPage(StationInfo info) async {
   final deviceIdList = info.devices.map((device) {
      return device?.address ?? '';
    }).toList();
    final addresses = deviceIdList.join(',');
    final navTitle = info?.name ?? '';
    pushToPage(context, HistoryPage(title: navTitle,address: addresses));
  }

  void syncWeaher(String weather) async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      this.weather = weather;
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
                  StationBigPool(stationInfo),
                  StationListHeader(weather, openLive, stationInfo.name),
                  StationDeviceList(stationInfo),
                ],
              ),
            ),
          );
  }
}
