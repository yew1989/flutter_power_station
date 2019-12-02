import 'package:flutter/material.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:flutter_video/flutter_video.dart';

class LivePage extends StatefulWidget {
  final List<String> openLives;
  final String title;
  const LivePage({Key key, this.openLives, this.title}) : super(key: key);
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {

  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var source = widget.openLives.first ?? '';
    debugPrint(source);

    return ThemeGradientBackground(
      child:Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){
          //     controller.setAssetDataSource('http://hzhls05.ys7.com:7895/openlive/C55600574_1_2.m3u8?ticket=WkJBdE5NU0JxOHI3SU4ySEhJQ0wrWFRvbGVKenZkcitnU01FSThqUEw2TT0kMSQyMDE5MTIwMzA5MjI0MiQxNTc1MjQ5NzMxOTk0JDE1NzUzMzYxNjE5OTQkMSQxNTc1MjQ5NzMxOTk0JDE1NzUzMzYxNjE5OTQkMyRjNjYwZTJmZDIwZDQ0NThhYWNhY2YxMzhjY2MyYjMxZiQz&token=3cde6bd3dbed4e3c9ca28d334415196f');
          //   },
          // ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(widget.title ?? '',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18)),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              // child: buildIjkPlayer(),
              child: WebViewPage('播放器', source),
          ),
        ),
      ),
    );
  }

    Widget buildIjkPlayer() {
    return Container(
      height: 300,
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }

}