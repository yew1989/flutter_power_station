import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/model/station.dart';
import 'package:hsa_app/debug/model/waterTurbines.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
//import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/page/runtime/runtime_tabbar_page.dart';
import 'package:hsa_app/page/station/device/station_device_list_tile.dart';

class StationDeviceList extends StatefulWidget {

  final StationInfo stationInfo;

  const StationDeviceList(this.stationInfo,{Key key}) : super(key: key);
  
  @override
  _StationDeviceListState createState() => _StationDeviceListState();
}

class _StationDeviceListState extends State<StationDeviceList> {

  @override
  void initState() {
    EventBird().on(AppEvent.onTapDevice, (index) { 
      pushToPage(context, RuntimeTabbarPage(waterTurbines: widget?.stationInfo?.waterTurbines ?? null,selectIndex: index));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final wt = widget?.stationInfo?.waterTurbines ?? new List<WaterTurbine>();
    List<WaterTurbine> waterTurbines = [];
    wt.map((w){
      if(w.deviceTerminal != null){
        waterTurbines.add(w);
      }
    }).toList(); 

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: waterTurbines?.length ?? 0,
        itemBuilder: (context, index) => StationDeviceListTile(waterTurbines[index],index),
      ),
    );
  }
}