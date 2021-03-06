import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent.dart';
import 'package:hsa_app/api/agent/agent_task.dart';
import 'package:hsa_app/api/agent/agent_timer_tasker.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/apis/api_station.dart';
import 'package:hsa_app/components/dash_board/dash_board_freq.dart';
import 'package:hsa_app/components/dash_board/dash_board_open.dart';
import 'package:hsa_app/components/dash_board_widget.dart';
import 'package:hsa_app/components/runtime_progress_bar/runtime_progress_current.dart';
import 'package:hsa_app/components/runtime_progress_bar/runtime_progress_excitation.dart';
import 'package:hsa_app/components/runtime_progress_bar/runtime_progress_factory.dart';
import 'package:hsa_app/components/runtime_progress_bar/runtime_progress_voltage.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:hsa_app/page/dialog/password_dialog.dart';
import 'package:hsa_app/page/runtime/runtime_event_tile.dart';
import 'package:hsa_app/page/runtime/runtime_operation_board.dart';
import 'package:hsa_app/page/runtime/runtime_squre_master_widget.dart';
import 'package:hsa_app/service/life_cycle/lifecycle_state.dart';
import 'package:hsa_app/util/date_tool.dart';
import 'package:ovprogresshud/progresshud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RuntimePage extends StatefulWidget {

  final bool isAllowHighSpeedNetworkSwitching;
  final String alias;
  final WaterTurbine waterTurbine;

  RuntimePage({this.waterTurbine,this.alias,this.isAllowHighSpeedNetworkSwitching});

  @override
  _RuntimePageState createState() => _RuntimePageState();
}

class _RuntimePageState extends LifecycleState<RuntimePage> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

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

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 1;

  //0旧数据临时储存 1新入数据
  List<double> powerNowList = [0.0,0.0];
  List<double> freqList = [0.0,0.0];
  List<double> openList = [0.0,0.0];
  List<double> temperatureList = [0.0,0.0];
  List<double> speedList = [0.0,0.0];
  List<double> waterStageList = [0.0,0.0];
  List<double> voltageList = [0.0,0.0];
  List<double> excitationList = [0.0,0.0];
  List<double> currentList = [0.0,0.0];
  List<double> factorList = [0.0,0.0];

  AnimationController controller;
  Animation<double> animationTemp;
  Animation<double> animationSpeed;
  Animation<double> animationWaterStage;

  // 初始化弹出框
  void initProgressDialog() async {

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
  void updateProgressDialog(String message) async {
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
     progressDialog.show();
  }

  // 关闭弹出框
  void finishProgressDialog(String message, bool isSuccess) async {

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
    progressDialog.show();
    await Future.delayed(Duration(milliseconds: 1000));
    progressDialog.hide();
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
    await Future.delayed(Duration(milliseconds: 1000));
    progressDialog.hide();
  }

  @override
  void initState() {
    super.initState();
    initProgressDialog();
    requestRunTimeData();
  }

  @override
  void dispose() {
    controller?.dispose();
    runtimTasker?.dispose();
    Progresshud.dismiss();
    super.dispose();
  }

   @override
  void onResume() {
    super.onResume();
    requestRunTimeData();
    debugPrint('onResume');
  }

  @override
  void onPause() {
    runtimTasker?.dispose();
    Progresshud.dismiss();
    super.onPause();
  }

  // 请求实时数据
  void requestRunTimeData() async {

    runtimTasker?.dispose();
    
    await Future.delayed(Duration(milliseconds: 500));

    Progresshud.showWithStatus('读取数据中...');

    final terminalAddress = widget?.waterTurbine?.deviceTerminal?.terminalAddress ?? '';

    List<String> param ;
    if (terminalAddress.length == 0) {
      Progresshud.showInfoWithStatus('获取实时机组数据失败');
      return;
    }
    APIStation.getDeviceTerminalInfo(
    terminalAddress: terminalAddress,
    isIncludeWaterTurbine : true,
    isIncludeHydropowerStation:true,
    isIncludeCustomer:true,
    onSucc: (dt){
      if(mounted) {
        setState(() {
           this.deviceTerminal = dt;
        });
      }
      Progresshud.dismiss();
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
      APIStation.getMultipleAFNFnpn(terminalAddress:terminalAddress,paramList: param,onSucc: (nearestRunningData){

        this.deviceTerminal.nearestRunningData = nearestRunningData;
        getRealtimeData();
        getTerminalAlertList(terminalAddress);

      },onFail: (msg){
        refreshController.refreshFailed();
      });
    },
    onFail: (msg) {
      Progresshud.showInfoWithStatus('数据获取失败');
      }
    );
  }  

      // 查出一周内的最后10条告警信息
  void getTerminalAlertList(String addressId) async {
        API.getTerminalAlertList(
          terminalAddress : addressId,
          ercVersions: '0',
          limitSize : 10,
          startDateTime: DateTool.getLastWeekTimeStamp(),
          endDateTime: DateTool.getTodayTimeStamp(),

          onSucc: (events){
            refreshController.refreshCompleted();
            if(mounted) {
              setState(() {
              this.showEvents = events;
              });
            }
          },onFail: (msg){},
        );
  }

  //获取实时数据
  void getRealtimeData() async{
    runtimTasker?.dispose();
    await Future.delayed(Duration(milliseconds: 500)); 
    final terminalAddress = widget?.waterTurbine?.deviceTerminal?.terminalAddress ?? '';
    final isBase = widget?.waterTurbine?.deviceTerminal?.deviceVersion?.compareTo('S1-Pro') == 0  ? false : true;

    if(terminalAddress == '') return;
    runtimTasker = AgentRunTimeDataLoopTimerTasker();
    runtimTasker.listen(terminalAddress,
      isBase,
      widget?.isAllowHighSpeedNetworkSwitching ?? false,
      AppConfig.getInstance().deviceQureyTimeInterval,
      (data){
        if(mounted) {
          setState(() {
          // this.deviceTerminal?.nearestRunningData = AgentFake.fakeNearestRunningData(data);
          this.deviceTerminal?.nearestRunningData =  data;
          addToList(powerNowList,this.deviceTerminal?.nearestRunningData?.power ?? 0.0);
          addToList(freqList,this.deviceTerminal?.nearestRunningData?.frequency ?? 0.0);
          addToList(openList,this.deviceTerminal?.nearestRunningData?.openAngle ?? 0.0);
          addToList(temperatureList,this.deviceTerminal?.nearestRunningData?.temperature ?? 0.0);
          addToList(speedList,this.deviceTerminal?.nearestRunningData?.speed ?? 0.0);
          addToList(waterStageList,this.deviceTerminal?.nearestRunningData?.waterStage ?? 0.0);
          addToList(voltageList,this.deviceTerminal?.nearestRunningData?.voltage ?? 0.0);
          addToList(excitationList,this.deviceTerminal?.nearestRunningData?.fieldCurrent ?? 0.0);
          addToList(currentList,this.deviceTerminal?.nearestRunningData?.current ?? 0.0);
          addToList(factorList,this.deviceTerminal?.nearestRunningData?.powerFactor ?? 0.0);
          eventBird?.emit('NEAREST_DATA',this.deviceTerminal);
          // debugPrint('NEAREST_DATA POST');
          initController();
          });
        }
      }
    );
  }

  //list处理
  List<double> addToList(List<double> list, double d){
    list.add(d ?? 0.0);
    if(list.length > 2){
      list.removeAt(0);
    }
    return list;
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
    var voltageMax     = this.deviceTerminal?.waterTurbine?.ratedVoltageV?.toDouble() ?? 0.0;
    // 电流
    var currentMax     = this.deviceTerminal?.waterTurbine?.ratedCurrentA?.toDouble() ?? 0.0;
    // 励磁电流
    var excitationMax  = this.deviceTerminal?.waterTurbine?.ratedExcitationCurrentA?.toDouble() ?? 0.0;
    // 功率因数
    var powerFactorMax = 1.0;

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
              RuntimeProgressVoltage(
                barMaxWidth: barMaxWidth,
                leftText: '电压',
                maxData: voltageMax,
                doubleList: voltageList,
                seconds: AppConfig.getInstance().runtimePageAnimationDuration),
              RuntimeProgressExcitation(
                barMaxWidth: barMaxWidth,
                leftText: '励磁电流',
                maxData: excitationMax,
                doubleList: excitationList,
                seconds: AppConfig.getInstance().runtimePageAnimationDuration),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RuntimeProgressCurrent(
                barMaxWidth: barMaxWidth,
                leftText: '电流',
                maxData: currentMax,
                doubleList: currentList,
                seconds: AppConfig.getInstance().runtimePageAnimationDuration),
              RuntimeProgressFactory(
                barMaxWidth: barMaxWidth,
                leftText: '功率因数',
                maxData: powerFactorMax,
                doubleList: factorList,
                seconds: AppConfig.getInstance().runtimePageAnimationDuration),
            ],
          ),
        ],
      ),
    );
  }

  // 仪表盘
  Widget dashBoardWidget() {

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
                          child: DashBoardFreq(freqList),
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
                          child: DashBoardOpen(openList),
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
          DashBoardWidget(deviceTerminal: deviceTerminal,
                          powerNowList: powerNowList,
                          freqList:freqList,
                          openList:openList),
        ],
      ),
    );
  }

  //温度 转速 水位数据处理
  void initController(){
    if(canPlayAnimationOnZero <= 0  && mounted ) {
      controller?.dispose();
      controller = AnimationController(duration: Duration(seconds:AppConfig.getInstance().runtimePageAnimationDuration), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animationTemp = Tween<double>(begin: temperatureList[0], end: temperatureList[1]).animate(curvedAnimation);
      animationSpeed = Tween<double>(begin: speedList[0], end: speedList[1]).animate(curvedAnimation);
      animationWaterStage = Tween<double>(begin: waterStageList[0], end: waterStageList[1]).animate(curvedAnimation);
      controller.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero --;
  }

  //  设备概要尾
  Widget terminalBriefFooter() {
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
                child:terminalBriefFooterItem(animationTemp,'温度'))),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: Colors.transparent,
                child:terminalBriefFooterItem(animationSpeed,'转速'))),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: Colors.transparent,
                child:terminalBriefFooterItem(animationWaterStage,'水位'))),
          ],
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget terminalBriefFooterItem(Animation<double> animationDouble , String subTitle) {
    return animationDouble != null 
        ? Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) => RichText(
                text: TextSpan(
                  children: 
                  [
                    TextSpan(text:animationDouble.value.toStringAsFixed(1),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
                  ]
                ),
              ),
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

    super.build(context);
    
    MediaQueryData mq = MediaQuery.of(context);
    final deviceWidth = mq.size.width;
    final deviceHeight = mq.size.height;
    final statusBarHeight = mq.padding.top;
    final bottomBarHeight = mq.padding.bottom;
    final safeContentHeight =  deviceHeight - statusBarHeight - bottomBarHeight;
    final safeHeight = safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;
    final isIphone5S = deviceWidth == 320.0 ? true : false;
    final eventListHeight = safeHeight - (isIphone5S ? 350 : 400) - 140;
    
    final terminalAddress = widget?.waterTurbine?.deviceTerminal?.terminalAddress ?? ''; 
    final isMaster = widget?.waterTurbine?.deviceTerminal?.isMaster ?? ''; 

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
          children: [
              Positioned(left: 0,right: 0,top: 0,child: Container(height: isIphone5S ? 350 : 400,
                  child: SmartRefresher(
                    header: appRefreshHeader(),
                    enablePullDown: true,
                    onRefresh: requestRunTimeData,
                    controller: refreshController,
                    child: ListView(
                    children: <Widget>[
                      SizedBox(height: 12),
                      terminalBriefHeader(),
                      RuntimeSqureMasterWidget(isMaster: isMaster ?? false,aliasName: widget?.alias ?? ''),
                      dashBoardWidget(),
                      terminalBriefFooter(),
                      SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(left: 0,right: 0,top: isIphone5S ? 350 : 400,child:isIphone5S ? Container() :Container(height:eventListHeight,child: Container(child: eventList()))),
            Positioned(left: 0,right: 0,bottom: 139,child: RunTimeLightDarkShawdow()),
            Positioned(left: 0,right: 0,bottom: 0,child: RunTimeOperationBoard(deviceTerminal,terminalAddress,(taskName,param) => requestRemoteControlCommand(context, taskName, param))),
          ],
      ),
    );
  }

  // 远程控制
  void requestRemoteControlCommand(BuildContext context, TaskName taskName, String param) async {

    final terminalAddress = widget?.waterTurbine?.deviceTerminal?.terminalAddress ?? ''; 
    final isOnline = widget?.waterTurbine?.deviceTerminal?.isOnLine ?? false; 

    progressDialog.hide();
    if (isOnline == false) {
      Progresshud.showInfoWithStatus('终端不在线,远程操作被取消');
      return;
    }
    // 远程控制检测
    var isAllowControl = false;
    // 如果是远程控制模式开关
    if (taskName == TaskName.remoteSwitchRemoteModeOn || taskName == TaskName.remoteSwitchRemoteModeOff) {
      isAllowControl =  deviceTerminal.nearestRunningData.controlType == '智能';
    }
    // 其他指令 必须在远程控制模式打开情况下 有效
    else {
      isAllowControl =  deviceTerminal.nearestRunningData.controlType == '智能' && deviceTerminal.nearestRunningData.isAllowRemoteControl == true;
    }

    if (isAllowControl == false) {
      Progresshud.showInfoWithStatus('请先切换到远程控制模式');
      return;
    }

    await Future.delayed(Duration(milliseconds: 300));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PasswordDialog((String pswd) {

          updateProgressDialog('正在验证操作密码');

          AgentControlAPI.startTask(context,param,taskName,terminalAddress,pswd,
            (String succString) async {
              await Future.delayed(Duration(milliseconds: 3000));
              finishProgressDialog(succString, true);
            }, (String failString) async {
              await Future.delayed(Duration(milliseconds: 3000));
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
