import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:hsa_app/page/station/station_power_widget.dart';
import 'package:hsa_app/page/station/station_profit_widget.dart';
import 'package:hsa_app/page/station/station_wave_widget.dart';

class StationBigPool extends StatefulWidget {
  
  final StationInfo stationInfo;
  final List<num> profitList;

  const StationBigPool({Key key,this.stationInfo,this.profitList}) : super(key: key);
  
  @override
  _StationBigPoolState createState() => _StationBigPoolState();
}

class _StationBigPoolState extends State<StationBigPool> {

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
          Positioned(
            right: 10,bottom: 15,
            child: StationPowerWidget(stationInfo)
          ),
          // 底部分割线
          Positioned(
            left: 0,right: 0,bottom: 0,
            child: SizedBox(height: 2,child: Container(color: Colors.white54)),
          ),


          // 渐变条左边水库
          //  Positioned(
          //   left: 0,bottom: 0,
          //   child: SizedBox(
          //     height: 160,
          //     width: 23,
          //     child: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)],
          //           begin:Alignment.topCenter,
          //           end:Alignment.bottomCenter

          //         ),
          //       ),
          //     )),
          // ),

          // 渐变条右边尾水
          //  Positioned(
          //   right: 0,bottom: 0,
          //   child: SizedBox(
          //     height: 130,
          //     width: 23,
          //     child: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)],
          //           begin:Alignment.topCenter,
          //           end:Alignment.bottomCenter

          //         ),
          //       ),
          //     )),
          // ),


          /*
          // 左侧水库图片
          Positioned(
            left: 0,bottom: 12,
            child: SizedBox(
              height: 186,
              width: 33,
              child: Image.asset('images/station/GL_Water_Line.png')),
          ),


          // 水库文本
          Positioned(
            left: 0,bottom: 200,
            child: Text('水库',style: TextStyle(color: Colors.white,fontSize: 13),
            ),
          ),
          
          // 右侧尾水图片
          Positioned(
            right: 0,bottom: 12,
            child: SizedBox(
              height: 186,
              width: 33,
              child: Image.asset('images/station/GL_Water_Line2.png')),
          ), 

          // 尾水文本
          Positioned(
            right: 0,bottom: 200,
            child: Text('尾水',style: TextStyle(color: Colors.white,fontSize: 13),
            ),
          ),
          */

        ],
      ),
    );
  }


}