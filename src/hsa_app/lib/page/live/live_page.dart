import 'package:flutter/material.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
// import 'package:video_player/video_player.dart';
import 'package:flt_video_player/flt_video_player.dart';

class LivePage extends StatefulWidget {
  final List<String> openLives;
  final String title;
  const LivePage({Key key, this.openLives, this.title}) : super(key: key);
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {

  VideoPlayerController _controller;
  

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.path(
        // 'http://hzhls01.ys7.com:7888/openlive/C55600574_1_2.m3u8?ticket=ME5aVFdrMHBTZXNkbEw1NFZxS0dMVXZiaTAwTlBoaXRKRWRyT3JaK3Z5cz0kMSQyMDE5MTIwMzE0MDYyNyQxNTc1MjY2NzU3MDA5JDE1NzUzNTMxODcwMDkkMSQxNTc1MjY2NzU3MDA5JDE1NzUzNTMxODcwMDkkMyRjNjYwZTJmZDIwZDQ0NThhYWNhY2YxMzhjY2MyYjMxZiQz&token=296349165ca6443082d799aa6aefa894'
        // 'http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4'
        // 'http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4'
        'http://hls01open.ys7.com/openlive/24d9ed96df9545f6b9a914828c2d9fb0.m3u8'
        )
      ..initialize().then((_) {
        setState(() {
            debugPrint('初始化');
        });
      });

    Future.delayed(Duration(seconds:1),(){
      _controller.play();
    });
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var source = widget.openLives.first ?? '';
    debugPrint(source);

    return ThemeGradientBackground(
      child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(widget.title ?? '',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18),
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child:  AspectRatio(
                  aspectRatio: 4/3,
                  child: VideoPlayer(_controller),
              ),
          ),
        ),
      ),
    );
  }


}