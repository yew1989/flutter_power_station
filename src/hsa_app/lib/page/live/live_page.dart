import 'package:flutter/material.dart';
import 'package:hsa_app/components/spinkit_indicator.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:flt_video_player/flt_video_player.dart';

class LivePage extends StatefulWidget {
  final List<String> openLives;
  final String title;
  const LivePage({Key key, this.openLives, this.title}) : super(key: key);
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {

  bool isFirstLoadingFinished = false;
  bool isLastLoadingFinished  = false;

  VideoPlayerController firstVideoPlayerController;
  VideoPlayerController lastVideoPlayerController;

  void initVideoPlayers() {
    var openLives = widget.openLives;
    if (openLives.length == 1) {
      var firstSrc = widget?.openLives?.first ?? '';
      firstVideoPlayerController = VideoPlayerController.path(firstSrc)
        ..initialize().then((_) {

          Future.delayed(Duration(seconds:1),(){
              setState(() {
                isLastLoadingFinished = true;
              });
            });

        });
    } else if (openLives.length == 2) {
      var firstSrc = widget?.openLives?.first ?? '';
      var lastSrc = widget?.openLives?.last ?? '';
      firstVideoPlayerController = VideoPlayerController.path(firstSrc)
        ..initialize().then((_) {
     
            Future.delayed(Duration(seconds:1),(){
              setState(() {
                isFirstLoadingFinished = true;
              });
            });

        });
      lastVideoPlayerController = VideoPlayerController.path(lastSrc)
        ..initialize().then((_) {

            Future.delayed(Duration(seconds:1),(){
              setState(() {
                isLastLoadingFinished = true;
              });
            });

        });
    }
  }

  void disposeVideoPlayer() {
    firstVideoPlayerController?.dispose();
    lastVideoPlayerController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    initVideoPlayers();
  }

  @override
  void dispose() {
    disposeVideoPlayer();
    super.dispose();
  }

  Widget buildUIListView(List<String> openLives) {
    List<Widget> listView = [];
    for (int i = 0; i < openLives.length; i++) {
      var index = i + 1;
      listView.add(SizedBox(
          child: Container(
              child: Text('直播$index : ',
                  style: TextStyle(color: Colors.white, fontSize: 16)))));
      if (i == 0) {
        listView.add(Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AspectRatio(
                aspectRatio: 4 / 3, child: 
                isFirstLoadingFinished == false ?  SpinkitIndicator(title: '直播加载中...',subTitle: '请稍后')
                : VideoPlayer(firstVideoPlayerController))));
      } else if (i == 1) {
        listView.add(Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AspectRatio(
                aspectRatio: 4 / 3, 
                child: 
                isFirstLoadingFinished == false ? SpinkitIndicator(title: '直播加载中...',subTitle: '请稍后')
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
