import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/page/station/station_big_pool.dart';
import 'package:hsa_app/page/station/station_list_header.dart';
import 'package:hsa_app/page/station/station_profit_widget.dart';
import 'package:hsa_app/page/station/station_wave_widget.dart';
import 'package:hsa_app/page/station/station_weather_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/page/runtime/runtime_page.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:native_color/native_color.dart';
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
  RefreshController refreshController = RefreshController(initialRefresh: false);

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

    final stationId = widget?.stationId ?? '' ;

    if(stationId.length == 0) {
      Progresshud.showInfoWithStatus('获取电站信息失败');
      return;
    }
    
    API.stationInfo(stationId,(StationInfo station){

      Progresshud.dismiss();
      refreshController.refreshCompleted();

      if(station == null) return;

      setState(() {
        this.stationInfo =  station;
        if(station.openlive!= null) {
          this.openLive = station.openlive;
        }
      });

    },(String msg){

      refreshController.refreshFailed();
      Progresshud.showInfoWithStatus('获取电站信息失败');

    });

  }



  // 计算 功率比率
  static double caculatePowerRatio(Devices devices) {

    var powerMax = devices?.power?.max ?? 0.0;
    var powerCurrent = devices?.power?.current ?? 0.0;
    if( powerMax == 0 ) return 0.0;
    if( powerCurrent == 0 ) return 0.0; 
    var ratio =  powerCurrent / powerMax;
    return ratio;

  }

  // 机组列表
  Widget terminalList() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stationInfo?.devices?.length ?? 0,
          itemBuilder: (context, index) => deviceTile(context,index,stationInfo?.devices[index]),
        ),
    );
  }

  // 右上角标
  Widget badgeRight(bool isMaster,bool isOnline,String text) {
    return  isMaster ? Container(
        height: 16,width: 16,
        decoration: BoxDecoration(
          color: HexColor('009EE4'),
          border: Border.all(color: HexColor('009EE4'),width: 1.5),
          borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontSize: 12))))
      : Container(
        height: 16,width: 16,
        decoration: BoxDecoration(
          border: Border.all(color: isOnline ? Colors.white : Colors.white60,width: 1.5),
          borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(text,style: TextStyle(color: isOnline ? Colors.white : Colors.white60,fontSize: 12))),
     );
  }

  // 风机控件
  Widget fanWidget(bool isMaster) {
    return Center(
      child: SizedBox(height: 34,width: 34,
      child: isMaster ? Image.asset('images/station/GL_unit_on_icon.png') 
        : Image.asset('images/station/GL_unit_off_icon.png')
      ),
    );
  }

  // 展示 EventCount
  String buildEventCount(int eventCount) {
    if(eventCount == null) return '';
    if(eventCount == 0) return '';
    if(eventCount > 99) return '99+';
    return eventCount.toString();
  }

  Widget gradientPowerLine(Devices device,bool isOnline) {

      var maxWidth = MediaQuery.of(context).size.width - 20;
      var ratio = caculatePowerRatio(device);

      bool isBeyond = false;
      double right = 0;
      double left = 0;

      // 超发
      if(ratio > 1.0) {
        isBeyond = true;
        var beyond = ratio - 1.0;
        // 为了好看,超发部分放大 3 倍
        beyond = beyond * 3;
        final rightRatio = 1.0 - beyond;
        right = maxWidth * (1.0 - rightRatio);
        left =  maxWidth - (maxWidth *  beyond);
      }
      // 正常发电
      else {
        isBeyond = false;
        right = maxWidth * (1 - ratio);
      }

       return  isOnline ? Stack(
         children: <Widget>[

           // 蓝色正常部分
           Positioned(
            left: 0,right: right,bottom: 1,height:2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor('4778f7'),HexColor('66f7f9')]
                )))),
          
           // 红色超发部分
           isBeyond == true ? Positioned(
            left: left,right: 0,bottom: 1,height:2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor('fff8083a'),HexColor('00f8083a'),]
                )))) : Container(),
         ],
       ) : Container();

  }

  // 渐变标签
  Widget gradientPowerLineTag(Devices device,bool isOnline) {

      var maxWidth = MediaQuery.of(context).size.width - 20;
      var ratio = caculatePowerRatio(device);
      
      bool isBeyond = false;
      double right = 0;
      double left = 0;

      // 超发
      if(ratio > 1.0) {
        isBeyond = true;
        var beyond = ratio - 1.0;
        // 为了好看,超发部分放大 3 倍
        beyond = beyond * 3;
        final rightRatio = 1.0 - beyond;
        right = maxWidth * (1.0 - rightRatio);
        left =  maxWidth - (maxWidth *  beyond);
      }
      // 正常发电
      else {
        isBeyond = false;
        right = maxWidth * (1 - ratio);
      }

      // 渐变条指示器
      return isOnline ? Stack(
          children: <Widget>[
            // 蓝色正常部分
            isBeyond == false ? Positioned(
            right: right,bottom: 0,
              child: SizedBox(width: 30,height: 18, child: Image.asset('images/station/GL_BLight.png'))) : Container(),
            // 红色超发部分
            isBeyond == true ? Positioned(
                left: left,bottom: 0,
              child: SizedBox(width: 30,height: 18, child: Image.asset('images/station/GL_RLight.png'))) : Container(),
          ],
      ) : Container();
  }


  Widget deviceTile(BuildContext context,int index,Devices device){
    
    var badgeName = (index + 1).toString();
    var isMaster = device?.isMaster ?? false;
    var isOnline = device?.status == 'online' ? true : false;
    var currentPower = device?.power?.current ?? 0.0;
    var currentPowerStr = currentPower.toString() + '';
    var timeStamp = device?.updateTime ?? '';
    timeStamp += isOnline ? '         ' : ' 离线';
    var maxPower = device?.power?.max ?? 0;
    var maxPowerStr = maxPower.toString() + 'kW';
    var eventCount = device?.eventCount ?? 0;
    var eventStr = buildEventCount(eventCount);
    
    return Container(
      height: 76,
      child: Stack(
        children: <Widget>[
          
          // 内容
          GestureDetector(
            onTap: (){
              pushToPage(context, 
              RuntimePage(device?.name ?? '',device.address,badgeName + '#',isOnline));
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    // 堆叠视图
                    SizedBox(height: 50,width: 50,
                      child: Stack(
                        children:[
                        // 水轮机图标
                        fanWidget(isOnline),
                        // 角标
                        Positioned(right: 2,top: 0,
                          child: badgeRight(isMaster,isOnline,badgeName)
                        ),
                        ]
                      ),
                    ),

                    // 文字
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 8),
                        Text(maxPowerStr,style: TextStyle(color: isOnline ? Colors.white : Colors.white60,
                        fontFamily: 'ArialNarrow',fontSize: 20)),
                        SizedBox(height: 4),
                        Text(timeStamp,style: TextStyle(color: Colors.white54,fontFamily: 'ArialNarrow',fontSize: 15)),
                      ],
                    ),

                    // 告警铃
                    eventCount != 0 ? Badge(
                      badgeContent: Center(child: Text(eventStr,style: TextStyle(color: Colors.white,fontSize: 12))),
                      position: BadgePosition.topRight(top: -12,right: -4),
                      badgeColor: Colors.red,toAnimate: false,
                      child:  SizedBox(height: 24,width: 24,child: Image.asset('images/station/GL_Alarm_icon.png')))
                    : SizedBox(height: 24,width: 24),

                    // 当前功率
                    Text(currentPowerStr,style: TextStyle(color: isOnline ? Colors.white : Colors.white60,fontFamily: 'ArialNarrow',fontSize: 28)),
                  ],
                ),
              ),
            ),
          ),

          // 功率 Tag
          gradientPowerLineTag(device,isOnline),
          // 功率 渐进线
          gradientPowerLine(device,isOnline),
          // 分割线
          Positioned(left: 0,right: 0,bottom: 0,child: Container(height:1,color: Colors.white10)),
        ],
      ),
    );
  }

  // 生成历史访问 URL
  void onTapPushToHistory() async {
    final host = AppConfig.getInstance().remotePackage.hostWeb;
    final urlHistory = host + '/#/' + 'history';
    final auth = await ShareManager.instance.loadToken();
    final deviceIdList = stationInfo.devices.map((device){
      return device?.address ?? '';
    }).toList();
    final terminalsString = deviceIdList.join(',');
    final titleString = stationInfo?.name ?? '';
    final lastUrl =  urlHistory + '?auth=' + auth + '&address=' + terminalsString + '&title=' + Uri.encodeComponent(titleString);
    pushToPage(context, WebViewPage('', lastUrl,noNavBar:true,description:'历史曲线'));
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
      child: Stack(
        children:[

          stationInfo?.geo == null ? Container() : 
          StationWeatherWidget(geo: stationInfo.geo,onWeahterResponse: (weather) => syncWeaher(weather)),

          Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(widget.title ?? '',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 20)),
            actions: <Widget>[
              GestureDetector(
                onTap: stationInfo.devices == null ? null : (){
                  onTapPushToHistory();
                },
                child: Center(child: Text('历史曲线',style:TextStyle(color: Colors.white,fontSize: 16)))),
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
                  StationListHeader(weather: weather,openLive: openLive,stationName: stationInfo.name),
                  terminalList(),
                ],
              ),
            ),
          ),
        ),
        
        ]
      ),
    );
  }
}
