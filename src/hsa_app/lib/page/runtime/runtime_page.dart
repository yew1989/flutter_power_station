import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent.dart';
import 'package:hsa_app/api/agent/agent_fake.dart';
import 'package:hsa_app/api/agent/agent_task.dart';
import 'package:hsa_app/api/agent/agent_timer_tasker.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/components/dash_board_widget.dart';
import 'package:hsa_app/components/runtime_progress_bar.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:hsa_app/page/dialog/password_dialog.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/runtime/runtime_event_tile.dart';
import 'package:hsa_app/page/runtime/runtime_operation_board.dart';
import 'package:hsa_app/page/runtime/runtime_squre_master_widget.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:ovprogresshud/progresshud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RuntimePage extends StatefulWidget {

  final String title;
  final String address;
  final String alias;
  final bool isOnline;
  final bool isBase;      // 是否是Base版本

  RuntimePage({this.title, this.address, this.alias, this.isOnline, this.isBase});

  @override
  _RuntimePageState createState() => _RuntimePageState();
}

class _RuntimePageState extends State<RuntimePage> {
  RefreshController refreshController = RefreshController(initialRefresh: false);

  // 计算宽度
  double barMaxWidth = 0;

  static const double kHeaderHeight = 44;

  //告警事件
  List<TerminalAlarmEvent> showEvents = List<TerminalAlarmEvent>();

  //水轮机信息
  DeviceTerminal deviceTerminal = DeviceTerminal();

  // 弹出进度对话框
  ProgressDialog progressDialog;


  AgentRunTimeDataLoopTimerTasker runtimTasker = AgentRunTimeDataLoopTimerTasker();

  final pageIndexNotifier = ValueNotifier<int>(0);

  // 初始化弹出框
  void initProgressDialog() {

    progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    
    progressDialog.style(
        message: '正在操作中...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
        padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
        messageTextStyle: TextStyle(color: Colors.black,fontSize: 19.0,fontWeight: FontWeight.normal));
  }

  // 更新弹出框
  void updateProgressDialog(String message) {
    progressDialog.update(
        message: message,
        progress: 0.0,
        maxProgress: 100.0,
        progressWidget: Container(
            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
            fontWeight: FontWeight.normal));
  }

  // 关闭弹出框
  void finishProgressDialog(String message, bool isSuccess) {
    var progressWidget = isSuccess
        ? Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 46)
        : Icon(Icons.error_outline, color: Colors.redAccent, size: 46);

    progressDialog.update(
        message: message,
        progress: 0.0,
        maxProgress: 100.0,
        progressWidget: Container(child: progressWidget),
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
            fontWeight: FontWeight.normal));
    Future.delayed(Duration(seconds: 1), () {
      progressDialog.dismiss();
    });
  }

  // 操作密码输入错误弹窗
  void showOperationPasswordPopWindow() async {
    progressDialog.update(
        message: '操作密码输入不正确',
        progress: 0.0,
        maxProgress: 100.0,
        progressWidget: Container(
            child:
                Icon(Icons.error_outline, color: Colors.redAccent, size: 46)),
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
            fontWeight: FontWeight.normal));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    progressDialog.dismiss();
  }

  @override
  void initState() {
    initProgressDialog();
    requestRunTimeData();
    super.initState();
  }

  @override
  void dispose() {
    runtimTasker?.stop();
    Progresshud.dismiss();
    super.dispose();
  }

  // 请求实时数据
  void requestRunTimeData() {
    Progresshud.showWithStatus('读取数据中...');

    final addressId = widget.address ?? '';
    List<String> param ;
    if (addressId.length == 0) {
      Progresshud.showInfoWithStatus('获取实时机组数据失败');
      return;
    }
    APIStation.getDeviceTerminalInfo(terminalAddress: addressId,onSucc: (dt){
      //this.runtimeData = RuntimeDataAdapter.adapter(dt, widget.alias);
      this.deviceTerminal = dt;
      switch(deviceTerminal.deviceVersion){
        case 'S1-Base': 
          param =  ["AFN0C.F7.p0", "AFN0C.F9.p0", "AFN0C.F10.p0", "AFN0C.F11.p0", 
                    "AFN0C.F13.p0", "AFN0C.F24.p0", "AFN0C.F20.p0", "AFN0C.F21.p0", "AFN0C.F22.p0"] ;
        break;
        
        case 'S1-Pro':
          param = ["AFN0C.F28.p0", "AFN0C.F30.p0", "AFN0C.F10.p0", "AFN0C.F11.p0", 
                  "AFN0C.F13.p0", "AFN0C.F24.p0", "AFN0C.F20.p0", "AFN0C.F21.p0", "AFN0C.F22.p0"] ;
        break;
      }
      APIStation.getMultipleAFNFnpn(terminalAddress:addressId,paramList: param,onSucc: (nearestRunningData){
        
        this.deviceTerminal.nearestRunningData = nearestRunningData;
        //this.runtimeData = RuntimeDataAdapter.adapter(deviceTerminal, widget.alias);
        API.getTerminalAlertList(
          onSucc: (events){
            Progresshud.dismiss();
            refreshController.refreshCompleted();
            setState(() {
              this.showEvents = events;
            });
            getRealtimeData();
          },onFail: (msg){},
          searchDirection : 'Backward',
          terminalAddress : addressId,
          limitSize : 10,
        );

      },onFail: (msg){
        Progresshud.showInfoWithStatus('获取实时机组数据失败');
        refreshController.refreshFailed();
      });
    },onFail: (msg){
      
    },
    isIncludeWaterTurbine : true,
    isIncludeHydropowerStation:true,
    isIncludeCustomer:true
    );
  }

  //获取实时数据
  void getRealtimeData(){
    final addressId = widget.address ?? '';
    runtimTasker = AgentRunTimeDataLoopTimerTasker(
      isBase: widget?.isBase == true ?  true: false,
      terminalAddress: addressId,
      timerInterval: 5,
    );
    runtimTasker.start((data){
      setState(() {
        // 若开启此处,进入假数据模式,用于动画调试
        // this.deviceTerminal?.nearestRunningData = AgentFake.fakeNearestRunningData(data);
        this.deviceTerminal?.nearestRunningData = data;
      });
    });
  }
  


  //  设备概要头
  Widget terminalBriefHeader() {
    var deviceWidth = MediaQuery.of(context).size.width;
    var denominator = 3.1;
    if (deviceWidth == 320.0) {
      denominator = 3.3;
    }

    // 条状宽度
    barMaxWidth = deviceWidth / denominator;

    // 电压
    var voltage = deviceTerminal?.nearestRunningData?.voltage ?? 0.0;
    var voltageStr = voltage.toString() + 'V';
    var voltageMax     = deviceTerminal?.waterTurbine?.ratedVoltageV?.toDouble() ?? 0.0;
    var voltagePecent = RuntimeDataAdapter.caclulatePencent(voltage , voltageMax);

    // 电流
    var current = deviceTerminal?.nearestRunningData?.current ?? 0.0;
    var currentStr = current.toString() + 'A';
    var currentMax     = deviceTerminal?.waterTurbine?.ratedCurrentA?.toDouble() ?? 0.0;
    var currentPecent = RuntimeDataAdapter.caclulatePencent(current , currentMax);

    // 励磁电流
    var excitation = deviceTerminal?.nearestRunningData?.fieldCurrent ?? 0.0;
    var excitationStr = excitation.toString() + 'A';
    var excitationMax  = deviceTerminal?.waterTurbine?.ratedExcitationCurrentA?.toDouble() ?? 0.0;
    var excitationPecent = RuntimeDataAdapter.caclulatePencent(excitation , excitationMax);

    // 功率因数
    var powfactor = deviceTerminal?.nearestRunningData?.powerFactor ?? 0.0;
    var powfactorStr = powfactor.toStringAsFixed(2);
    var powerFactorMax = 1.0;
    var powfactorPencent = RuntimeDataAdapter.caclulatePencent(powfactor , powerFactorMax);

    return Container(
      color: Colors.transparent,
      height: kHeaderHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '电压',
                  valueText: voltageStr,
                  pencent: voltagePecent),
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '励磁电流',
                  valueText: excitationStr,
                  pencent: excitationPecent),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '电流',
                  valueText: currentStr,
                  pencent: currentPecent),
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '功率因数',
                  valueText: powfactorStr,
                  pencent: powfactorPencent),
            ],
          ),
        ],
      ),
    );
  }

  void onTapPushToHistoryPage(String navTitle, String address, StationInfo stationInfo) async {
    pushToPage(context, HistoryPage(address:address,stationInfo: stationInfo));
  }

  // 仪表盘
  Widget dashBoardWidget() {
    // 频率
    var freqNow = deviceTerminal?.nearestRunningData?.frequency ?? 0.0;
    var freqNowStr = freqNow.toStringAsFixed(2);

    // 开度
    var openNow = deviceTerminal?.nearestRunningData?.openAngle ?? 0.0;
    //openNow *= 100;
    var openNowStr = openNow.toStringAsFixed(0);

    return Container(
      height: 202,
      child: Stack(
        children: [
          // 分成左右两个大区
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 左侧大区
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      // 左侧文字
                      Positioned(
                        right: 126,
                        top: 10,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(freqNowStr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppTheme().numberFontName,
                                      fontSize: 24)),
                              SizedBox(
                                  height: 2,
                                  width: 52,
                                  child: Image.asset(
                                      'images/runtime/Time_line1.png')),
                              Text('频率:Hz',
                                  style: TextStyle(
                                      color: Colors.white30, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      // 左侧一根引出线
                      Positioned(
                        right: 62,
                        top: 37,
                        child: Container(
                          height: 24,
                          width: 66,
                          child: Image.asset(
                              'images/runtime/Time_light_line1.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 右侧大区
              Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        // 左侧文字
                        Positioned(
                          left: 113,
                          top: 10,
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(openNowStr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: AppTheme().numberFontName,
                                        fontSize: 24)),
                                SizedBox(
                                    height: 2,
                                    width: 52,
                                    child: Image.asset(
                                        'images/runtime/Time_line1.png')),
                                Text('开度:%',
                                    style: TextStyle(
                                        color: Colors.white30, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),

                        // 右侧一根引出线
                        Positioned(
                          left: 84,
                          top: 37,
                          child: Container(
                            height: 20,
                            width: 35,
                            child: Image.asset(
                                'images/runtime/Time_light_line2.png'),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          // 中央仪表盘
          DashBoardWidget(deviceTerminal: deviceTerminal),
        ],
      ),
    );
  }

  //  设备概要尾
  Widget terminalBriefFooter() {
    // 温度
    var temperature  =  deviceTerminal?.nearestRunningData?.temperature ?? 0.0 ;
    // 转速
    var speed = deviceTerminal?.nearestRunningData?.speed ?? 0.0;
    // 水位
    var waterStage = deviceTerminal?.nearestRunningData?.waterStage ?? 0.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    height: 50,
                    color: Colors.transparent,
                    child:
                        terminalBriefFooterItem(temperature.toString(),'温度'))),
            Expanded(
                flex: 1,
                child: Container(
                    height: 50,
                    color: Colors.transparent,
                    child:
                        terminalBriefFooterItem(speed.toString(),'转速'))),
            Expanded(
                flex: 1,
                child: Container(
                    height: 50,
                    color: Colors.transparent,
                    child:
                        terminalBriefFooterItem(waterStage.toString(),'水位'))),
          ],
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget terminalBriefFooterItem(String title , String subTitle) {
    return title != null 
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: AppTheme().numberFontName)),
                ),
                Center(
                  child: Text(subTitle ?? '',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: AppTheme().numberFontName)),
                ),
              ],
            ),
          )
        : Container();
  }

  // 事件列表
  Widget eventList() {
    return Container(
      child: ListView.builder(
        itemCount: showEvents?.length ?? 0,
        itemBuilder: (_, index) {
          final event = showEvents[index];
          final left = 'ERC${event.eventFlag}--${event.eventTitle}';
          var right = event.eventTime;
          return RuntimeEventTile(event:  EventTileData(left, right));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final isIphone5S = deviceWidth == 320.0 ? true : false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
          Container(
            height: isIphone5S ? 350 : 400,
            child: SmartRefresher(
              header: appRefreshHeader(),
              enablePullDown: true,
              onRefresh: requestRunTimeData,
              controller: refreshController,
              child: ListView(
              children: <Widget>[
                SizedBox(height: 12),
                terminalBriefHeader(),
                RuntimeSqureMasterWidget(
                  isMaster: deviceTerminal?.isMaster ?? false,
                  aliasName: widget.alias ?? '',
                ),
                dashBoardWidget(),
                terminalBriefFooter(),
                SizedBox(height: 8),
                ],
              ),
            ),
          ),
          isIphone5S ? Container() :Expanded(child: eventList()),
          RunTimeLightDarkShawdow(),
          RunTimeOperationBoard(deviceTerminal,widget.address,(taskName,param) => requestRemoteControlCommand(context, taskName, param)),

        ]),
      ),
    );
  }

  // 远程控制
  void requestRemoteControlCommand(
      BuildContext context, TaskName taskName, String param) async {
    progressDialog.dismiss();
    // 终端在线状态检测
    final isOnline = widget.isOnline ?? false;
    if (isOnline == false) {
      Progresshud.showInfoWithStatus('终端不在线,远程操作被取消');
      return;
    }
    // 远程控制检测
    var isRemoteControl = false;
    // 如果是远程控制模式开关
    if (taskName == TaskName.remoteSwitchRemoteModeOn ||
        taskName == TaskName.remoteSwitchRemoteModeOff) {
      isRemoteControl =
          deviceTerminal.isOnLine == true &&
              deviceTerminal.controlType == '智能';
    }
    // 其他指令 必须在远程控制模式打开情况下 有效
    else {
      isRemoteControl =
          deviceTerminal.isOnLine == true &&
              deviceTerminal.controlType == '智能' &&
                  deviceTerminal.isAllowRemoteControl == true;
    }

    if (isRemoteControl == false) {
      Progresshud.showInfoWithStatus('请先切换到远程控制模式');
      return;
    }

    updateProgressDialog('正在操作中');
    await Future.delayed(Duration(milliseconds: 600));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PasswordDialog((String pswd) {
          //检查操作密码
          AgentControlAPI.startTask(context,param,taskName,widget.address,pswd,
            (String succString) {
              finishProgressDialog(succString, true);
            }, (String failString) {
              finishProgressDialog(failString, false);
            }, (String loadingString) {
              updateProgressDialog(loadingString);
            }
          );
        });
      }
    );
  }
}
