import 'package:flutter/material.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/home/view/home_station_tile.dart';

typedef OnTapExpand     = void Function(int tapIndex, bool isOpen);
typedef OnTapColloected = void Function(Station station);

class HomeStationExpandTile extends StatefulWidget {

  final StationSection group;
  final int index;
  final int openExpandIndex;
  final OnTapExpand onTapExpand;
  final OnTapColloected onTapCollected;

  HomeStationExpandTile({Key key, this.group, this.index, this.openExpandIndex, this.onTapExpand, this.onTapCollected}): super(key: key);

  @override
  _HomeStationExpandTileState createState() => _HomeStationExpandTileState();
}

class _HomeStationExpandTileState extends State<HomeStationExpandTile> {
  @override
  Widget build(BuildContext context) {
    return expandTile(widget.group, widget.index, widget.openExpandIndex, widget.onTapExpand,widget.onTapCollected);
  }

  // 展开单元格
  Widget expandTile(StationSection group, int index, int openExpandIndex, 
  OnTapExpand onTapExpand,OnTapColloected onTapCollected) {
    var secName = group?.sectionName ?? '';
    if (secName.length == 0) secName = '未分类';
    var allCnt = group.stations.length;
    var onlineCnt = 0;
    for (var item in group.stations) {
      if (item.isConnected == true) onlineCnt++;
    }
    var rightStr = '$onlineCnt/$allCnt';

    Widget leftWidget(String leftTitle) {
      return Container(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            openExpandIndex == index
                ? Icon(Icons.arrow_drop_down, size: 30, color: Colors.grey)
                : Icon(Icons.arrow_right, size: 30, color: Colors.grey),
            Text(leftTitle),
          ],
        ),
      );
    }

    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white,
      ),
      child: Container(
        child: ExpansionTile(
          trailing: Text(rightStr),
          leading: leftWidget('$secName'),
          onExpansionChanged: (isOpen) {
            if (onTapExpand == null) return;
            onTapExpand(index, isOpen);
          },
          title: null,
          children: group.stations.map((station) {
            return HomeStationTile(
              data: station,
              onTapCollocted: () {
                if(widget.onTapCollected == null) return;
                onTapCollected(station);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
