import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:hsa_app/page/station/station_power_widget.dart';
import 'package:hsa_app/page/station/station_profit_widget.dart';
import 'package:hsa_app/page/station/station_wave_widget.dart';

// 大水池 = 水池 + 波浪 + 功率展示 + 收益值动画
class StationBigPool extends StatefulWidget {
  
  final StationInfo stationInfo;
  final List<num> profitList;

  const StationBigPool({Key key,this.stationInfo,this.profitList}) : super(key: key);
  
  @override
  _StationBigPoolState createState() => _StationBigPoolState();
}

class _StationBigPoolState extends State<StationBigPool> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('StationBigPool 释放OK');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final stationInfo = widget?.stationInfo;

    final profit = widget?.profitList ?? [0.0,0.0];
    return Container(
      height: 266,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          // 波浪组件
          StationWaveWidget(stationInfo),
          // 富文本收益值
          StationProfitWidget(profit:profit),
          // 当前功率 / 总功率
          Positioned(right: 10,bottom: 15,child: StationPowerWidget(stationInfo)),
          // 底部分割线
          Positioned(left: 0,right: 0,bottom: 0,child: SizedBox(height: 2,child: Container(color: Colors.white54)),
          ),
        ],
      ),
    );
  }


}