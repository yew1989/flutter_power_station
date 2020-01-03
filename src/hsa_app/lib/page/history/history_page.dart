import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/segment_control.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:hsa_app/page/history/history_event_tile.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          title: Text('历史曲线',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 18)),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                segmentWidget(),
                chartGraphWidget(),
                eventListViewHeader(),
                divLine(),
                eventListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget divLine() {
    return  Container(height: 1, color: Colors.white30);
  }

  Widget chartGraphWidget() {
    return Container(height: 300, color: Colors.blueAccent);
  }

  Widget segmentWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      height: 40,
      child: SegmentControl(
        radius: 4,
        activeTitleStyle: TextStyle(fontSize: 14),
        normalTitleStyle: TextStyle(fontSize: 14),
        activeTitleColor: Colors.white,
        borderColor: Colors.white54,
        normalTitleColor: Colors.white,
        normalBackgroundColor: Colors.transparent,
        activeBackgroundColor: Color.fromRGBO(72, 114, 222, 1),
        selected: (int value, String valueM) {
          debugPrint(valueM);
          debugPrint(value.toString());
        }, 
        tabs: <String>[
          '日','周','月','年'
        ],),
    );
  }

  Widget eventListViewHeader() {
    return Container(
        height: 46,
        color: Colors.transparent,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text('  系统日志',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ))));
  }

  Widget eventListView() {
    return Expanded(
        child: ListView.builder(
            itemBuilder: (ctx, index) =>
                HistoryEventTile(event: EventTileData('ERC 三相电压不平衡', '2019-08-05')),
            itemCount: 20));
  }
}
