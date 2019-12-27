import 'package:flutter/material.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/page/station/device/station_device_list_tile.dart';

class StationDeviceList extends StatefulWidget {

  final StationInfo stationInfo;

  const StationDeviceList(this.stationInfo,{Key key}) : super(key: key);
  
  @override
  _StationDeviceListState createState() => _StationDeviceListState();
}

class _StationDeviceListState extends State<StationDeviceList> {
  @override
  Widget build(BuildContext context) {
    final stationInfo = widget.stationInfo;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stationInfo?.devices?.length ?? 0,
          itemBuilder: (context, index) => StationDeviceListTile(stationInfo?.devices[index],index),
        ),
    );
  }
}