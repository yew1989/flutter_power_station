import 'package:flutter/material.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/station/device/station_device_list.dart';
import 'package:hsa_app/page/station/station_big_pool.dart';
import 'package:hsa_app/page/station/station_list_header.dart';
import 'package:hsa_app/page/station/station_weather_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:ovprogresshud/progresshud.dart';

class StationPage extends StatefulWidget {
  final String title;
  final String stationId;

  StationPage(this.title, this.stationId);

  @override
  _StationPageState createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  StationInfo stationInfo = StationInfo();
  String weather = '晴';
  List<String> openLive = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    reqeustStationInfo();
    UMengAnalyticsService.enterPage('电站概要');
    super.initState();
  }

  @override
  void dispose() {
    Progresshud.dismiss();
    UMengAnalyticsService.exitPage('电站概要');
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

  void onTapPushToHistoryPage() async {
   final deviceIdList = stationInfo.devices.map((device) {
      return device?.address ?? '';
    }).toList();
    final addresses = deviceIdList.join(',');
    final navTitle = stationInfo?.name ?? '';
    pushToPage(context, HistoryPage(title: navTitle,address: addresses));
  }

  // 同步天气数据
  void syncWeaher(String weather) async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      this.weather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Stack(children: [
        stationInfo?.geo == null
            ? Container()
            : StationWeatherWidget(
                geo: stationInfo.geo,
                onWeahterResponse: (weather) => syncWeaher(weather)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(widget.title ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20)),
            actions: <Widget>[
              GestureDetector(
                  onTap: stationInfo.devices == null ? null : () => onTapPushToHistoryPage(),
                  child: Center(
                      child: Text('历史曲线',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)))),
              SizedBox(width: 20),
            ],
          ),
          body: Container(
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
          ),
        ),
      ]),
    );
  }
}
