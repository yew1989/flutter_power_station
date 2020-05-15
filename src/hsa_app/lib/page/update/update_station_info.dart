import 'package:flutter/material.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:hsa_app/page/update/update_device_list.dart';
import 'package:hsa_app/service/life_cycle/lifecycle_state.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ovprogresshud/progresshud.dart';

class UpdateStationInfoPage extends StatefulWidget {
  
  final String stationId;
  //final CaiyunWeatherData weather;
  UpdateStationInfoPage(this.stationId);

  @override
  _UpdateStationInfoPageState createState() => _UpdateStationInfoPageState();
}

class _UpdateStationInfoPageState extends LifecycleState<UpdateStationInfoPage> {
  
  StationInfo stationInfo = StationInfo();
  
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // 实时有功和收益任务


  int currentIndex;
  StationInfo currentStation;

 @override
  void onResume() {
    super.onResume();
    //getRealtimeData();
  }

  @override
  void onPause() {
    Progresshud.dismiss();
    super.onPause();
  }

  @override
  void initState() {
    reqeustStationInfo();
    super.initState();
  }

  @override
  void dispose() {
    refreshController?.dispose();
    Progresshud.dismiss();
    super.dispose();
  }

  // 请求电站概要
  void reqeustStationInfo() { 


    Progresshud.showWithStatus('读取数据中...');

    final stationId = widget?.stationId ?? '';

    if (stationId.length == 0) {
      Progresshud.showInfoWithStatus('获取电站信息失败');
      return;
    }
    APIStation.getStationInfo(stationNo:stationId,
      isIncludeCustomer:true,
      isIncludeWaterTurbine:true,
      isIncludeFMD:true,
      isIncludeLiveLink:true,
      isIncludeOtherTerminal:true,

      onSucc: (StationInfo station) {
      
      station  = station;

      Progresshud.dismiss();
      refreshController.refreshCompleted();

      if (station == null) return;
      if(mounted) {
        setState(() {
          this.stationInfo = station;
        });
      }
    }, onFail: (String msg) {
      refreshController.refreshFailed();
      Progresshud.showInfoWithStatus('获取电站信息失败');
    });
  }
  
  // 分割线
  Widget divLine(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }

  @override
  Widget build(BuildContext context) {

    return ThemeGradientBackground(
      child: Stack(
        children:[
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,elevation: 0,centerTitle: true,
              title: Text(stationInfo?.stationName ?? '',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
            ),
            body: Container(
              child: SmartRefresher(
                header: appRefreshHeader(),
                enablePullDown: true,
                onRefresh: reqeustStationInfo,
                controller: refreshController,
                child: ListView(
                  children: <Widget>[
                    
                    SizedBox(height: 10,),
                    
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        Text('电站信息',style: TextStyle(color: Colors.white,fontSize: 20),),
                      ],
                    ),
                    divLine(0),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('电站名称: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(stationInfo?.stationName ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('电站编号: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(stationInfo?.stationNo ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    SizedBox(height: 30,),
                    
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        Text('终端信息',style: TextStyle(color: Colors.white,fontSize: 20),),
                      ],
                    ),
                    divLine(0),
                    SizedBox(height: 10,),
                    //StationBigPool(stationInfo:stationInfo,profitList:profitList),
                    //StationListHeader(widget.weather.name, liveLinkList, stationInfo.stationName),
                    UpdateDeviceList(stationInfo),
                  ],
                ),
              ),
            )
          )
        ]
      )
    );
  }
}
