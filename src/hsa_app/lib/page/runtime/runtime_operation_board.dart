import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent_task.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/page/dialog/control_model_dialog.dart';
import 'package:hsa_app/page/dialog/device_control_dialog.dart';
import 'package:hsa_app/page/dialog/power_control_dialog.dart';
import 'package:hsa_app/page/more/more_page.dart';

class RunTimeOperationBoard extends StatefulWidget {
  
  final String addressId;
  final DeviceTerminal deviceTerminal;
  final void Function(TaskName taskName,String param) onSholdRequestRemoteCommand;
  const RunTimeOperationBoard(this.deviceTerminal, this.addressId, this.onSholdRequestRemoteCommand,{Key key}) : super(key: key);

  @override
  _RunTimeOperationBoardState createState() => _RunTimeOperationBoardState();
}

class _RunTimeOperationBoardState extends State<RunTimeOperationBoard> {

  //机组开关机状态
  static bool motorPowerBool(DeviceTerminal data) {
    var statusString = data?.nearestRunningData?.powerStatus ?? '未定义';
    
    if(statusString.compareTo('正在开机') == 0 || statusString.compareTo('并网运行') == 0) {
        
        return true;
    }
    else if(statusString.compareTo('正在关机') == 0 || statusString.compareTo('机组关机') == 0) {
      return false;
    }
    else if(statusString.compareTo('未定义') == 0) {
        var volt = data?.nearestRunningData?.voltage?.toDouble() ?? 0.0;
        if(volt <= 50) {
          return false;
        }
        else if (volt > 50){
          
          return true;
        }
        return false;
    }
    return false;
  }

  //当前模式
  static String getCurrentStatus(DeviceTerminal data){
    if(data.controlType != null){
      if(data.controlType.compareTo('智能') == 0){
        return '智        能';
      }else if(data.controlType.compareTo('手动') == 0){
        return '手        动';
      }else if(data.controlType.compareTo('自动') == 0){
        return '自        动';
      }else{
        return '未        知';
      }
    }else{
      return '未        知';
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final deviceTerminal = widget.deviceTerminal;
    
    var isMotorPowerOn = motorPowerBool(deviceTerminal);

    String currentStatusStr = getCurrentStatus(deviceTerminal);

    var deviceWidth = MediaQuery.of(context).size.width;
    final right = deviceWidth % 2 == 0 ? 4.0 : 5.0 ;
    final isIphone5S = MediaQuery.of(context).size.width == 320.0 ? true : false;

    return SafeArea(
      
      child: Container(
        height: 129,
        width: double.infinity,
        margin: EdgeInsets.only(left: 4, right: right, bottom: isIphone5S ? 3 : 4),
        child: Center(
          child: Stack(
            children: <Widget>[
              // 背景 分成上下两个区
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 上方大区
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            // 左上角
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                    child: Image.asset(
                                        'images/board/board_top_left1.png'),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'images/board/board_center.png',
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 27,
                                    child: Image.asset(
                                        'images/board/board_top_left2.png'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 80),

                            // 右上角
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 27,
                                    child: Image.asset(
                                        'images/board/board_top_right2.png'),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'images/board/board_center.png',
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    child: Image.asset(
                                        'images/board/board_top_right1.png'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 3),
                  // 下方大区
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            // 左上角
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                    child: Image.asset(
                                        'images/board/board_bottom_left1.png'),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'images/board/board_center.png',
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 27,
                                    child: Image.asset(
                                        'images/board/board_bottom_left2.png'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width:80),

                            // 右上角
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 27,
                                    child: Image.asset(
                                        'images/board/board_bottom_right2.png'),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'images/board/board_center.png',
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    child: Image.asset(
                                        'images/board/board_bottom_right1.png'),
                                  ),
                                ],
                             ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 中央按钮
              Center(
                child: Container(
                  height: 127,
                  width: 127,
                  child: Stack(
                    children: <Widget>[
                      // 中央按钮
                      Center(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'images/runtime/Time_power_btn.png')),
                          ),
                          child: Center(
                              child: SizedBox(
                                  height: 68,
                                  width: 68,
                                  child: isMotorPowerOn ? Image.asset('images/runtime/Time_power_icon_on.png') 
                                      : Image.asset('images/runtime/Time_power_icon_off.png')
                                  )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(widget.onSholdRequestRemoteCommand != null) {
                             widget.onSholdRequestRemoteCommand(isMotorPowerOn ? TaskName.remotePowerOff : TaskName.remotePowerOn,null);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 操作按钮
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 上半区
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // 自动/智能/
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('$currentStatusStr',style: TextStyle(color: Colors.white, fontSize: 15)),
                                      SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: Image.asset('images/runtime/Time_list_icon.png'),
                                      )
                                    ],
                                  ),
                                ),
                                
                                GestureDetector(onTap: () {
                                    showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => ControlModelDialogWidget(
                                      deviceTerminal: deviceTerminal,
                                      onChoose: (ControlModelCurrentStatus status ,String currentStatusStr) {
                                        debugPrint(status.toString());
                                        if(status == ControlModelCurrentStatus.remoteOn) {
                                          if(widget.onSholdRequestRemoteCommand != null) {
                                          widget.onSholdRequestRemoteCommand(TaskName.remoteSwitchRemoteModeOn,null);
                                          }
                                        }
                                        else if(status == ControlModelCurrentStatus.remoteOff) {
                                          if(widget.onSholdRequestRemoteCommand != null) {
                                          widget.onSholdRequestRemoteCommand(TaskName.remoteSwitchRemoteModeOff,null);
                                          }
                                        }
                                      },
                                    )
                                  );
                                }),
                                ],
                              ),
                            ),
                            SizedBox(width: 127),
                            // 调功率
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: <Widget>[
                                  // 功率调整
                                  Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Image.asset('images/runtime/Time_Apower_icon.png')),
                                          SizedBox(width: 4),
                                          Text('调功',
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 15)),
                                        ],
                                    ),
                                  ),
                                  // 调功
                                  GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,barrierDismissible: false,
                                      builder: (_) => PowerControlDialogWidget(
                                        powerMax: deviceTerminal?.waterTurbine?.ratedPowerKW?.toInt() ?? 0,
                                        onConfirmActivePower:(String activePower) {
                                            if(widget.onSholdRequestRemoteCommand != null) {
                                            widget.onSholdRequestRemoteCommand(TaskName.remoteSettingActivePower,activePower);
                                            }
                                        },
                                        onConfirmPowerFactor:(String powerFactor) {
                                          debugPrint('功率因数:' + powerFactor);
                                          var hundred = double.parse(powerFactor) * 100;
                                          var hundredStr = hundred.toStringAsFixed(0);
                                          if(widget.onSholdRequestRemoteCommand != null) {
                                            widget.onSholdRequestRemoteCommand(TaskName.remoteSettingPowerFactor,hundredStr);
                                          }
                                        }
                                      )
                                    );
                                  },
                                ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  // 分割线
                  SizedBox(height: 3),
                  // 下半区
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // 设备控制
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: <Widget>[
                                  // 设备控制
                                  Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('设备控制',style: TextStyle(color: Colors.white, fontSize: 15)),
                                      SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: Image.asset('images/runtime/Time_list_icon.png'),
                                      )
                                    ],
                                  ),
                                ),
                                
                                GestureDetector(
                                onTap: () {
                                  // Progresshud.showInfoWithStatus('功能未开放,尽请期待');
                                  // return;
                                  // 暂时屏蔽该项功能
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => DeviceControlDialog((taskName){
                                        if(widget.onSholdRequestRemoteCommand != null) {
                                          widget.onSholdRequestRemoteCommand(taskName,null);
                                        }
                                  }));
                                },
                              ),
                                ],
                              ),
                            ),
                            SizedBox(width: 127),
                            // 更多
                            Expanded(
                              flex: 1,
                              child:Stack(
                                children: <Widget>[
                                  Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: Image.asset(
                                            'images/runtime/Time_set_icon.png'),
                                      ),
                                      SizedBox(width: 4),
                                      Text('更多',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15)),
                                    ],
                                  ),
                                ),

                                GestureDetector(
                                onTap: () {
                                  pushToPage(context,MorePage(addressId: widget?.addressId ??''));
                                },
                              ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}