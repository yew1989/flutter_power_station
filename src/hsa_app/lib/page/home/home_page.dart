import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/debug/debug_api.dart';
import 'package:hsa_app/model/banner_item.dart';
import 'package:hsa_app/page/home/home_station_list.dart';
import 'package:hsa_app/page/home/view/home_banner.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  // 广告条
  List<BannerItem> banners = [];
  
  // 省份列表
  List<String> provinces = [];

  // UI分节列表
  List<String> sections = ['特别关注','全部电站'];

  // 获取广告条
  void requestBanner() {

    // API.banners((List<BannerItem> banners) {
    //   setState(() {
    //     this.banners = banners;
    //   });
    // }, (_){
    //   progressShowError('广告信息获取失败');
    // });

  }

  // 省份列表
  // void requestProvinces() {

  //   API.provinces((List<String> provinces){
  //     setState(() {
  //       this.provinces = provinces;
  //       this.sections.addAll(provinces.map((name)=>name+'省').toList());
  //     });
  //   }, (_){
  //     progressShowError('省份信息获取失败');
  //   });

  // }

  //省份列表(新)
  void requestProvinces(){
    DebugAPI.getAreaList(rangeLevel:'Province',onSucc: (areas){

      setState(() {
        this.provinces = areas.map((area) => area.provinceName).toList();
        this.sections.addAll(provinces.map((name) => name == '北京'? name +'市':name+'省').toList());
      });

    },onFail: (msg){
      showToast(msg);
      progressShowError('省份信息获取失败');
    });
  }

  @override
  void initState() {
    UMengAnalyticsService.enterPage('首页');
    requestBanner();
    requestProvinces();
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('首页');
    super.dispose();
  }

  // 标签页 Header
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
        tabs: this.sections.map((name) => SizedBox(height: 40, child: Center(child: Text(name)))).toList(),
      ),
    );
  }

  // 标签页 Body
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

            AspectRatio(aspectRatio: 45/ 28,child: HomeBanner(this.banners)),

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
