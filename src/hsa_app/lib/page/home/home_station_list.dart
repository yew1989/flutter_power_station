import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/components/wave_ball.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/station/station_page.dart';
import 'package:ovprogresshud/progresshud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeStationList extends StatefulWidget {

  final String homeParam;
  final bool isFromSearch;

  const HomeStationList({Key key, this.homeParam,this.isFromSearch}) : super(key: key);
  @override
  _HomeStationListState createState() => _HomeStationListState();

}

class _HomeStationListState extends State<HomeStationList> {
  
  int pageRowsMax = 20;
  List<Stations> stations = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int currentPage = 1;
  // 0 全部电站, 1 关注电站 , 2 省份电站
  int type = 0; 
  String provinceName = '';
  String keyWord = '';

  // 按省获取电站列表 加载首页
  void loadFirst() async {
    
    currentPage = 1;

    API.stationsList((List<Stations> stations,int total){
      setState(() {
        this.stations = stations;
      });
      refreshController.refreshCompleted();
    }, (String msg){
      refreshController.refreshFailed();
    },
    // 页码
    page:currentPage,
    rows:pageRowsMax,
    province:provinceName,
    keyword: keyWord,
    isfocus: this.type == 1 ? true : false,
    );
  }

  // 刷新下一页
  void loadNext() async {

      currentPage++ ;

      API.stationsList((List<Stations> stations,int total){
      setState(() {
        
        if(stations == null || stations?.length == 0) {
            refreshController.loadNoData();
        }
        else{
          this.stations.addAll(stations);
          refreshController.loadComplete();
        }
      });
    }, (String msg){
      refreshController.loadFailed();
    },
    // 页码
    page:currentPage,
    rows:pageRowsMax,
    province:provinceName,
    keyword: keyWord,
    isfocus: this.type == 1 ? true : false,
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
    initPage();
    if(this.widget.isFromSearch == true) {
      EventBird().on(AppEvent.searchKeyWord, (text){
          this.keyWord = text;
          initPage();
      });
    }
  }

  void initPage() {
    caculateType(widget.homeParam);
    loadFirst();
  }

  @override
  void dispose() {
    if(this.widget.isFromSearch == true) {
      EventBird().off(AppEvent.searchKeyWord);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SmartRefresher(
      header: appRefreshHeader(),
      footer: appRefreshFooter(),
      enablePullDown: true,
      enablePullUp: true,
      onLoading: loadNext,
      onRefresh: loadFirst,
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
              pushToPage(context, StationPage(station.name,station.id.toString()));
            },
            child: Container(
              child: SizedBox(
                  height: 212,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      stationTileTop(station),
                      stationTileBody(station),
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
          // 行
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 24,width: 24,
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage:AssetImage('images/about/about_icon.png'),
                ),
              ),
              SizedBox(width: 10),
              Text(station.name,style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),

          // 星星
          GestureDetector(
            child: SizedBox(
              height: 24,width: 24,
              child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.transparent,
                  backgroundImage: station.isFocus
                  ? AssetImage('images/home/Home_keep_btn.png')
                  : AssetImage('images/home/Home_keep_no_btn.png'),
              ),
            ),
            onTap:() => requestFocus(station),
          ),
        ],
      ),
    );
  }


  // 请求关注
  void requestFocus(Stations station) async {

    API.focusStation(station.id.toString(), !station.isFocus, (String msg){
      final msg = !station.isFocus ? '关注成功' : '取消关注成功'; 
      Progresshud.showSuccessWithStatus(msg);
      setState(() {
        station.isFocus = !station.isFocus;
      });
    }, (String msg){
      Progresshud.showSuccessWithStatus('请检查网络');
      setState(() {
        station.isFocus = !station.isFocus;
      });
    });
  }


  // 展示 EventCount
  String buildEventCount(int eventCount) {
    if(eventCount == null) return '';
    if(eventCount == 0) return '';
    if(eventCount > 99) return '99+';
    return eventCount.toString();
  }

  Widget stationTileBody(Stations station) {
    // 水位标签
    var waterStr = station?.water?.current.toString() ?? '0.0';
    waterStr += 'm';
    // 告警标签
    var eventCount = station?.eventCount ?? 0;
    var eventStr = buildEventCount(eventCount);
    // 离线在线状态
    var isOnline = station?.status == 'online' ? true : false;

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
              WaveBall(station:station),
              SizedBox(height: 4),
              Text(waterStr,style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 16)),
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
                  child: isOnline 
                  ? Image.asset('images/home/Home_online_icon.png')
                  : Image.asset('images/home/Home_offline_icon.png'),
                ),
                SizedBox(width: 8),
                Text(isOnline ? '在线' : '离线',style: TextStyle(color: Colors.white,fontSize: 15)),
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
                  badgeContent: Text(eventStr,style: TextStyle(color: Colors.white,fontSize:12)),
                  toAnimate: false,
                  child: SizedBox(height: 24,width: 24,
                    child: Image.asset('images/home/Home_Aalarm_icon.png'),
                  ),
                  showBadge: eventCount != 0,
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
