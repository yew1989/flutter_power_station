import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/components/wave_ball.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/station/station_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeStationList extends StatefulWidget {

  final String homeParam;
  const HomeStationList({Key key, this.homeParam}) : super(key: key);
  @override
  _HomeStationListState createState() => _HomeStationListState();

}

class _HomeStationListState extends State<HomeStationList> {
  
  int pageRowsMax = 10;
  List<Stations> stations = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int currentPage = 1;

  int type = 0; // 0 全部电站, 1 关注电站 , 2 省份电站
  String provinceName = '';

  // 按省获取电站列表 加载首页
  void loadFirst() async {
    
    currentPage = 1;

    API.stationsList((List<Stations> stations,int total){
      setState(() {
        this.stations = stations;
      });
      refreshController.refreshCompleted();
    }, (String msg){
      refreshController.refreshCompleted();
      debugPrint(msg);
      progressShowError(msg);
    },
    // 页码
    page:currentPage,
    rows:pageRowsMax,
    province:provinceName,
    );
  }

  // 刷新下一页
  void loadNext() async {

      currentPage++ ;

      API.stationsList((List<Stations> stations,int total){
      setState(() {
        // this.stations = stations;
        if(stations == null || stations?.length == 0) {
            refreshController.loadNoData();
        }
        else{
          this.stations.addAll(stations);
          refreshController.loadComplete();
        }
      });
    }, (String msg){
      refreshController.loadComplete();
      debugPrint(msg);
      progressShowError(msg);
    },
    // 页码
    page:currentPage,
    rows:pageRowsMax,
    province:provinceName,
    );
  }

  // 计算类型和省份
  void caculateType(String homeParam) {
    var isProvince = homeParam.endsWith('省');
    if(isProvince == true) {
      this.provinceName = homeParam.split('省').first;
      this.type = 2;
    }
    if(homeParam == '全部电站') {
      this.provinceName = '';
      this.type = 0;
    }
    if(homeParam == '特别关注') {
      this.provinceName = '';
      this.type = 1;
    }
  }
  
  @override
  void initState() {
    super.initState();
    caculateType(widget.homeParam);
    loadFirst();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      onLoading: loadFirst,
      onRefresh: loadNext,
      controller: refreshController,
      child: ListView.builder(
        itemCount: stations?.length ?? 0,
        itemBuilder: (BuildContext context, int index) => stationTile(context,index),
      ),
    );
  }

  Widget stationTile(BuildContext context, int index) {

    var station = stations[index];

    return Container(
      height: 214,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          GestureDetector(
            onTap: (){
              pushToPage(context, StationPage('','',''));
            },
            child: Container(
              child: SizedBox(
                  height: 212,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      stationTileTop(station),
                      stationTileBody(),
                    ],
                ),
              ),
            ),
          ),
          // 底部分割线
          SizedBox(height: 1, child: Container(color: Colors.white24)),
        ],
      ),
    );
  }

  Widget stationTileTop(Stations station) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 24,
                width: 24,
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage:AssetImage('images/home/Home_protrait_icon.png'),
                ),
              ),
              SizedBox(width: 10),
              Text(station.name,style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/home/Home_keep_btn.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget stationTileBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 156,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // 水波球 + 海拔
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              WaveBall(),
              SizedBox(height: 4),
              Text('45.1m',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 16)),
            ],
          ),

          //  在线 + 报警
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              // 在线状态
              Row(
                children: [
                SizedBox(height: 24,width: 24,
                  child: Image.asset('images/home/Home_online_icon.png'),
                ),
                SizedBox(width: 8),
                Text('在线',style: TextStyle(color: Colors.white,fontSize: 15)),
                ]
              ),

              // 间隔
              SizedBox(height: 40),

              // 报警状态
              Row(
                children: [
                Badge(
                  position: BadgePosition.topRight(top: -8,right: -8),
                  badgeColor: Colors.red,
                  badgeContent: Text('1',style: TextStyle(color: Colors.white),),
                  toAnimate: false,
                  child: SizedBox(height: 24,width: 24,
                    child: Image.asset('images/home/Home_Aalarm_icon.png'),
                  ),
                ),
                SizedBox(width: 8),
                Text('报警',style: TextStyle(color: Colors.white,fontSize: 15)),
                ]
              ),

            ],
          )
        ],
      ),
    );
  }
}