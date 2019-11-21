import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/home/logic/home_logic.dart';
import 'package:hsa_app/page/home/view/home_banner.dart';
import 'package:hsa_app/page/home/view/home_search_bar.dart';
import 'package:hsa_app/page/home/view/home_station_widget.dart';

class HomePageOld2 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageOld2> {

  TextEditingController searchEditController = TextEditingController();
  ScrollController scrollController = ScrollController();
  static const double kSerchBarHeight = 50;

  // 原始从服务器上下拉的电站列表数据
  List<Station> rawStations = [];
  // UI 上展示的电站列表数据,带有分节
  List<StationSection> sectionStations = [];
  // 当前打开的 ExpandIndex
  var openExpandIndex = -1;

  @override
  void initState() {
    super.initState();
    requestTreeNodeJSON();
  }

  // 获取电站列表数据
  void requestTreeNodeJSON() async {
    var stations = await API.getStationsFromTreeNode();
    if (stations == null) {
      EventTaxiImpl.singleton().fire(TokenExpireEvent());
      return;
    }

    debugPrint('TreeNodeJson 设备数量 = ' + stations.length.toString() + ' 台');

    setState(() {
      rawStations = HomeLogic.buildStationsFromTreeNode(stations);
      sectionStations = HomeLogic.packGroups(rawStations);
      attachCollectedRecordFile();
    });
    scrollToBanner();
  }

  void attachCollectedRecordFile() async {
    sectionStations = await HomeLogic.downloadCollectRecordFileFromServerAndAddToUI(sectionStations);
    setState(() {
      
    });
  }

  // 默认隐藏广告条
  void scrollToBanner() {
    scrollController.animateTo(kSerchBarHeight,duration: Duration(milliseconds: 500),curve:Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {

    var len = sectionStations?.length ?? 0;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: len + 2,
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return HomeSearchBar(
                      searchBarHeight: kSerchBarHeight,
                      rawStations:rawStations,
                    );
                  } else if (i == 1) {
                    return HomeBanner();
                  } else {
                    return HomeStationExpandTile(
                      index: (i - 2),
                      group: sectionStations[i - 2],
                      openExpandIndex: openExpandIndex,
                      onTapExpand: (int index,bool isOpen){
                        setState(() {
                          openExpandIndex = isOpen ? index : -1;
                        });
                      },
                      onTapCollected: (Station station){
                        setState(() {
                          station.isCollected = !station.isCollected;
                        });
                        this.sectionStations = HomeLogic.syncStationSection(sectionStations);
                        HomeLogic.writeToServer(HomeLogic.makeCloudFile(sectionStations));
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
