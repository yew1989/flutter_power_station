import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/station.dart';
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
        itemBuilder: (context, index) => StationDeviceListTile(waterTurbines[index],index,(){
            pushToPage(context, RuntimeTabbarPage(waterTurbines: widget?.stationInfo?.waterTurbines ?? null,selectIndex: index,stationInfo:widget?.stationInfo));
        }),
      ),
    );
  }
}