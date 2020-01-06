import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/segment_control.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:hsa_app/page/history/history_event_tile.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:native_color/native_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        body: Container(
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
    );
  }

  Widget chartGraphWidget() {
    return Container(
      height: 400,
      color: HexColor('1affffff'),
      child: SfCartesianChart(
          zoomPanBehavior:ZoomPanBehavior(enablePinching: true, enablePanning: true),
          title: ChartTitle(
              text: ' ',
              alignment: ChartAlignment.center,
              borderColor: Colors.transparent,
              borderWidth: 0),
          primaryXAxis: NumericAxis(
            labelStyle: ChartTextStyle(
              color: Colors.white),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: ChartTextStyle(
              color: Colors.white),
          ),
          series: getRandomData()),
    );
  }

  static List<ChartSeries> getRandomData() {

    final chartData1 = <ActivePowerPoint>[
      ActivePowerPoint(0, 40),
      ActivePowerPoint(10, 30),
      ActivePowerPoint(20, 32),
      ActivePowerPoint(30, 33),
      ActivePowerPoint(40, 40),
      ActivePowerPoint(50, 45),
      ActivePowerPoint(60, 40),
      ActivePowerPoint(70, 42),
      ActivePowerPoint(80, 40),
      ActivePowerPoint(90, 35),
      ActivePowerPoint(100, 30),
      ActivePowerPoint(110, 32),
      ActivePowerPoint(120, 31),
      ActivePowerPoint(130, 38),
      ActivePowerPoint(140, 42),
      ActivePowerPoint(150, 45),
      ActivePowerPoint(160, 41),
      ActivePowerPoint(170, 40),
      ActivePowerPoint(180, 38),
      ActivePowerPoint(190, 36),
      ActivePowerPoint(200, 35),
    ];

    final chartData2 = <ActivePowerPoint>[
      ActivePowerPoint(0, 20),
      ActivePowerPoint(10, 15),
      ActivePowerPoint(20, 12),
      ActivePowerPoint(30, 16),
      ActivePowerPoint(40, 15),
      ActivePowerPoint(50, 22),
      ActivePowerPoint(60, 21),
      ActivePowerPoint(70, 20),
      ActivePowerPoint(80, 22),
      ActivePowerPoint(90, 21),
      ActivePowerPoint(100, 14),
      ActivePowerPoint(110, 15),
      ActivePowerPoint(120, 18),
      ActivePowerPoint(130, 19),
      ActivePowerPoint(140, 13),
      ActivePowerPoint(150, 12),
      ActivePowerPoint(160, 20),
      ActivePowerPoint(170, 18),
      ActivePowerPoint(180, 22),
      ActivePowerPoint(190, 24),
      ActivePowerPoint(200, 19),
    ];
    

    return <ChartSeries>[

      SplineSeries<ActivePowerPoint, num>(
          animationDuration: 5000,
          dataSource: chartData1,
          splineType: SplineType.natural,
          color: HexColor('ee2e3b'),
          xValueMapper: (ActivePowerPoint sales, _) => sales.minute,
          yValueMapper: (ActivePowerPoint sales, _) => sales.value,
      ),

      SplineAreaSeries<ActivePowerPoint, num>(
          animationDuration: 5000,
          dataSource: chartData2,
          borderDrawMode: BorderDrawMode.excludeBottom,
          gradient: LinearGradient(
            colors: [
              HexColor('0003a9f4'),
              HexColor('9903a9f4'),
            ]
          ),
          xValueMapper: (ActivePowerPoint sales, _) => sales.minute,
          yValueMapper: (ActivePowerPoint sales, _) => sales.value,
      ),

    ];
  }

  Widget divLine() {
    return Container(height: 1, color: Colors.white30);
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
        tabs: <String>['日', '周', '月', '年'],
      ),
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
            itemBuilder: (ctx, index) => HistoryEventTile(
                event: EventTileData('ERC 三相电压不平衡', '2019-08-05')),
            itemCount: 20));
  }
}



class ActivePowerPoint {
  ActivePowerPoint(this.minute, this.value);
  final num minute;
  final int value;
}
