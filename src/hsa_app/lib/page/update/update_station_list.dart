import 'package:flutter/material.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/update/update_station_info.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UpdateStationList extends StatefulWidget {

  final String homeParam;
  final bool isFromSearch;
  final Function onFirstLoadFinish;

  const UpdateStationList({Key key, this.homeParam,this.isFromSearch,this.onFirstLoadFinish}) : super(key: key);

  @override
  _UpdateStationListState createState() => _UpdateStationListState();

}

class _UpdateStationListState extends State<UpdateStationList> {
  
  int pageRowsMax = 20;
  List<StationInfo> stations = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int currentPage = 1;
  String provinceName = '';
  String keyWord = '';
  
  //是否是英文和数字
  bool isEngOrNum ;
  //是否是数字
  bool isNum ;
  // 是否空视图
  bool isEmpty = false;
  // 是否首次数据加载完毕
  bool isLoadFinsh = false;
  //电站号拼接
  String stationNos = '';

  

  // 按省获取电站列表 加载首页
  void loadFirst(bool isEngOrNum) async {
    
    this.currentPage = 1;
    this.isEmpty = false;
    var partStationNamePinYin;
    var partStationName;
    var stationNoPrefix;
    if(isEngOrNum == true){
      if(isNum == true){
        stationNoPrefix = keyWord;
      }else if(isNum == false){
        partStationNamePinYin = keyWord;
      }
    }else if(isEngOrNum == false){
      partStationName = keyWord;
    }
    
    APIStation.getStationList(onSucc: (msg){
      
      this.stations = msg.stationInfo;
      this.stationNos = '';
      if(stations != null|| stations?.length != 0){
        stations.forEach((st) => this.stationNos = this.stationNos + ',' + st.stationNo.toString());
        if(this.stationNos != ''){
          this.stationNos = this.stationNos.substring(1);
        }
      }
      
      if(stations.length == 0) {
        this.isEmpty = true;
      }

      if(mounted) {
        setState(() {
          refreshController.refreshCompleted();
        });
      }
      if(widget.onFirstLoadFinish != null) widget.onFirstLoadFinish();
    },onFail: (msg){
      isLoadFinsh = true;
      refreshController.refreshFailed();

      if(widget.onFirstLoadFinish != null) widget.onFirstLoadFinish();
    },
    isIncludeWaterTurbine:true,
    
    page:currentPage,
    pageSize:pageRowsMax,
    proviceAreaCityNameOfDotSeparated:provinceName,
    partStationNamePinYin:partStationNamePinYin,
    partStationName:partStationName,
    stationNoPrefix:stationNoPrefix
    );
  }


  // 刷新下一页
  void loadNext(bool isEngOrNum) async {

    currentPage++ ;
    var partStationNamePinYin;
    var partStationName;
    var stationNoPrefix;
    if(isEngOrNum == true){
      if(isNum == true){
        stationNoPrefix = keyWord;
      }else if(isNum == false){
        partStationNamePinYin = keyWord;
      }
    }else if(isEngOrNum == false){
      partStationName = keyWord;
    }
    APIStation.getStationList(
      onSucc: (msg){
      
        isLoadFinsh = true;

        if(stations == null || stations?.length == 0) {
          refreshController.loadNoData();
        }
        else{
          this.stations.addAll(msg.stationInfo);
          
          this.stationNos = '';
          stations.forEach((st) => this.stationNos = this.stationNos + ',' + st.stationNo.toString());
          if(this.stationNos != ''){
            this.stationNos = this.stationNos.substring(1);
          }
        }
        if(mounted) {
          setState(() {
            refreshController.loadComplete();
          });
        }

        if(widget.onFirstLoadFinish != null) widget.onFirstLoadFinish();
      },onFail: (msg){
        isLoadFinsh = true;
        refreshController.refreshFailed();

        if(widget.onFirstLoadFinish != null) widget.onFirstLoadFinish();
      },
      isIncludeWaterTurbine:true,
      page:currentPage,
      pageSize:pageRowsMax,
      proviceAreaCityNameOfDotSeparated:provinceName,
      partStationNamePinYin:partStationNamePinYin,
      partStationName:partStationName,
      stationNoPrefix:stationNoPrefix
    );
  }

  //判断全部是英文和数字
  bool isEnglishOrNumber(String input) {
    String p = r'^[A-Za-z0-9]+$';
    final RegExp regex =  RegExp(p);
    return regex.hasMatch(input);
  }
  //判断全部是数字
  bool isNumber(String input){
    String p = r'^[0-9]+$';
    final RegExp regex =  RegExp(p);
    return regex.hasMatch(input);
  }


  @override
  void initState() {
    super.initState();
    initPage();
  }

  void initPage() {
    loadFirst(isEngOrNum);
  }

  @override
  void dispose() {
    if(this.widget.isFromSearch == true) {
      eventBird?.off(AppEvent.searchKeyWord);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if(isLoadFinsh == false) return SpinkitIndicator(title: '正在加载',subTitle: '请稍后');
    //if(isEmpty == true) return EmptyPage(title: '暂无数据',subTitle: '');
    return stationListView(context);
  }


  // 电站列表
  Widget stationListView(BuildContext context) {
    
    return SmartRefresher(
      header: appRefreshHeader(),
      footer: appRefreshFooter(),
      enablePullDown: true,
      enablePullUp: true,
      onLoading: ()=> loadNext(this.isEngOrNum),
      onRefresh: ()=> loadFirst(this.isEngOrNum),
      controller: refreshController,
      child: ListView.builder(
        itemCount: this.stations?.length ?? 0 ,
        itemBuilder: (BuildContext context, int index) => stationTile(context,index),
      ),
    );
  }

  Widget stationTile(BuildContext context, int index) {

    var station = stations[index];

    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          Container(
            alignment:Alignment.center,
            child: SizedBox(
                height: 55,
                child: stationTileTop(station),
            ),
          ),
          GestureDetector(
            onTap: (){
              // 新版电站滑块
              pushNewScreen(
                context,
                screen: UpdateStationInfoPage(stations[index].stationNo),
                platformSpecific: true, 
                withNavBar: true, 
              );
            },
          ),
          
        ],
      ),
    );
  }

  Widget stationTileTop(StationInfo station) {
    // 离线在线状态
    var isOnline = station?.terminalOnLineCount == 0 ? false : true  ;
    var width = MediaQuery.of(context).size.width;
    

    return SizedBox(
      height: 55,
      child: Column(
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
              Text(station.stationName,style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width:width/2-20,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 24,width: 24,
                    ),
                    SizedBox(width: 10),
                    Text(station.stationNo,style: TextStyle(color: Colors.white54, fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(
                width:width/2-20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 24,width: 24,
                      child: isOnline 
                      ? Image.asset('images/home/Home_online_icon.png')
                      : Image.asset('images/home/Home_offline_icon.png',color:Colors.grey),
                    ),
                    SizedBox(width: 8),
                    Text(isOnline ? '在线' : '离线',style: TextStyle(color: isOnline ?  Colors.white : Colors.grey ,fontSize: 15)),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset('images/mine/My_next_btn.png',color: isOnline ? Colors.white : Colors.grey),
                    ),
                  ]
                ),
              ),
            ],
          ),
          // 底部分割线
          SizedBox(height: 1, child: Container(color: Colors.white24)),
        ],
      ),
    );
  }


  

 
}
