import 'package:flutter/material.dart';
import 'package:hsa_app/components/dash_board/dash_board_opengate_progress.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'dash_board/dash_board_bg_progress.dart';
import 'dash_board/dash_board_center_label.dart';
import 'dash_board/dash_board_freq_progress.dart';
import 'dash_board/dash_board_power_progress.dart';

class DashBoardWidget extends StatefulWidget {

  final DeviceTerminal deviceTerminal;

  const DashBoardWidget({Key key, this.deviceTerminal}) : super(key: key);
  @override
  _DashBoardWidgetState createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> with TickerProviderStateMixin {

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
    // 功率 now
    var powerNow = widget?.deviceTerminal?.nearestRunningData?.power ?? 0.0;
    var powerNowStr = '0';
    // 展示优化
    if(powerNow < 100) {
       powerNowStr = powerNow.toStringAsFixed(1);
    }
    else {
       powerNowStr = powerNow.toStringAsFixed(0);
    }
    // 功率 max
    var powerMax = widget?.deviceTerminal?.waterTurbine?.ratedPowerKW ?? 0.0;
    var powerMaxStr = powerMax.toStringAsFixed(0) + 'kW';

    return Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
        children: 
        [
          DashBoardPowerProgress(widget?.deviceTerminal),
          DashBoardFreqProgress(widget?.deviceTerminal),
          DashBoardOpenGateProgress(widget?.deviceTerminal),
          DashBoardBgProgress(),
          DashBoardCenterLabel(powerNowStr,powerMaxStr),
        ]),
      );
  }
}