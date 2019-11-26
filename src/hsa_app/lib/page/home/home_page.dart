import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/components/wave_ball.dart';
import 'package:hsa_app/model/banner_item.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/home/home_station_list.dart';
import 'package:hsa_app/page/home/view/home_banner.dart';
import 'package:hsa_app/page/station/station_page.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  // 每页分页数
  int pageRowsMax = 10;

  // 广告条
  List<BannerItem> banners = [

  ];
  // 省份列表
  List<String> provinces = [

  ];
  // UI分节列表
  List<String> sections = [
    '特别关注',
    '全部电站',
  ];

  // 获取广告条
  void requestBanner() {

    API.banners((List<BannerItem> banners) {
      setState(() {
        this.banners = banners;
      });
    }, (String msg){
      debugPrint(msg);
      progressShowError(msg);
    });
  }

  // 省份列表
  void requestProvinces() {
    
    API.provinces((List<String> provinces){
      setState(() {
        this.provinces = provinces;
        this.sections.addAll(provinces.map((name)=>name+'省').toList());
      });
    }, (String msg){
      debugPrint(msg);
      progressShowError(msg);
    });
  }

  // 按省获取电站列表 加载首页
  void reqeustStationListLoadFirst(int section, int page, String province,bool isFocus) {
    
    API.stationsList((List<Stations> stations,int total){
      setState(() {

      });
    }, (String msg){
      debugPrint(msg);
      progressShowError(msg);
    },
    // 页码
    page:page,
    rows:pageRowsMax,
    province:province,
    );
  }

  // // 按省获取电站列表 加载更多
  // void reqeustStationListLoadNext() {

  //   API.stationsList((List<Stations> stations,int total){
  //     setState(() {

  //     });
  //   }, (String msg){
  //     debugPrint(msg);
  //     progressShowError(msg);
  //   });
  // }


  @override
  void initState() {
    super.initState();
    requestBanner();
    requestProvinces();
    // reqeustStationListLoadFirst(1,1,'福建',false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget tabBarHeader() {
    return Center(
      child: TabBar(
        indicator: const BoxDecoration(),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white, 
        labelStyle: TextStyle(color: Colors.white, fontSize: 15.5), 
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle:TextStyle(color: Colors.grey, fontSize: 15), 
        indicatorColor: Colors.transparent,
        isScrollable: true,
        tabs: this.sections.map(
          (name){
            return SizedBox(height: 40, child: Center(child: Text(name)));
        }).toList(),
      ),
    );
  }

  // 标签页身体
  Widget tabBarBody() {
    return Expanded(
        child: TabBarView(
          physics: BouncingScrollPhysics(),
          children: this.sections.map((name){
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: HomeStationList(homeParam:name),
            );
          }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ThemeGradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 235,child: HomeBanner(this.banners)),
            SizedBox(height: 1, child: Container(color: Colors.white24)),
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: this.sections?.length ?? 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    tabBarHeader(),
                    tabBarBody(),
                    TabBarLineShawdow(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
