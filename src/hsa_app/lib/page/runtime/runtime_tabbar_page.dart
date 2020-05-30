import 'package:flutter/material.dart';
import 'package:hsa_app/components/page_indicator/dots_decorator.dart';
import 'package:hsa_app/components/page_indicator/dots_indicator.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/runtime/runtime_page.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class RuntimeTabbarPage extends StatefulWidget {
  final StationInfo stationInfo;
  final List<WaterTurbine> waterTurbines;
  final int selectIndex;

  const RuntimeTabbarPage({Key key, this.waterTurbines, this.selectIndex,this.stationInfo}) : super(key: key);
  @override
  _RuntimeTabbarPageState createState() => _RuntimeTabbarPageState();
}

class _RuntimeTabbarPageState extends State<RuntimeTabbarPage> {
  StationInfo stationInfo;
  int currentIndex;
  WaterTurbine currentWaterTurbine;
  int pageLength;
  String title;
  PageController pageController;
  String badgeName;

  @override
  void initState() {
    super.initState();
    stationInfo = widget.stationInfo;
    currentIndex = widget?.selectIndex ?? 0;
    currentWaterTurbine = widget?.waterTurbines[currentIndex];
    pageLength = widget?.waterTurbines?.length ?? 0;
    title = ( currentIndex + 1 ).toString() + '#' + '实时数据';
    pageController = PageController(initialPage: currentIndex);
    badgeName = (currentIndex + 1).toString() + '#';
    UMengAnalyticsService.enterPage('机组实时');
  }

  @override
  void dispose() {
    pageController.dispose();
    UMengAnalyticsService.exitPage('机组实时');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: AppTheme().navigationAppBarFontSize)),
          actions: <Widget>[
            GestureDetector(
                onTap: () => pushToPage(context, HistoryPage(stationInfo:stationInfo, isSingleDevice: true,singleWaterTurbine: currentWaterTurbine)),
                child: Image.asset('images/history/Histor_icon.png',scale: 1.6,)),
            SizedBox(width: 10),
          ],
        ),
        body: Stack(
          children: <Widget>[
            
            PageView.builder(
              
              physics: AlwaysScrollableScrollPhysics(),
              controller: pageController,
              itemCount: widget?.waterTurbines?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {

                return RuntimePage(
                alias:(index+1).toString() + '#',
                waterTurbine: currentWaterTurbine,
                isAllowHighSpeedNetworkSwitching: this.stationInfo?.isAllowHighSpeedNetworkSwitching ?? false,
                );
              },
              
              onPageChanged: (int index) {
                currentIndex = index;
                currentWaterTurbine = widget?.waterTurbines[currentIndex];
                badgeName = ( currentIndex + 1 ).toString() + '#';
                setState(() {
                  title = ( currentIndex + 1 ).toString() + '#' + '实时数据';
                });
              },
            ),
            // 仍然有 bug ,暂时屏蔽左右滑动入口
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
        )));
  }
}