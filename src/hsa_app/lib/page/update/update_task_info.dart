import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent_timer_tasker.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/api/apis/api_update.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/service/life_cycle/lifecycle_state.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:native_color/native_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ovprogresshud/progresshud.dart';

class UpdateTaskInfoPage extends StatefulWidget {
  
  final String deviceUpgradeMissionId;
  UpdateTaskInfoPage(this.deviceUpgradeMissionId);

  @override
  _UpdateTaskInfoPageState createState() => _UpdateTaskInfoPageState();
}

class _UpdateTaskInfoPageState extends LifecycleState<UpdateTaskInfoPage> {
  
  UpdateTask updateTask = UpdateTask();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  GetUpgradeMissionStateSingle getUpgradeMissionStateSingle = GetUpgradeMissionStateSingle(); 
  DeviceTerminal deviceTerminal = DeviceTerminal();
  bool isProcessing = false;

  @override
  void onPause() {
    Progresshud.dismiss();
    super.onPause();
  }

  @override
  void initState() {
    super.initState();
    reqeustUpdateTaskInfo();
  }

  @override
  void dispose() {
    Progresshud.dismiss();
    getUpgradeMissionStateSingle?.dispose();
    super.dispose();
  }

   static String _changeENtoZH(String state){
    String str = '';
    switch (state) {
      case 'Ready' : str = '任务就绪'; break;
      case 'TaskSuspended' : str = '任务挂起'; break;
      case 'TaskProcessing' : str = '正在升级'; break;
      case 'TaskCompleted' : str = '任务完成'; break;
      case 'TaskCancelled' : str = '任务取消'; break;
      case 'TaskConflict' : str = '任务冲突'; break;
      case 'UpgradeFileBeChanged' : str = '文件被修改'; break;
      case 'UpgradeFileNoExist' : str = '文件不存在'; break;
      case 'UpgradeFileCrcCheckFail' : str = '(文件)校验失败'; break;
      case 'UpgradeFileBeRefuse' : str = '终端拒绝'; break;
    }
    return str;
  }

  // 获取任务详情
  void reqeustUpdateTaskInfo() { 

    Progresshud.showWithStatus('读取数据中...');

    final upgradeMissionId = widget?.deviceUpgradeMissionId ?? '';

    if (upgradeMissionId.length == 0) {
      Progresshud.showInfoWithStatus('获取电站信息失败');
      return;
    }
    APIUpdate.upgradeTaskInfo(
      upgradeMissionId:upgradeMissionId,
      onSucc: (updateTask) {
      
      this.updateTask = updateTask;
      deviceTerminalInfo(updateTask.terminalAddress);
      isProcessing = 'Ready' == updateTask.upgradeTaskState || 'TaskSuspended' == updateTask.upgradeTaskState || 'TaskProcessing' == updateTask.upgradeTaskState ;
      Progresshud.dismiss();

      if (updateTask == null) return;
      if(mounted) {
        setState(() {
          this.updateTask = updateTask;
          if(isProcessing){
            runningTime(updateTask.deviceUpgradeMissionId);
          }
        });
      }
    }, onFail: (String msg) {
      Progresshud.showInfoWithStatus('获取电站信息失败');
    });
  }

  //获取终端信息
  void deviceTerminalInfo(String terminalAddress){
    APIStation.getDeviceTerminalInfo(
      terminalAddress:terminalAddress,
      isIncludeCustomer:true,
      isIncludeWaterTurbine:true,

      onSucc: (DeviceTerminal deviceTerminal) {
      
      deviceTerminal  = deviceTerminal;

      Progresshud.dismiss();
      refreshController.refreshCompleted();

      if (deviceTerminal == null) return;
      if(mounted) {
        setState(() {
          this.deviceTerminal = deviceTerminal;
        });
      }
    }, onFail: (String msg) {
      refreshController.refreshFailed();
      Progresshud.showInfoWithStatus('获取终端信息失败');
    });
  }

  //取消升级api
  void cancelUpgradeMission(BuildContext context){
    APIUpdate.cancelUpgradeMission(
      upgradeMissionId : updateTask.deviceUpgradeMissionId,
      onSucc: (msg,_){
        setState(() {
          Navigator.pop(context);
        });
      } ,
      onFail: (msg){

      }
    );
  }

  //获取实时进度
  void runningTime(String upgradeMissionId){
    getUpgradeMissionStateSingle.listen(
      upgradeMissionId,
      AppConfig.getInstance().deviceQureyTimeInterval, 
      (updateTask) { 
        setState(() {
           this.updateTask = updateTask;
           this.isProcessing = 'Ready' == updateTask.upgradeTaskState || 'TaskSuspended' == updateTask.upgradeTaskState || 'TaskProcessing' == updateTask.upgradeTaskState ;
        });
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
    String hardwareVersion = deviceTerminal.hardwareVersion ?? '';
    List<String> list = List<String>();
    String hardwareVersion1 = '';
    String hardwareVersion2 = '';

    if(hardwareVersion != null){
      list = hardwareVersion.split('>');
      if(list.length > 0){
        for(int i = 0 ; i < list.length - 1 ; i ++){
          hardwareVersion1 = hardwareVersion1 + list[i] + '>';
        }
        hardwareVersion2 = list[list.length - 1];
      }
    }

    return ThemeGradientBackground(
      child: Stack(
        children:[
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,elevation: 0,centerTitle: true,
              title: Text('任务详情',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
            ),
            body: Container(
              child: SmartRefresher(
                header: appRefreshHeader(),
                enablePullDown: true,
                onRefresh: reqeustUpdateTaskInfo,
                controller: refreshController,
                child: ListView(
                  children: <Widget>[
                    
                    SizedBox(height: 10,),
                    
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        Text('任务信息',style: TextStyle(color: Colors.white,fontSize: 20),),
                      ],
                    ),
                    divLine(0),
                    SizedBox(height: 10,),
                    // Row(
                    //   children: [
                    //     SizedBox(width: 25,),
                    //     Text('任务编号: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     SizedBox(width: 30,),
                    //     Text(updateTask?.deviceUpgradeMissionId ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                    //   ],
                    // ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('任务状态: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(_changeENtoZH(updateTask?.upgradeTaskState ?? ''),style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('任务创建时间: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(updateTask?.missionCreateTime ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('任务结束时间: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(updateTask?.missionStopTime ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('任务提交人: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(updateTask?.initiatorAccountName ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((updateTask?.progressValue ?? 0.0).toString() + '%',style: TextStyle(color: Colors.white,fontSize: 30),),
                        SizedBox(width: 30,),
                        cancelButton(context),
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
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('终端名称: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(deviceTerminal.deviceName ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('终端号: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(deviceTerminal.terminalAddress?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('终端类型: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(deviceTerminal.deviceType ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('终端版本: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                        Text(deviceTerminal.deviceVersion ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text('硬件版本: ',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 40,),
                        Expanded(
                          child:Text(hardwareVersion1 ?? '',style: TextStyle(color: Colors.white,fontSize: 15),overflow: TextOverflow.visible,maxLines: 2,),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 40,),
                        Expanded(
                          child:Text(hardwareVersion2 ?? '',style: TextStyle(color: Colors.white,fontSize: 15),overflow: TextOverflow.visible,maxLines: 2,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          )
        ]
      )
    );
  }
  
  //取消任务 返回按键
  Widget cancelButton(BuildContext context){
    return SizedBox(
      height: 40,
      width: 150,
      child:  FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        splashColor: Colors.white,
        color: HexColor('6699ff'),
        child: Text(isProcessing ? '取消升级' : '返回',style: TextStyle(color: Colors.white  ,fontSize: 20),), 
        onPressed: () {  
          setState(() {
            isProcessing ? 
              showAlertViewDouble(
                context,'取消升级','确认是否取消当前升级任务?',
                () {
                  setState(() {
                    cancelUpgradeMission(context);
                  });
                }
              )
              :Navigator.pop(context);
          });
        },
      )
    );
  }
}
