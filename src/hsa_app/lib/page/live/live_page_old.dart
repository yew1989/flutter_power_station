import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/spinkit_indicator.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:flt_video_player/flt_video_player.dart';

class LivePageOld extends StatefulWidget {
  final List<String> openLives;
  final String title;
  const LivePageOld({Key key, this.openLives, this.title}) : super(key: key);
  @override
  _LivePageOldState createState() => _LivePageOldState();
}

class _LivePageOldState extends State<LivePageOld> {

  static const int watingCnt = 10;

  bool isFirstLoadingFinished = false;
  bool isLastLoadingFinished = false;

  VideoPlayerController firstVideoPlayerController;
  VideoPlayerController lastVideoPlayerController;

  Timer coolDownTimer;

  int coolDownCnt = watingCnt;

  var loadingText = '直播准备中($watingCnt)';

  // 开启定时器
  void startTimer() async {
    coolDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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

  void initVideoPlayers() {
    var openLives = widget.openLives;
    if (openLives.length == 1) {
      var firstSrc = widget?.openLives?.first ?? '';
      firstVideoPlayerController = VideoPlayerController.path(firstSrc)
        ..initialize().then((_) {
          Future.delayed(Duration(seconds: watingCnt), () {
            setState(() {
              isFirstLoadingFinished = true;
            });
          });
          startTimer();
        });
    } else if (openLives.length == 2) {
      var firstSrc = widget?.openLives?.first ?? '';
      var lastSrc = widget?.openLives?.last ?? '';
      firstVideoPlayerController = VideoPlayerController.path(firstSrc)
        ..initialize().then((_) {
          Future.delayed(Duration(seconds: watingCnt), () {
            setState(() {
              isFirstLoadingFinished = true;
            });
          });
        });
      lastVideoPlayerController = VideoPlayerController.path(lastSrc)
        ..initialize().then((_) {
          Future.delayed(Duration(seconds: watingCnt), () {
            setState(() {
              isLastLoadingFinished = true;
            });
          });
        });
        startTimer();
    }
  }

  void disposeVideoPlayer() {
    coolDownTimer?.cancel();
    firstVideoPlayerController?.dispose();
    lastVideoPlayerController?.dispose();
  }

  @override
  void initState() {
    final openLives = widget.openLives;
    debugPrint('📺 直播1:' + openLives.first);
    debugPrint('📺 直播2:' + openLives.last);
    UMengAnalyticsService.enterPage('实况直播');
    initVideoPlayers();
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('实况直播');
    disposeVideoPlayer();
    super.dispose();
  }

  Widget buildUIListView(List<String> openLives) {
    List<Widget> listView = [];
    for (int i = 0; i < openLives.length; i++) {
      // 最多只支持两路
      if (i == 2) break;
      var index = i + 1;
      listView.add(SizedBox(
          child: Container(
              child: Text('直播$index : ',
                  style: TextStyle(color: Colors.white, fontSize: 16)))));
      if (i == 0) {
        listView.add(Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AspectRatio(
                aspectRatio: 4 / 3,
                child: isFirstLoadingFinished == false
                    ? SpinkitIndicator(title: loadingText, subTitle: '请稍后')
                    : VideoPlayer(firstVideoPlayerController))));
      } else if (i == 1) {
        listView.add(Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AspectRatio(
                aspectRatio: 4 / 3,
                child: isFirstLoadingFinished == false
                    ? SpinkitIndicator(title: loadingText, subTitle: '请稍后')
                    : VideoPlayer(lastVideoPlayerController))));
      }
    }
    return listView.length != 0
        ? ListView(
            children: listView,
          )
        : Container();
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
            child: buildUIListView(widget.openLives),
          ),
        ),
      ),
    );
  }
}
