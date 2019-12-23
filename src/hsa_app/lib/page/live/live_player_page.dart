import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/spinkit_indicator.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:flt_video_player/flt_video_player.dart';

class LivePlayerPage extends StatefulWidget {

  final String title;
  final String playUrl;
  final String stationName;

  const LivePlayerPage({Key key, this.playUrl, this.title, this.stationName}) : super(key: key);
  @override
  _LivePlayerPageState createState() => _LivePlayerPageState();
}

class _LivePlayerPageState extends State<LivePlayerPage> {

  int watingCnt = 45;

  bool isFinished = false;

  VideoPlayerController playerController;

  Timer timer;

  int coolDownCnt = 0;

  String loadingText = '直播准备中...';

  String systemName = '未知';

  String stationName = '';

  void initUIData() {
    stationName = widget?.stationName ?? '';
    systemName = getSystemName();
    watingCnt = getWatinngTimeSecond();
    isFinished = false;
    coolDownCnt = watingCnt;
    loadingText = '直播准备中($watingCnt)';
    systemName = '未知';
  }

  // 获取等待时间
  int getWatinngTimeSecond() {
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      return 15;
    } else if (TargetPlatform.android == defaultTargetPlatform) {
      return 45;
    }
    return 45;
  }

    // 获取等待时间
  String getSystemName() {
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      return '苹果';
    } else if (TargetPlatform.android == defaultTargetPlatform) {
      return '安卓';
    }
    return '未知';
  }


  @override
  void initState() {
    UMengAnalyticsService.enterPage('实况直播');
    initVideoPlayers();
    initUIData();
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('实况直播');
    disposeVideoPlayer();
    super.dispose();
  }


  // 开启定时器
  void startTimer() async {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      coolDownCnt--;

      if (coolDownCnt <= 0) {
        coolDownCnt = 0;
        loadingText = '马上就来...';
        timer?.cancel();
      }

      setState(() {
        loadingText = '直播准备中($coolDownCnt)';
      });
    });
  }

  // 初始化播放器
  void initVideoPlayers() {
      final playUrl  = widget?.playUrl ?? '';

      debugPrint('📺直播流:' + playUrl);
      
      if(playUrl.length == 0) {
        setState(() {
          loadingText = '直播源地址不存在';
          return;
        });
        return;
      }
      playerController = VideoPlayerController.path(playUrl)
        ..initialize().then((_) {
          Future.delayed(Duration(seconds: watingCnt), () {
            setState(() {
              isFinished = true;
            });
          });
          startTimer();
        });
    } 

  void disposeVideoPlayer() {
    timer?.cancel();
    playerController?.dispose();
  }

  // 播放器组件
  Widget playerWidget(String playUrl) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
        child: AspectRatio(aspectRatio: 4 / 3,child: isFinished == false ? 
        SpinkitIndicator(title: loadingText, subTitle: '请稍后') 
        : VideoPlayer(playerController)));
  }

  @override
  Widget build(BuildContext context) {

    final playerUrl = widget?.playUrl?? '';

    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.title ?? '',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('$stationName',style: TextStyle(fontSize: 16,color: Colors.white)),
                SizedBox(height: 10),
                Text('通道:$systemName',style: TextStyle(fontSize: 16,color: Colors.white)),
                SizedBox(height: 10),
                playerWidget(playerUrl),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

