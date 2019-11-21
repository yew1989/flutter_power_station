import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/framework/wave_ball.dart';
import 'package:hsa_app/page/station/station_page.dart';
import 'package:hsa_app/util/public_tool.dart';

typedef OnTapCollocted ();

class HomeStationTileNoStar extends StatefulWidget {

  final Station data;
  const HomeStationTileNoStar({Key key, this.data}) : super(key: key);
  
  @override
  _HomeStationTileNoStarState createState() => _HomeStationTileNoStarState();
  
}

class _HomeStationTileNoStarState extends State<HomeStationTileNoStar> {
  @override
  Widget build(BuildContext context) {
    var station = widget.data;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(27, 25, 35, 1),
        borderRadius:BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      height: 188,
      child: GestureDetector(
        onTap: () {
          var rawId = station.hydropowerStationCodeID ?? '';
          var customId = station.customerCodeID ?? '';
          var list = rawId.split(customId);
          var stationId = list.last;
          pushToPage(context,StationPage(station.stationName, station.customerCodeID, stationId));
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              // 左侧
              Expanded(
                flex: 100,
                child: Container(
                  child: Center(
                    child: SizedBox(
                      height: 100,width: 100,
                      child: WaveBall(),
                    ),
                  ),
                ),
              ),

              // 右侧
              Expanded(
                flex: 120,
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      // 右侧布局
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Center(child: Text('${station.stationName}',style: TextStyle(fontSize: 20, color: Colors.white))),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                // 在线 or 离线 状态
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    // 链接状态
                                    station.isConnected
                                    ? Icon(Icons.link,
                                        size: 40, color: Colors.white)
                                    : Icon(Icons.link_off,
                                        size: 40, color: Colors.white),
                                    // 文字
                                    Text(station.isConnected ? '在线' :'离线'),
                                  ],
                                ),

                                // 报警.事件
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    
                                     // 警告标识
                                    Badge(badgeContent: Text('8',style: TextStyle(color: Colors.white)),
                                    child: Icon(Icons.add_alert,size: 40, color: Colors.white)),
                                    // 文字
                                    Text('报警'),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

