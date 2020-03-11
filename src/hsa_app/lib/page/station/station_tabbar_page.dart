import 'package:flutter/material.dart';
import 'package:hsa_app/components/page_indicator/dots_decorator.dart';
import 'package:hsa_app/components/page_indicator/dots_indicator.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/station/station_page.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class StationTabbarPage extends StatefulWidget {

  final List<Stations> stations;
  final int selectIndex;

  const StationTabbarPage({Key key, this.stations, this.selectIndex}) : super(key: key);

  @override
  _StationTabbarPageState createState() => _StationTabbarPageState();

}

class _StationTabbarPageState extends State<StationTabbarPage> {

  int currentIndex;
  Stations currentStation;
  int pageLength;
  String title;
  PageController pageController;
  StationInfo stationInfo;

  @override
  void initState() {

    currentIndex = widget?.selectIndex ?? 0;
    currentStation = widget?.stations[currentIndex];
    pageLength = widget?.stations?.length ?? 0;
    title = currentStation?.name ?? '';
    pageController = PageController(initialPage: currentIndex);

    UMengAnalyticsService.enterPage('电站概要');
    super.initState();

    EventBird().on(AppEvent.eventGotStationInfo, (arg) { 
      if(arg is StationInfo) {
        setState(() {
          this.stationInfo = arg;
        });
      }
    });
  }

  @override
  void dispose() {

    EventBird().off(AppEvent.eventGotStationInfo);

    pageController.dispose();
    UMengAnalyticsService.exitPage('电站概要');
    super.dispose();
  }

  void onTapPushToHistoryPage(StationInfo info) async {

   final deviceIdList = info.devices.map((device) {
      return device?.address ?? '';
    }).toList();
    final addresses = deviceIdList.join(',');
    final navTitle = info?.name ?? '';
    pushToPage(context, HistoryPage(title: navTitle,address: addresses));
    
  }
  
  @override
  Widget build(BuildContext context) {

    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,elevation: 0,centerTitle: true,
          title: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
          actions: <Widget>[

            GestureDetector(
            onTap: stationInfo?.devices == null ? null : () => onTapPushToHistoryPage(stationInfo),
            child: Center(child: Text('历史分析',style:TextStyle(color: Colors.white, fontSize: 16)))),
            
            SizedBox(width: 20),
          ],
        ),
        body: Stack(

          children: [

            PageView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: pageController,
              itemCount: widget.stations.length,
              itemBuilder: (BuildContext context, int index) => StationPage(widget.stations[index].id.toString()),
              onPageChanged: (int index) {
                currentIndex = index;
                currentStation = widget?.stations[currentIndex];
                setState(() {
                  title = currentStation.name;
                });
              },
            ),

            Positioned(
              top: -6.0,left: 0.0,right: 0.0,
              child: Container(
                child: Center(
                child: DotsIndicator(
                dotsCount: pageLength > 5 ? 5 : pageLength,position: (currentIndex % 5).toDouble(),
                decorator: DotsDecorator(
                size: const Size(6.0, 6.0),
                activeSize: const Size(15.0, 6.0),
                activeColor: Colors.white38,
                color: Colors.white38,
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
