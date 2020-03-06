import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/remote_task.dart';
import 'package:hsa_app/components/dash_board_widget.dart';
import 'package:hsa_app/components/runtime_progress_bar.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:hsa_app/model/runtime_data.dart';
import 'package:hsa_app/page/dialog/control_model_dialog.dart';
import 'package:hsa_app/page/dialog/password_dialog.dart';
import 'package:hsa_app/page/history/history_page.dart';
import 'package:hsa_app/page/runtime/runtime_event_tile.dart';
import 'package:hsa_app/page/runtime/runtime_operation_board.dart';
import 'package:hsa_app/page/runtime/runtime_squre_master_widget.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:ovprogresshud/progresshud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RuntimePage extends StatefulWidget {
  final String title;
  final String address;
  final String alias;
  final bool isOnline;

  RuntimePage(this.title, this.address, this.alias, this.isOnline);

  @override
  _RuntimePageState createState() => _RuntimePageState();
}

class _RuntimePageState extends State<RuntimePage> {
  RefreshController refreshController = RefreshController(initialRefresh: false);

  // 计算宽度
  double barMaxWidth = 0;

  static const double kHeaderHeight = 44;

  // 实时数据
  RuntimeData runtimeData = RuntimeData();

  // 远程控制任务
  RemoteControlTask remoteTask = RemoteControlTask();

  // 弹出进度对话框
  ProgressDialog progressDialog;

  // 轮询定时器
  Timer runLoopTimer;

  final pageIndexNotifier = ValueNotifier<int>(0);

  // 初始化弹出框
  void initProgressDialog() {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
            fontWeight: FontWeight.normal));
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

  // 轮询查询
  void startRunLoopTimer(int runLoopSecond) async {
    await Future.delayed(Duration(seconds: 1));
    runLoopTimer = Timer.periodic(Duration(seconds: runLoopSecond),
        (_) => requestRunTimeDataInBackground());
  }

  @override
  void initState() {
    initProgressDialog();
    requestRunTimeData();
    UMengAnalyticsService.enterPage('机组实时');
    // startRunLoopTimer(5);
    super.initState();
  }

  @override
  void dispose() {
    runLoopTimer?.cancel();
    remoteTask.cancelTask();
    Progresshud.dismiss();
    UMengAnalyticsService.exitPage('机组实时');
    super.dispose();
  }

  // 请求实时数据
  void requestRunTimeData() {
    Progresshud.showWithStatus('读取数据中...');

    final addressId = widget.address ?? '';

    if (addressId.length == 0) {
      Progresshud.showInfoWithStatus('获取实时机组数据失败');
      return;
    }

    API.runtimeData(addressId, (RuntimeDataResponse data) {
      Progresshud.dismiss();
      refreshController.refreshCompleted();
      setState(() {
        this.runtimeData = RuntimeDataAdapter.adapter(data, widget.alias);
      });
    }, (String msg) {
      Progresshud.showInfoWithStatus('获取实时机组数据失败');
      refreshController.refreshFailed();
      
    });
  }

  // 静默任务请求
  void requestRunTimeDataInBackground() async {
    final addressId = widget.address ?? '';
    if (addressId.length == 0) {
      runLoopTimer?.cancel();
      return;
    }
    API.runtimeData(addressId, (RuntimeDataResponse data) {
      setState(() {
        this.runtimeData = RuntimeDataAdapter.adapter(data, widget.alias);
      });
    }, (_) {});
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
    var voltage = runtimeData?.electrical?.voltage?.now ?? 0.0;
    var voltageStr = voltage.toString() + 'V';
    var voltagePecent = runtimeData?.electrical?.voltage?.percent ?? 0.0;

    // 电流
    var current = runtimeData?.electrical?.current?.now ?? 0.0;
    var currentStr = current.toString() + 'A';
    var currentPecent = runtimeData?.electrical?.current?.percent ?? 0.0;

    // 励磁电流
    var excitation = runtimeData?.electrical?.excitation?.now ?? 0.0;
    var excitationStr = excitation.toString() + 'A';
    var excitationPecent = runtimeData?.electrical?.excitation?.percent ?? 0.0;

    // 功率因数
    var powfactor = runtimeData?.electrical?.powerFactor?.now ?? 0.0;
    var powfactorStr = powfactor.toStringAsFixed(2);
    var powfactorPencent = runtimeData?.electrical?.powerFactor?.percent ?? 0.0;

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

  void onTapPushToHistoryPage(String navTitle, String address) async {
    pushToPage(context, HistoryPage(title: navTitle, address: address));
  }

  // 仪表盘
  Widget dashBoardWidget() {
    // 频率
    var freqNow = runtimeData?.dashboard?.freq?.now ?? 0.0;
    var freqNowStr = freqNow.toStringAsFixed(2);

    // 开度
    var openNow = runtimeData?.dashboard?.open?.now ?? 0.0;
    openNow *= 100;
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
          DashBoardWidget(dashBoardData: runtimeData.dashboard),
        ],
      ),
    );
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
                    child:
                        terminalBriefFooterItem(runtimeData?.other?.radial))),
            Expanded(
                flex: 1,
                child: Container(
                    height: 50,
                    color: Colors.transparent,
                    child:
                        terminalBriefFooterItem(runtimeData?.other?.thrust))),
            Expanded(
                flex: 1,
                child: Container(
                    height: 50,
                    color: Colors.transparent,
                    child:
                        terminalBriefFooterItem(runtimeData?.other?.pressure))),
          ],
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget terminalBriefFooterItem(OtherData otherData) {
    return otherData != null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(otherData?.title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: AppTheme().numberFontName)),
                ),
                Center(
                  child: Text(otherData?.subTitle ?? '',
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
        itemCount: runtimeData?.events?.length ?? 0,
        itemBuilder: (_, index) {
          var event = runtimeData?.events[index];
          return RuntimeEventTile(event: event);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final isIphone5S = deviceWidth == 320.0 ? true : false;
    final historyNavTitle = widget.title;
    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(widget.title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 20)),
          actions: <Widget>[
            GestureDetector(
                onTap: () =>
                    onTapPushToHistoryPage(historyNavTitle, widget.address),
                child: Center(
                    child: Text('历史曲线',
                        style: TextStyle(color: Colors.white, fontSize: 16)))),
            SizedBox(width: 20),
          ],
        ),
        // body: Stack(alignment: FractionalOffset.topCenter, children: [
        //   PageView.builder(
        //     onPageChanged: (index) => pageIndexNotifier.value = index,
        //     itemCount: pageLength,
        //     itemBuilder: (context, index) {
        //       return Container(
        //   color: Colors.transparent,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children:[
        //     Container(
        //       height: isIphone5S ? 350 : 400,
        //       child: SmartRefresher(
        //         header: appRefreshHeader(),
        //         enablePullDown: true,
        //         onRefresh: requestRunTimeData,
        //         controller: refreshController,
        //         child: ListView(
        //         children: <Widget>[
        //           SizedBox(height: 12),
        //           terminalBriefHeader(),
        //           RuntimeSqureMasterWidget(
        //            isMaster: runtimeData?.dashboard?.isMaster ?? false,
        //             aliasName: runtimeData?.dashboard?.aliasName ?? '',
        //           ),
        //           dashBoardWidget(),
        //           terminalBriefFooter(),
        //           SizedBox(height: 8),
        //           ],
        //         ),
        //       ),
        //     ),
        //     isIphone5S ? Container() :Expanded(child: eventList()),
        //     RunTimeLightDarkShawdow(),
        //     RunTimeOperationBoard(runtimeData,widget.address,(taskName,param) => requestRemoteControlCommand(context, taskName, param)),

        //   ]),
        // );
        //     },
        //   ),
        //   PageViewIndicator(
        //     indicatorPadding: const EdgeInsets.all(0.0),
        //     pageIndexNotifier: pageIndexNotifier,
        //     length: pageLength,
        //     normalBuilder: (animationController, index) => ScaleTransition(
        //       child: SizedBox(
        //           height: 8,
        //           width: 18,
        //           child: Image.asset(
        //               'images/common/Common_list_control2_btn.png')),
        //       scale: CurvedAnimation(
        //         parent: animationController,
        //         curve: Curves.ease,
        //       ),
        //     ),
        //     highlightedBuilder: (animationController, index) => ScaleTransition(
        //       scale: CurvedAnimation(
        //         parent: animationController,
        //         curve: Curves.ease,
        //       ),
        //       child: SizedBox(
        //         height: 8,
        //         width: 18,
        //         child:
        //             Image.asset('images/common/Common_list_control3_btn.png'),
        //       ),
        //     ),
        //   ),
        // ]),
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
                    isMaster: runtimeData?.dashboard?.isMaster ?? false,
                    aliasName: runtimeData?.dashboard?.aliasName ?? '',
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
            RunTimeOperationBoard(runtimeData,widget.address,(taskName,param) => requestRemoteControlCommand(context, taskName, param)),

          ]),
        ),
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
    if (taskName == TaskName.switchRemoteOn ||
        taskName == TaskName.switchRemoteOff) {
      isRemoteControl =
          runtimeData.status == ControlModelCurrentStatus.remoteOn ||
              runtimeData.status == ControlModelCurrentStatus.remoteOff;
    }
    // 其他指令 必须在远程控制模式打开情况下 有效
    else {
      isRemoteControl =
          runtimeData.status == ControlModelCurrentStatus.remoteOn;
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
            // 检查操作密码
            API.checkOperationPswd(context, pswd, (String succString) {
              debugPrint('操作密码 🔑 :' + succString);
              // 开始任务
              progressDialog.show();
              remoteTask.startTask(taskName, widget.address, param,
                  (String succString) {
                finishProgressDialog(succString, true);
              }, (String failString) {
                finishProgressDialog(failString, false);
              }, (String loadingString) {
                updateProgressDialog(loadingString);
              });
            }, (_) {
              showOperationPasswordPopWindow();
            });
          });
        });
  }
}
