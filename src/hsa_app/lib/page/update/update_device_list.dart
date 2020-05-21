import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:hsa_app/page/update/update_device_info.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';

class UpdateDeviceList extends StatefulWidget {

  final StationInfo stationInfo;

  const UpdateDeviceList(this.stationInfo,{Key key}) : super(key: key);
  
  @override
  _UpdateDeviceListState createState() => _UpdateDeviceListState();
}

class _UpdateDeviceListState extends State<UpdateDeviceList> {

  StationInfo stationInfo = StationInfo(); 
  int wlength;
  int fmdlength;
  int otherlength;
  double width = 375.0;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //调整电站数据 确保终端数量正确
  StationInfo filtUnBindDevices(StationInfo station) {
    var result = station;
    List<WaterTurbine> turbines = [];
    for (var turbine in station.waterTurbines) {
      if(turbine.deviceTerminal != null) {
        turbines.add(turbine);
      }
    }
    if(station.waterTurbines.length > 0) {
       result.waterTurbines = turbines;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    this.stationInfo = widget?.stationInfo;
    if(stationInfo.waterTurbines != null){
      this.stationInfo = filtUnBindDevices(this.stationInfo);
    }
   
    wlength = stationInfo?.waterTurbines?.length ?? 0 ;
    fmdlength = stationInfo?.deviceTerminalsOfFMD?.length ?? 0; 
    otherlength =  stationInfo?.deviceTerminalsOfOther?.length ?? 0;
    width = MediaQuery.of(context).size.width;

    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: wlength + fmdlength + otherlength,
        itemBuilder: (context, index) => deviceTerminalTile(context,index),
      ),
    );
  }

  //终端列表
  Widget deviceTerminalTile(BuildContext context, int index) {
    DeviceTerminal deviceTerminal = DeviceTerminal(); 
    String name = '';
    String dtNo = '';
    bool isOnline = false;
    String tpye = '';
    String version = '';

    if(index < wlength){
      deviceTerminal = stationInfo?.waterTurbines[index]?.deviceTerminal ?? DeviceTerminal();
      name = deviceTerminal?.deviceType ?? '';
      isOnline = deviceTerminal?.isOnLine ?? false;
      dtNo = deviceTerminal?.terminalAddress ?? '';
      tpye = deviceTerminal?.deviceVersion ?? '';
      version = deviceTerminal?.hardwareVersion ?? '';
    }else if(index < wlength + fmdlength){
      deviceTerminal = stationInfo?.deviceTerminalsOfFMD[index - wlength] ?? DeviceTerminal();
      name = deviceTerminal?.deviceType ?? '';
      isOnline = deviceTerminal?.isOnLine ?? false;
      dtNo = deviceTerminal?.terminalAddress ?? '';
      tpye = deviceTerminal?.deviceVersion ?? '';
      version = deviceTerminal?.hardwareVersion ?? '';
    }else if(index < wlength + fmdlength + otherlength){
      deviceTerminal = stationInfo?.deviceTerminalsOfOther[index - (wlength + fmdlength)] ?? DeviceTerminal();
      name = deviceTerminal?.deviceType ?? '';
      isOnline = deviceTerminal?.isOnLine ?? false;
      dtNo = deviceTerminal?.terminalAddress ?? '';
      tpye = deviceTerminal?.deviceVersion ?? '';
      version = deviceTerminal?.hardwareVersion ?? '';
    }

    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          Container(
            alignment:Alignment.center,
            child: SizedBox(
                height: 65,
                child: tileTop(name,dtNo,isOnline,tpye,version),
            ),
          ),
          GestureDetector(
            onTap: (){
              pushNewScreen(
                context,
                screen: UpdateDeviceInfoPage(dtNo),
                platformSpecific: false, 
                withNavBar: true, 
              );
            },
          ),
        ],
      ),
    );
  }

  
  Widget tileTop(String name ,String dtNo,bool isOnline,String tpye,String version) {  
    String hardwareVersion1 = '';
    String hardwareVersion2 = '';

    if(version != null){
      var list = version.split('>');
      if(list.length > 0){
        for(int i = 0 ; i < list.length - 1 ; i ++){
          hardwareVersion1 = hardwareVersion1 + list[i] + '>';
        }
        hardwareVersion2 = list[list.length - 1];
      }
    }

    return SizedBox(
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 行
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(name ?? '',style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(width: 15),
              Text(dtNo ?? '',style: TextStyle(color: Colors.white54, fontSize: 12)),
              SizedBox(width: 15),
              Text(tpye ?? '',style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width:width*2/3-20,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(hardwareVersion1 ?? '',style: TextStyle(color: Colors.white54,fontSize: 12),overflow: TextOverflow.visible,maxLines: 1,),
                    Text(hardwareVersion2 ?? '',style: TextStyle(color: Colors.white54,fontSize: 12),overflow: TextOverflow.visible,maxLines: 1,),
                  ],
                ),
              ),
              SizedBox(
                width:width*1/3-20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20,width: 20,
                      child: isOnline 
                      ? Image.asset('images/home/Home_online_icon.png')
                      : Image.asset('images/home/Home_offline_icon.png'),
                    ),
                    SizedBox(width: 8),
                    Text(isOnline ? '在线' : '离线',style: TextStyle(color: isOnline ? Colors.white : Colors.grey ,fontSize: 15)),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: Image.asset('images/mine/My_next_btn.png'),
                    ),
                  ]
                ),
              ),
            ],
          ),
          // 底部分割线
          SizedBox(height: 1, child: Container(color: Colors.white24)),
        ],
      ),
    );
  }
  

  
  
}
