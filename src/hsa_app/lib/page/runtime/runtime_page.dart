import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent.dart';
import 'package:hsa_app/api/agent/agent_fake.dart';
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
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:hsa_app/page/dialog/password_dialog.dart';
import 'package:hsa_app/page/runtime/runtime_event_tile.dart';
import 'package:hsa_app/page/runtime/runtime_operation_board.dart';
import 'package:hsa_app/page/runtime/runtime_squre_master_widget.dart';
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

class _RuntimePageState extends State<RuntimePage> with TickerProviderStateMixin{

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

  AnimationController footerDataController;
  Animation<double> animationTemp;
  Animation<double> animationSpeed;
  Animation<double> animationWaterStage;
  Animation<double> animationVoltage;

  //动画过程时间
  int seconds = 5;


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
  void updateProgressDialog(String message) async{
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
  void finishProgressDialog(String message, bool isSuccess) async{

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
    initProgressDialog();
    requestRunTimeData();
    super.initState();
  }

  @override
  void dispose() {
    runtimTasker?.stop();
    footerDataController?.dispose();
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
          ercVersions: '0',
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
      timerInterval: this.seconds,
    );
    runtimTasker.start((data){
      setState(() {
        this.deviceTerminal?.nearestRunningData = AgentFake.fakeNearestRunningData(data);
        addToList(powerNowList,this.deviceTerminal?.nearestRunningData?.power ?? 0.0);
        addToList(freqList,this.deviceTerminal?.nearestRunningData?.frequency ?? 0.0);
        addToList(openList,this.deviceTerminal?.nearestRunningData?.openAngle ?? 0.0);

        EventBird().emit('NEAREST_DATA_FREQ',this.deviceTerminal);
        EventBird().emit('NEAREST_DATA_FREQ_STR',this.deviceTerminal);
        EventBird().emit('NEAREST_DATA_POWER',this.deviceTerminal);
        EventBird().emit('NEAREST_DATA_POWER_STR',this.deviceTerminal);
        EventBird().emit('NEAREST_DATA_OPEN',this.deviceTerminal);
        EventBird().emit('NEAREST_DATA_OPEN_STR',this.deviceTerminal);
        
        addToList(temperatureList,this.deviceTerminal?.nearestRunningData?.temperature ?? 0.0);
        addToList(speedList,this.deviceTerminal?.nearestRunningData?.speed ?? 0.0);
        addToList(waterStageList,this.deviceTerminal?.nearestRunningData?.waterStage ?? 0.0);
        addToList(voltageList,this.deviceTerminal?.nearestRunningData?.voltage ?? 0.0);
        addToList(excitationList,this.deviceTerminal?.nearestRunningData?.fieldCurrent ?? 0.0);
        addToList(currentList,this.deviceTerminal?.nearestRunningData?.current ?? 0.0);
        addToList(factorList,this.deviceTerminal?.nearestRunningData?.powerFactor ?? 0.0);

        //EventBird().emit('REFLASH_DATA',this.deviceTerminal);
        EventBird().emit('REFLASH_DATA_VOLTAGE',this.deviceTerminal);
        EventBird().emit('REFLASH_DATA_CURRENT',this.deviceTerminal);
        EventBird().emit('REFLASH_DATA_FACTORY',this.deviceTerminal);
        EventBird().emit('REFLASH_DATA_EXCITATION',this.deviceTerminal);
        terminalBriefFooterData();
      });
    });
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
    var voltageMax     = deviceTerminal?.waterTurbine?.ratedVoltageV?.toDouble() ?? 0.0;
    // 电流
    var currentMax     = deviceTerminal?.waterTurbine?.ratedCurrentA?.toDouble() ?? 0.0;
    // 励磁电流
    var excitationMax  = deviceTerminal?.waterTurbine?.ratedExcitationCurrentA?.toDouble() ?? 0.0;
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
                seconds: seconds,),
              RuntimeProgressExcitation(
                barMaxWidth: barMaxWidth,
                leftText: '励磁电流',
                maxData: excitationMax,
                doubleList: excitationList,
                seconds: seconds),
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
                seconds: seconds),
              RuntimeProgressFactory(
                barMaxWidth: barMaxWidth,
                leftText: '功率因数',
                maxData: powerFactorMax,
                doubleList: factorList,
                seconds: seconds),
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
                          openList:openList,
                          seconds:seconds
                          ),
        ],
      ),
    );
  }

  //温度 转速 水位数据处理
  void terminalBriefFooterData(){
    footerDataController = AnimationController(duration: Duration(seconds:this.seconds), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: footerDataController, curve: Curves.fastOutSlowIn);
    animationTemp = Tween<double>(begin: temperatureList[0], end: temperatureList[1]).animate(curvedAnimation);
    animationSpeed = Tween<double>(begin: speedList[0], end: speedList[1]).animate(curvedAnimation);
    animationWaterStage = Tween<double>(begin: waterStageList[0], end: waterStageList[1]).animate(curvedAnimation);
    animationVoltage = Tween<double>(begin: voltageList[0], end: voltageList[1]).animate(curvedAnimation);
    footerDataController.forward();
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
              animation: footerDataController,
              builder: (BuildContext context, Widget child) => RichText(
                text: TextSpan(
                  children: 
                  [
                    TextSpan(text:animationDouble.value.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
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
    
    MediaQueryData mq = MediaQuery.of(context);
    final deviceWidth = mq.size.width;
    final deviceHeight = mq.size.height;
    final statusBarHeight = mq.padding.top;
    final bottomBarHeight = mq.padding.bottom;
    final safeContentHeight =  deviceHeight - statusBarHeight - bottomBarHeight;
    final safeHeight = safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;
    final isIphone5S = deviceWidth == 320.0 ? true : false;
    final eventListHeight = safeHeight - (isIphone5S ? 350 : 400) - 140;
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
              ),
            Positioned(left: 0,right: 0,top: isIphone5S ? 350 : 400,child:isIphone5S ? Container() :Container(height:eventListHeight,child: Container(child: eventList()))),
            Positioned(left: 0,right: 0,bottom: 139,child: RunTimeLightDarkShawdow()),
            Positioned(left: 0,right: 0,bottom: 0,child: RunTimeOperationBoard(deviceTerminal,widget.address,(taskName,param) => requestRemoteControlCommand(context, taskName, param))),
          ],
      ),
    );
  }

  // 远程控制
  void requestRemoteControlCommand(
      BuildContext context, TaskName taskName, String param) async {
    progressDialog.hide();
    // 终端在线状态检测
    final isOnline = widget.isOnline ?? false;
    if (isOnline == false) {
      Progresshud.showInfoWithStatus('终端不在线,远程操作被取消');
      return;
    }
    // 远程控制检测
    var isRemoteControl = false;
    // 如果是远程控制模式开关
    if (taskName == TaskName.remoteSwitchRemoteModeOn || taskName == TaskName.remoteSwitchRemoteModeOff) {
      isRemoteControl = deviceTerminal.isOnLine == true && deviceTerminal.nearestRunningData.controlType == '智能';
    }
    // 其他指令 必须在远程控制模式打开情况下 有效
    else {
      isRemoteControl = deviceTerminal.isOnLine == true && deviceTerminal.nearestRunningData.controlType == '智能' && deviceTerminal.nearestRunningData.isAllowRemoteControl == true;
    }

    if (isRemoteControl == false) {
      Progresshud.showInfoWithStatus('请先切换到远程控制模式');
      return;
    }

    await Future.delayed(Duration(milliseconds: 300));

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
