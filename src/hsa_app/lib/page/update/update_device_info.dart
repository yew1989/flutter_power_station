import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_update.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/station.dart';
import 'package:hsa_app/page/update/update_choose_file.dart';
import 'package:hsa_app/service/life_cycle/lifecycle_state.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:native_color/native_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ovprogresshud/progresshud.dart';

class UpdateDeviceInfoPage extends StatefulWidget {
  
  final String terminalAddress;
  UpdateDeviceInfoPage(this.terminalAddress);

  @override
  _UpdateDeviceInfoPageState createState() => _UpdateDeviceInfoPageState();
}

class _UpdateDeviceInfoPageState extends LifecycleState<UpdateDeviceInfoPage> {
  
  DeviceTerminal deviceTerminal = DeviceTerminal();
  
  RefreshController refreshController = RefreshController(initialRefresh: false);

  //是否已选择文件
  bool isChoosedFile = false;

  UpdateFile updateFile = UpdateFile();

  int currentIndex;
  StationInfo currentStation;

 @override
  void onResume() {
    super.onResume();
  }

  @override
  void onPause() {
    Progresshud.dismiss();
    super.onPause();
  }

  @override
  void initState() {
    reqeustDeviceTerminalInfo();
    super.initState();
  }

  @override
  void dispose() {
    refreshController?.dispose();
    Progresshud.dismiss();
    super.dispose();
  }

  void _pushUpgradeFile(String upgradeFileId,String terminalAddress){
    APIUpdate.pushUpgradeFile(
      upgradeFileId : upgradeFileId,
      terminalAddress : terminalAddress,
      onSucc: (msg,_){
        if(msg){
          showToast('成功添加升级任务！');
          eventBird?.emit('TaskReady');
        }else{
          showToast('已有正在升级任务！');
        }
      },
      onFail: (_){
        showToast('添加升级任务失败！');
      }
    );
  }

  // 请求终端信息
  void reqeustDeviceTerminalInfo() async { 

    Progresshud.showWithStatus('读取数据中...');

    final terminalAddress = widget?.terminalAddress ?? '';

    if (terminalAddress.length == 0) {
      Progresshud.showInfoWithStatus('获取终端信息失败');
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.pop(context);
      return;
    }
    APIStation.getDeviceTerminalInfo(terminalAddress:terminalAddress,
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
      Navigator.pop(context);
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
              title: Text(deviceTerminal.deviceName ?? '',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
            ),
            body: Container(
              child: SmartRefresher(
                header: appRefreshHeader(),
                enablePullDown: true,
                onRefresh: reqeustDeviceTerminalInfo,
                controller: refreshController,
                child: ListView(
                  children: <Widget>[
                    Column(children: [
                      SizedBox(height: 10,),
                    
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
                          SizedBox(width: 30,),
                          Expanded(
                            child:Text(hardwareVersion1 ?? '',style: TextStyle(color: Colors.white,fontSize: 15),overflow: TextOverflow.visible,maxLines: 2,),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 30,),
                          Expanded(
                            child:Text(hardwareVersion2 ?? '',style: TextStyle(color: Colors.white,fontSize: 15),overflow: TextOverflow.visible,maxLines: 2,),
                          ),
                        ],
                      ),
                    ],),
                    
                    SizedBox(height: 30,),
                    chooseFile(),
                    SizedBox(height: 10,),
                    isChoosedFile ? updateFileInfo(context) : Container(),
                    

                  ],
                ),
              ),
            )
          )
        ]
      )
    );
  }

  //选择文件按钮
  Widget chooseFile(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 260,
          child:  FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            splashColor: Colors.white,color: HexColor('6699ff'),
            child: Text(isChoosedFile ? '重新选择' : '选择文件',style: TextStyle(color: Colors.white,fontSize: 20),), 
            onPressed: () {  
              pushToPage(context, 
                UpdateChooseFilePage(
                  deviceTerminal : deviceTerminal,
                  onChoose: (UpdateFile updateFile){
                    setState(() {
                      this.updateFile = updateFile;
                      isChoosedFile = true;
                    });
                  },
                )
              );
            },
          )
        )
      ],
    );
  }

  //已选文件信息
  Widget updateFileInfo(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10,),
            Text('升级文件',style: TextStyle(color: Colors.white,fontSize: 20),), 
          ],
        ),
        divLine(0),
        SizedBox(height: 10,),
        Row(
          children: [
            SizedBox(width: 25,),
            Text('文件名称: ',style: TextStyle(color: Colors.white,fontSize: 15),),
            Text(updateFile.upgradeFileName ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 25,),
            Text('文件类型: ',style: TextStyle(color: Colors.white,fontSize: 15),),
            Text(updateFile.upgradeFileType ?? '',style: TextStyle(color: Colors.white,fontSize: 15),),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 25,),
            Text('文件大小: ',style: TextStyle(color: Colors.white,fontSize: 15),),
            Text((updateFile.upgradeFileSize.toString() ?? '0') + 'KB',style: TextStyle(color: Colors.white,fontSize: 15),),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 25,),
            Text('创建时间: ',style: TextStyle(color: Colors.white,fontSize: 15),),
            Text(updateFile.uploadDateTime ?? '0',style: TextStyle(color: Colors.white,fontSize: 15),),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 25,),
            Text('备注信息: ',style: TextStyle(color: Colors.white,fontSize: 15),),
            Expanded(
              child:Text(updateFile.upgradeFileDescription ?? '',style: TextStyle(color: Colors.white,fontSize: 15),overflow: TextOverflow.visible,maxLines: 50),
            ),
            
          ],
        ),
        SizedBox(height: 30,),

        //确认升级
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 260,
              child:  FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                splashColor: Colors.white,color: HexColor('6699ff'),
                child: Text('确认升级',style: TextStyle(color: Colors.white,fontSize: 20),), 
                onPressed: () {  
                  showAlertViewDouble(
                    context,'确认升级','确认升级文件是否正确?',
                    () {
                      setState(() {
                        _pushUpgradeFile(updateFile.upgradeFileId,deviceTerminal.terminalAddress);
                      });
                    }
                  );
                },
              )
            )
          ],
        ),
      ],
    );
  }
}
