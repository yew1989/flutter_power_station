import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:hsa_app/components/empty_page.dart';
import 'package:hsa_app/components/segment_control.dart';
import 'package:hsa_app/components/spinkit_indicator.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/history_point.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:hsa_app/page/history/history_calendar_bar.dart';
import 'package:hsa_app/page/history/history_event_tile.dart';
import 'package:hsa_app/page/history/history_pop_dialog.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:native_color/native_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @required final StationInfo stationInfo;
  final String address;
  final String title;
  //final double ratedActivePower;
  //final double waterStageAlarmValue;

  const HistoryPage({Key key, this.address,this.stationInfo, this.title}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  List<TerminalAlarmEvent> showEvents = List<TerminalAlarmEvent>();
  List<WaterLevel> waterLevelList = List<WaterLevel>();
  List<Turbine> turbinelList = List<Turbine>();
  int segmentIndex = 0;

  // 时间
  String startDateTime;
  String endDateTime;
  // 事件标志
  String ercFlag = '0';

  // 是否空视图
  bool isEventEmpty = false;
  // 是否首次数据加载完毕
  bool isEventLoadFinsh = false;

  bool isChartLoadFinsh = false;

  List<ERCFlagType> evnetTypes = List<ERCFlagType>();

  // 曲线点
  List<DateValuePoint> points = List<DateValuePoint>();

  // 获取日期格式化
  DateFormat getDateFormat() {
    if(segmentIndex == 0) return DateFormat.Hm();
    if(segmentIndex == 1) return DateFormat.Md();
    if(segmentIndex == 2) return DateFormat.Md();
    if(segmentIndex == 3) return DateFormat.Md();
    return DateFormat.Md();
  }

  // 获取事件类型
  void reqeustGetEventTypes() {
    API.getErcFlagTypeList(type: '0',onSucc: (types){
      this.evnetTypes = types;
    },onFail: (msg){

    });

    // API.eventTypes((types) {
    //   this.evnetTypes = types;
    // }, (_) {});
  }

  @override
  void initState() {
    super.initState();
    reqeustGetEventTypes();
    requestTodayData();
    addObserverEventFilterChoose();
  }

  @override
  void dispose() {
    EventBird().off(AppEvent.eventFilterChoose);
    super.dispose();
  }

  // 监听事件过滤选择器
  void addObserverEventFilterChoose() {
    EventBird().on(AppEvent.eventFilterChoose, (flag) {
      if (flag == '') return;
      this.ercFlag = flag;
      requestEventListData();
    });
  }

  // 获取当天数据
  void requestTodayData() {

    var now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    final end   = formatDate(DateTime(year, month, day), [yyyy, '-', mm, '-', dd]);
    final start = formatDate(DateTime(year, month, day),[yyyy, '-', mm, '-', dd]);
    this.startDateTime = start;
    this.endDateTime = end;

    requestEventListData();
    requestChartHistory();
  }

  // 获取事件列表
  void requestEventListData() {

    this.isEventEmpty = false;
    this.isEventLoadFinsh = false;
    final stationNos = widget?.stationInfo?.stationNo ?? '';
    final address = widget?.address ?? '';
    var apiStartDateTime = startDateTime + '  00:00:00';
    var apiEndDateTime = endDateTime + '  23:59:59';
    
    API.getTerminalAlertList(
      onSucc: (events){
        this.isEventLoadFinsh = true;

        if (events.length == 0) {
          this.isEventEmpty = true;
        }
        setState(() {
          this.showEvents = events;
        });
      },onFail: (msg){

      },
      searchDirection : 'Backward',
      endDateTime : apiEndDateTime,
      stationNos : stationNos,
      terminalAddress : address,
      limitSize : 10,
    );
    

    // API.eventList(address, apiStartDateTime, apiEndDateTime, (events) {
    //   this.isEventLoadFinsh = true;

    //   if (events.length == 0) {
    //     this.isEventEmpty = true;
    //   }
    //   setState(() {
    //     this.showEvents = events;
    //   });
    // }, (msg) {
    //   debugPrint(msg);
    // },ercFlag: this.ercFlag);


  }

  // 获取曲线列表图
  void requestChartHistory() {

    this.isChartLoadFinsh = false;
    final stationInfo = widget.stationInfo;
    //final address = widget.address ?? '';
    var  apiStartDateTime = startDateTime + ' 00:00:00';
    var  apiEndDateTime = endDateTime + ' 23:59:59';

    final now = DateTime.now();
    final will = DateTime.parse(apiEndDateTime);

    if(will.isAfter(now)) {
      apiEndDateTime = formatDate(now, [yyyy, '-', mm, '-', dd,' ',hh, ':', nn, ':', ss]);
    }

    API.getTurbineWaterAndPowerAndState(stationNo: stationInfo.stationNo,
      startDateTime:apiStartDateTime,endDateTime:apiEndDateTime,
      onSucc: (turbinelist){
      
      this.isChartLoadFinsh = true;

      setState(() {
        this.turbinelList = turbinelist;
        
        final tkWMax = stationInfo.totalEquippedKW;
        final waterStageMax = stationInfo.reservoirAlarmWaterStage;

        List<DateValuePoint> originalPoints = [];
        if(turbinelList != null){
          for(var t in this.turbinelList) {
            var p = HistoryPoint();
            p.tkWMax = tkWMax;
            p.waterStageMax = waterStageMax;
            p.freezeTime = t.freezeTime;
            p.tkW = t.turbineElectricalPower.generatorActivePowerAll;
            p.waterStage = t.turbineRuningStage.measuringWaterLevel;
            originalPoints.add(DateValuePoint.fromPoint(p));
          }
        }
        
        this.points = filterPoint(originalPoints);
      });
    },onFail: (msg){
      debugPrint(msg);    
    });


    


  //   API.historyPowerAndWater(address, apiStartDateTime, apiEndDateTime,(historyResp) {

  //     this.isChartLoadFinsh = true;

  //     setState(() {
  //       this.historyPointResp = historyResp;
        
  //       final tkWMax = this.historyPointResp.ratedActivePower;
  //       final waterStageMax = this.historyPointResp.waterStageAlarmValue;

  //       List<DateValuePoint> originalPoints = [];
  //       for(var p in this.historyPointResp.data) {
  //         p.tkWMax = tkWMax;
  //         p.waterStageMax = waterStageMax;
  //         originalPoints.add(DateValuePoint.fromPoint(p));
  //       }
  //       this.points = filterPoint(originalPoints);
  //     });

  //   }, (msg) {
  //     debugPrint(msg);
  //   });
  }

  // 点过滤
  List<DateValuePoint> filterPoint(List<DateValuePoint> originalPoints) {
    List<DateValuePoint> newPoints = [];
    var weight = 1;
    if(originalPoints.length < 1000){
      weight = 1;
    }
    else if (originalPoints.length >= 1000 && originalPoints.length < 10000){
      weight = 10;
    }
    else if (originalPoints.length >= 10000 && originalPoints.length < 100000){
      weight = 100;
    }
    else if (originalPoints.length >= 100000 && originalPoints.length < 1000000){
      weight = 1000;
    }
    else if (originalPoints.length >= 1000000 && originalPoints.length < 10000000){
      weight = 10000;
    }
    else if (originalPoints.length >= 10000000 && originalPoints.length < 100000000){
      weight = 100000;
    }

    for (int i = 0 ; i < originalPoints.length ; i++) {
      final p = originalPoints[i];
      if(i % weight == 0) {
        newPoints.add(p);
      }
    }
    return newPoints;
  }

  void onTapFilterButton(BuildContext context) {
    if (this.evnetTypes.length == 0) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => HistoryEventDialogWidget(ercFlag: this.ercFlag,eventTypes: this.evnetTypes));
  }

  // 点击了日.周.月.年
  void onTapToggleButton() {
    final now = DateTime.now();

    if (segmentIndex == 0) {
      this.startDateTime = formatDate(now, [yyyy, '-', mm, '-', dd]);
      this.endDateTime = formatDate(now, [yyyy, '-', mm, '-', dd]);
    } else if (segmentIndex == 1) {
      final year = now.year;
      final month = now.month;
      final day = now.day;
      final end =
          formatDate(DateTime(year, month, day), [yyyy, '-', mm, '-', dd]);
      final start = formatDate(
          DateTime(year, month, day).subtract(Duration(days: 6)),
          [yyyy, '-', mm, '-', dd]);
      this.startDateTime = start;
      this.endDateTime = end;
    } else if (segmentIndex == 2) {
      final year = now.year;
      final month = now.month;
      final start = formatDate(DateTime(year, month), [yyyy, '-', mm, '-', dd]);
      final endDate = DateTime(year, month + 1).subtract(Duration(days: 1));
      var end = '';
      if (now.isBefore(endDate)) {
        end = formatDate(now, [yyyy, '-', mm, '-', dd]);
      } else {
        end = formatDate(endDate, [yyyy, '-', mm, '-', dd]);
      }
      this.startDateTime = start;
      this.endDateTime = end;
    } else if (segmentIndex == 3) {
      final year = now.year;
      final start = formatDate(DateTime(year), [yyyy, '-', mm, '-', dd]);
      final endDate = DateTime(year + 1).subtract(Duration(days: 1));
      var end = '';
      if (now.isBefore(endDate)) {
        end = formatDate(now, [yyyy, '-', mm, '-', dd]);
      } else {
        end = formatDate(endDate, [yyyy, '-', mm, '-', dd]);
      }
      this.startDateTime = start;
      this.endDateTime = end;
    }
    requestEventListData();
    requestChartHistory();
  }

  void showPickerPopWindow() {
    final max = DateTime.now();
    final min = max.subtract(Duration(days: 365 * 2));

    // 选择 日
    if (segmentIndex == 0) {
      DatePicker.showDatePicker(context,
          dateFormat: 'yyyy-MM-dd',
          maxDateTime: max,
          minDateTime: min,
          pickerMode: DateTimePickerMode.date,
          pickerTheme: DateTimePickerTheme(
            cancel: Center(
                child: Text('取消',
                    style: TextStyle(color: Colors.white54, fontSize: 18))),
            confirm: Center(
                child: Text('确定',
                    style: TextStyle(color: Colors.white, fontSize: 18))),
            backgroundColor: Color.fromRGBO(53, 117, 191, 1),
            itemTextStyle: TextStyle(
                color: Colors.white, fontFamily: AppTheme().numberFontName, fontSize: 22),
          ), onConfirm: (selectDate, _) {
        setState(() {
          this.startDateTime = formatDate(selectDate, [yyyy, '-', mm, '-', dd]);
          this.endDateTime = formatDate(selectDate, [yyyy, '-', mm, '-', dd]);
        });
        requestEventListData();
        requestChartHistory();
      });
    }
    // 选择 周
    else if (segmentIndex == 1) {
      DatePicker.showDatePicker(context,
          dateFormat: 'yyyy-MM-dd',
          maxDateTime: max,
          minDateTime: min,
          pickerMode: DateTimePickerMode.date,
          pickerTheme: DateTimePickerTheme(
            cancel: Center(
                child: Text('取消',
                    style: TextStyle(color: Colors.white54, fontSize: 18))),
            confirm: Center(
                child: Text('确定',
                    style: TextStyle(color: Colors.white, fontSize: 18))),
            backgroundColor: Color.fromRGBO(53, 117, 191, 1),
            itemTextStyle: TextStyle(
                color: Colors.white, fontFamily: AppTheme().numberFontName, fontSize: 22),
          ), onConfirm: (selectDate, index) {
        final year = selectDate.year;
        final month = selectDate.month;
        final day = selectDate.day;
        final end =
            formatDate(DateTime(year, month, day), [yyyy, '-', mm, '-', dd]);
        final start = formatDate(
            DateTime(year, month, day).subtract(Duration(days: 6)),
            [yyyy, '-', mm, '-', dd]);
        setState(() {
          this.startDateTime = start;
          this.endDateTime = end;
        });
        requestEventListData();
        requestChartHistory();
      });
    }
    // 按月
    else if (segmentIndex == 2) {
      DatePicker.showDatePicker(context,
          dateFormat: 'yyyy-MM',
          maxDateTime: max,
          minDateTime: min,
          pickerMode: DateTimePickerMode.date,
          pickerTheme: DateTimePickerTheme(
            cancel: Center(
                child: Text('取消',
                    style: TextStyle(color: Colors.white54, fontSize: 18))),
            confirm: Center(
                child: Text('确定',
                    style: TextStyle(color: Colors.white, fontSize: 18))),
            backgroundColor: Color.fromRGBO(53, 117, 191, 1),
            itemTextStyle: TextStyle(
                color: Colors.white, fontFamily: AppTheme().numberFontName, fontSize: 22),
          ), onConfirm: (selectDate, index) {
        final year = selectDate.year;
        final month = selectDate.month;
        final start =
            formatDate(DateTime(year, month), [yyyy, '-', mm, '-', dd]);
        final endDate = DateTime(year, month + 1).subtract(Duration(days: 1));
        var end = '';
        if (max.isBefore(endDate)) {
          end = formatDate(max, [yyyy, '-', mm, '-', dd]);
        } else {
          end = formatDate(endDate, [yyyy, '-', mm, '-', dd]);
        }
        setState(() {
          this.startDateTime = start;
          this.endDateTime = end;
        });
        requestEventListData();
        requestChartHistory();
      });
    } else if (segmentIndex == 3) {
      DatePicker.showDatePicker(context,
          dateFormat: 'yyyy',
          maxDateTime: max,
          minDateTime: min,
          pickerMode: DateTimePickerMode.date,
          pickerTheme: DateTimePickerTheme(
            cancel: Center(
                child: Text('取消',
                    style: TextStyle(color: Colors.white54, fontSize: 18))),
            confirm: Center(
                child: Text('确定',
                    style: TextStyle(color: Colors.white, fontSize: 18))),
            backgroundColor: Color.fromRGBO(53, 117, 191, 1),
            itemTextStyle: TextStyle(
                color: Colors.white, fontFamily: AppTheme().numberFontName, fontSize: 22),
          ), onConfirm: (selectDate, index) {
        final year = selectDate.year;
        final start = formatDate(DateTime(year), [yyyy, '-', mm, '-', dd]);
        final endDate = DateTime(year + 1).subtract(Duration(days: 1));
        var end = '';
        if (max.isBefore(endDate)) {
          end = formatDate(max, [yyyy, '-', mm, '-', dd]);
        } else {
          end = formatDate(endDate, [yyyy, '-', mm, '-', dd]);
        }
        setState(() {
          this.startDateTime = start;
          this.endDateTime = end;
        });
        requestEventListData();
        requestChartHistory();
      });
    }
  }

  Widget filterButton() {
    return GestureDetector(
      onTap: () => onTapFilterButton(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 22,
          width: 22,
          child: Image.asset('images/history/History_selt_btn.png'),
        ),
      ),
    );
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
          title: Text('历史分析',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: AppTheme().navigationAppBarFontSize)),
          actions: <Widget>[
            filterButton(),
          ],
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
              eventListView(showEvents),
            ],
          ),
        ),
      ),
    );
  }

  Widget chartGraphWidget() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: HexColor('1affffff'),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          HistoryCalendarBar(
            startDateTime: this.startDateTime,
            endDateTime: this.endDateTime,
            isLoading: this.isChartLoadFinsh,
            onChoose: () => showPickerPopWindow(),
          ),

          Container(
            height: 264,
            child: SfCartesianChart(
                // annotations: [
                //   CartesianChartAnnotation(
                //     widget: 
                //       Container(
                //         child: const Text('Text',style: TextStyle(color: Colors.white,fontSize: 10))
                //       ),
                //     coordinateUnit: CoordinateUnit.logicalPixel,
                //     x: 150,
                //     y: 200,
                //   )
                // ],
                plotAreaBorderWidth: 2,
                plotAreaBorderColor: Colors.transparent,
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  zoomMode: ZoomMode.x,
                ),
                primaryXAxis: DateTimeAxis(
                  axisLine: AxisLine(
                    color: Colors.white60,
                    width: 0.5
                  ),
                  labelStyle: ChartTextStyle(
                    color: Colors.white,
                    fontFamily:'ArialNarrow',
                  ),
                  majorGridLines: MajorGridLines(
                    width: 0,
                  ),
                  minorGridLines: MinorGridLines(
                    width: 0,
                  ),
                  majorTickLines: MajorTickLines(
                    width: 0,
                  ),
                  minorTickLines: MinorTickLines(
                    width: 0,
                  ),
                  dateFormat: getDateFormat(),
                ),
                primaryYAxis: NumericAxis(
                  opposedPosition: true,
                  axisLine: AxisLine(color: Colors.transparent),
                  minimum: 100,
                  labelStyle: ChartTextStyle(
                    color: Colors.white,
                    fontFamily:'ArialNarrow',
                  ),
                  majorTickLines: MajorTickLines(width: 0),
                  majorGridLines: MajorGridLines(
                    width: 0.5,
                    color: Colors.white60,
                  ),
                  minorGridLines: MinorGridLines(width: 0),
                  minorTickLines: MinorTickLines(width: 0),
                ),
                axes:[
                  NumericAxis(
                  name: 'water',
                  opposedPosition: false,
                  axisLine: AxisLine(color: Colors.transparent),
                  minimum: 8,
                  labelStyle: ChartTextStyle(
                    color: Colors.white,
                    fontFamily:'ArialNarrow',
                  ),
                  majorTickLines: MajorTickLines(width: 0),
                  majorGridLines: MajorGridLines(width: 0),
                  minorGridLines: MinorGridLines(width: 0),
                  minorTickLines: MinorTickLines(width: 0),
                ),
                ],
                series: getChartData()),
          ),
        ],
      ),
    );
  }

   List<ChartSeries> getChartData() {

    return <ChartSeries>[
      // 有功曲线
      SplineSeries<DateValuePoint, DateTime>(
        dataSource: points,
        splineType: SplineType.natural,
        color: HexColor('ee2e3b'),
        xValueMapper: (DateValuePoint sales, _) => sales.time,
        yValueMapper: (DateValuePoint sales, _) => sales.tkW,
      ),
      // 水位高度
      SplineAreaSeries<DateValuePoint, DateTime>(
        dataSource: points,
        borderDrawMode: BorderDrawMode.excludeBottom,
        gradient: LinearGradient(
          colors: [HexColor('0003a9f4'),HexColor('9903a9f4')]
        ),
        xValueMapper: (DateValuePoint sales, _) => sales.time,
        yValueMapper: (DateValuePoint sales, _) => sales.waterStage,
        yAxisName: 'water'
      ),
      LineSeries<DateValuePoint, DateTime>(
        dataSource: points,
        dashArray: <double>[10, 10],
        color: Colors.white,
        width: 0.5,
        xValueMapper: (DateValuePoint sales, _) => sales.time,
        yValueMapper: (DateValuePoint sales, _) => sales.tkWMax,
      ),
      LineSeries<DateValuePoint, DateTime>(
        dataSource: points,
        dashArray: <double>[10, 10],
        color: Colors.white,
        width: 0.5,
        xValueMapper: (DateValuePoint sales, _) => sales.time,
        yValueMapper: (DateValuePoint sales, _) => sales.waterStageMax,
        yAxisName: 'water'
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
        selected: (int index, String valueM) {
          segmentIndex = index;
          onTapToggleButton();
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
          child: Text('  系统日志',style: TextStyle(fontSize: 16, color: Colors.white))));
  }

  Widget eventListView(List<TerminalAlarmEvent> events) {
    if (this.isEventLoadFinsh == false)
      return Expanded(child: SpinkitIndicator(title: '正在加载', subTitle: '请稍后'));
    if (this.isEventEmpty == true)
      return Expanded(child: EmptyPage(title: '暂无数据', subTitle: ''));
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          final event = events[index];
          final left = 'ERC${event.eventFlag}--${event.eventTitle}';
          var right = event.eventTime.replaceAll('T', ' ');
          right = right.split(' ').last ?? '';
          return HistoryEventTile(event: EventTileData(left, right));
        },
        itemCount: events.length ?? 0
      )
    );
  }
}

class DateValuePoint {

  DateTime time;
  num tkW;
  num waterStage;
  num tkWMax;
  num waterStageMax;

  DateValuePoint(this.time, {this.tkW,this.waterStage,this.tkWMax,this.waterStageMax});

  DateValuePoint.fromPoint(HistoryPoint point) {
    final freezDate = point.freezeTime.replaceAll('T', ' ');
    DateTime freeze = DateTime.parse(freezDate);
    time = freeze;
    tkW = point?.tkW ?? 1.0;
    waterStage = point?.waterStage ?? 0.0;

    tkWMax = point?.tkWMax ?? 1.0;
    waterStageMax = point?.waterStageMax ?? 0.0;

    if(point.tkW == 0.0) {
      tkW = 1.0;
    }
    if(point?.tkW == null) {
      tkW = 1.0;
    }
  }

}


