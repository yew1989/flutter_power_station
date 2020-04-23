import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/all_model.dart';

class ControlModelDialogWidget extends StatefulWidget {

  final DeviceTerminal deviceTerminal;

  final void Function(ControlModelCurrentStatus status,String currentStatusStr) onChoose;

  const ControlModelDialogWidget({Key key, this.deviceTerminal, this.onChoose}) : super(key: key);

  @override
  _ControlModelDialogWidgetState createState() => _ControlModelDialogWidgetState();

}

class _ControlModelDialogWidgetState extends State<ControlModelDialogWidget> {
  
  DeviceTerminal deviceTerminal = DeviceTerminal();
  String currentStatusStr = '';
  ControlModelCurrentStatus currentStatus;

  @override
  void initState() {
    deviceTerminal = widget?.deviceTerminal;
    getCurrentStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ControlModelDialog(widget.deviceTerminal, widget.onChoose,currentStatus,currentStatusStr);
  }

  

  //当前模式
  void getCurrentStatus(){

    // 默认从基础数据里面拿
    if(deviceTerminal.controlType != null) {
      if(deviceTerminal.controlType.compareTo('智能') == 0){
        this.currentStatusStr = '智        能';
        this.currentStatus =  deviceTerminal.isAllowRemoteControl ? ControlModelCurrentStatus.remoteOn : ControlModelCurrentStatus.remoteOff;
      }else if(deviceTerminal.controlType.compareTo('手动') == 0){
        this.currentStatusStr = '手        动';
        this.currentStatus = ControlModelCurrentStatus.manual;
      }else if(deviceTerminal.controlType.compareTo('自动') == 0){
        this.currentStatusStr = '自        动';
        this.currentStatus = ControlModelCurrentStatus.auto;
      }else{
        this.currentStatusStr = '未        知';
        this.currentStatus = ControlModelCurrentStatus.unknow;
      }
    }
    else {
      this.currentStatusStr = '未        知';
      this.currentStatus = ControlModelCurrentStatus.unknow;
    }
    
    // 如果运行缓存有数据 从运行时参数里面取
    if(deviceTerminal.nearestRunningData != null) {
      if(deviceTerminal.nearestRunningData.controlType.compareTo('智能') == 0){
        this.currentStatusStr = '智        能';
        this.currentStatus =  deviceTerminal.nearestRunningData.isAllowRemoteControl ? ControlModelCurrentStatus.remoteOn : ControlModelCurrentStatus.remoteOff;
      }else if(deviceTerminal.nearestRunningData.controlType.compareTo('手动') == 0){
        this.currentStatusStr = '手        动';
        this.currentStatus = ControlModelCurrentStatus.manual;
      }else if(deviceTerminal.nearestRunningData.controlType.compareTo('自动') == 0){
        this.currentStatusStr = '自        动';
        this.currentStatus = ControlModelCurrentStatus.auto;
      }else{
        this.currentStatusStr = '未        知';
        this.currentStatus = ControlModelCurrentStatus.unknow;
      }
    }
  }
}

enum ControlModelCurrentStatus { unknow ,manual, auto, remoteOn, remoteOff }

class ControlModelDialog extends Dialog {
  final ControlModelCurrentStatus currentStatus;
  final DeviceTerminal deviceTerminal;
  final String currentStatusStr;
  final void Function(ControlModelCurrentStatus status,String currentStatusStr) onChoose;

  ControlModelDialog(this.deviceTerminal, this.onChoose , this.currentStatus,this.currentStatusStr);
  
  
  
  // 自动
  Widget bottomTile(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // 自动
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('$currentStatusStr',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                'images/runtime/Time_list_icon_down.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 127),
                // 调功率
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 22, width: 22),
                        SizedBox(width: 4),
                        Text('调功',
                            style: TextStyle(
                                color: Colors.transparent, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(onTap: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget modelTile(BuildContext context, String string, bool enable,
      ControlModelCurrentStatus status , String currentStatusStr) {
    var isRemoteMode = (status == ControlModelCurrentStatus.remoteOff) || (status == ControlModelCurrentStatus.remoteOn);
   
    return Container(
      margin: EdgeInsets.only(right: 12, left: isRemoteMode ? 40 : 12),
      child: SizedBox(
        height: 43,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(string,
                      style: TextStyle(
                          color: enable ? Colors.white : Colors.white60,
                          fontSize: 16)),
                  SizedBox(
                      height: 22,
                      width: 22,
                      child: status == currentStatus ? Image.asset('images/runtime/Time_selected_icon.png') : null),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isRemoteMode) {
                  Navigator.of(context).pop();
                  if (onChoose != null) onChoose(status,currentStatusStr);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget divider(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIphone5s =
        MediaQuery.of(context).size.width == 320.0 ? true : false;
    
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            GestureDetector(onTap: () => Navigator.of(context).pop()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 70,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5s ? 5 : 5),
                child: SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color.fromRGBO(53, 117, 191, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          modelTile(context, '手动', false, 
                              ControlModelCurrentStatus.manual,this.currentStatusStr),
                          divider(12),
                          modelTile(context, '自动', false,
                              ControlModelCurrentStatus.auto,this.currentStatusStr),
                          divider(12),

                          // 智能
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: '智能',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      TextSpan(
                                          text: ' (下位机智能控制屏旋钮处于智能模式时,方可开启)',
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: isIphone5s ? 10 : 12)),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          divider(12),
                          modelTile(context, '远程控制', true,ControlModelCurrentStatus.remoteOn,this.currentStatusStr),
                          divider(40),
                          modelTile(context, '${deviceTerminal?.intelligentControlScheme ?? '默认调节方案'}', true,ControlModelCurrentStatus.remoteOff,this.currentStatusStr),

                          // 分割线顶格
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.white12,
                          ),
                          // 自动
                          bottomTile(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
