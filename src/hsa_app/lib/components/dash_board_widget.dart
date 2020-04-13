import 'package:flutter/material.dart';
import 'package:hsa_app/components/dash_board/dash_board_opengate_progress.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'dash_board/dash_board_bg_progress.dart';
import 'dash_board/dash_board_center_label.dart';
import 'dash_board/dash_board_freq_progress.dart';
import 'dash_board/dash_board_power_progress.dart';

class DashBoardWidget extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  final List<double> powerNowList;
  final List<double> freqList;
  final List<double> openList;

  const DashBoardWidget({Key key, this.deviceTerminal,this.powerNowList,this.freqList,this.openList}) : super(key: key);
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
    List<double> powerNowList = widget?.powerNowList;
    // 功率 now
    List<double> freqList = widget?.freqList;
    // 功率 now
    List<double> openList = widget?.openList;

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
          DashBoardPowerProgress(widget?.deviceTerminal,powerNowList,5),
          DashBoardFreqProgress(widget?.deviceTerminal,freqList,5),
          DashBoardOpenGateProgress(widget?.deviceTerminal,openList,5),
          DashBoardBgProgress(),
          DashBoardCenterLabel(powerNowList,powerMaxStr),
        ]),
      );
  }
}