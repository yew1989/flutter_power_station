import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/page/live/live_player_page.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class LiveListPage extends StatefulWidget {
  
  final List<String> openLives;
  final String stationName;
  const LiveListPage({Key key, this.openLives, this.stationName}) : super(key: key);
  @override
  _LiveListPageState createState() => _LiveListPageState();
}

class _LiveListPageState extends State<LiveListPage> {

  List<String> openLiveList = [];

  @override
  void initState() {
    openLiveList = widget?.openLives ?? List<String>();
    UMengAnalyticsService.enterPage('直播源列表');
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('直播源列表');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('直播源列表',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18)),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: openLiveList?.length ?? 0,
              itemBuilder: (context,index) => liveListTile(context,index),
            ),
          ),
        ),
      ),
    );
  }

  Widget liveListTile(BuildContext context,int index){

    final liveStr = '直播源 ' +(index + 1).toString();
    final liveUrl = openLiveList[index];

    return Material(
      color: Colors.transparent,
      child: Ink(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            height: 80,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         SizedBox(height: 32,width: 32,child: Image.asset('images/station/GL_Video_btn.png')),
                         SizedBox(width: 8),
                         Text('$liveStr',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'ArialNarrow')),
                       ],
                    )),
                  ),
                  Container(height: 1,color: Colors.white12),
                ],
              ),
            ),
          ),
          onTap:() => onTapPlayerUrl(context, liveStr, liveUrl,widget?.stationName ?? ''),
        ),
      ),
    );
  }

  // 点击到播放器
  void onTapPlayerUrl(BuildContext context,String title,String playUrl,String stationName) async {
    await Future.delayed(Duration(milliseconds: 500));
    pushToPage(context, LivePlayerPage(playUrl: playUrl,title: title,stationName: stationName));
  }
}