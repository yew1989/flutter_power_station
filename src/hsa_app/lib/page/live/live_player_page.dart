import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/spinkit_indicator.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class LivePlayerPage extends StatefulWidget {

  final String title;
  final String playUrl;
  final String stationName;

  const LivePlayerPage({Key key, this.playUrl, this.title, this.stationName}) : super(key: key);
  @override
  _LivePlayerPageState createState() => _LivePlayerPageState();
}

class _LivePlayerPageState extends State<LivePlayerPage> {

  int watingCnt = 10;

  bool isFinished = false;

  Timer timer;

  int coolDownCnt = 0;

  String loadingText = '直播准备中...';

  String systemName = '未知';

  String stationName = '';

  IjkMediaController ijkMediaController = IjkMediaController();

  void initUIData() {
    stationName = widget?.stationName ?? '';
    systemName = AppConfig.getInstance().platform;
    isFinished = false;
    coolDownCnt = watingCnt;
    loadingText = '直播准备中($watingCnt)';
  }

  @override
  void initState() {
    UMengAnalyticsService.enterPage('实况直播');
    initUIData();
    initVideoPlayers();
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('实况直播');
    disposeVideoPlayer();
    super.dispose();
  }

  // 开启定时器
  void startDisplayTimer() async {
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
  void initVideoPlayers() async {
      final playUrl  = widget?.playUrl ?? '';

      debugPrint('📺直播流:' + playUrl);
      
      if(playUrl.length == 0) {
        setState(() {
          loadingText = '直播源地址不存在';
          return;
        });
        return;
      }

      ijkMediaController.setAutoPlay();
      ijkMediaController.setNetworkDataSource(playUrl,autoPlay: true);
      startDisplayTimer();
      await Future.delayed(Duration(seconds: watingCnt));
      if(!mounted) return;
      ijkMediaController.play();
      setState(() {
         isFinished = true;
      });
  }
      
  void disposeVideoPlayer() {
    timer?.cancel();
    ijkMediaController?.dispose();
  }

  // 播放器组件
  Widget playerWidget(String playUrl) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: AspectRatio(aspectRatio: 4 / 3,
      child: isFinished ? IjkPlayer(mediaController: ijkMediaController) 
      : SpinkitIndicator(title: loadingText, subTitle: '请稍后')));
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

