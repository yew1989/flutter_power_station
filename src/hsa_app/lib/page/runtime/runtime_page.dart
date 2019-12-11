import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/remote_task.dart';
import 'package:hsa_app/components/dash_board_widget.dart';
import 'package:hsa_app/components/runtime_progress_bar.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/runtime_adapter.dart';
import 'package:hsa_app/model/runtime_data.dart';
import 'package:hsa_app/page/dialog/control_model_dialog.dart';
import 'package:hsa_app/page/dialog/device_control_dialog.dart';
import 'package:hsa_app/page/dialog/password_dialog.dart';
import 'package:hsa_app/page/dialog/power_control_dialog.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/page/more/more_page.dart';
import 'package:hsa_app/page/runtime/runtime_event_tile.dart';
import 'package:hsa_app/page/runtime/runtime_squre_master_widget.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RuntimePage extends StatefulWidget {
  final String title;
  final String address;
  final String alias;

  RuntimePage(this.title, this.address, this.alias);

  @override
  _RuntimePageState createState() => _RuntimePageState();
}

class _RuntimePageState extends State<RuntimePage> {
  // 计算宽度
  double barMaxWidth = 0;

  static const double kHeaderHeight = 44;
  static const double kDashBoardHeight = 200;
  static const double kFootHeight = 70;
  static const double kControlBoardHeight = 126;

  // 实时数据
  RuntimeData runtimeData = RuntimeData();

  // 远程控制任务
  RemoteControlTask remoteTask = RemoteControlTask();

  // 弹出进度对话框
  ProgressDialog progressDialog;

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

  @override
  void dispose() {
    remoteTask.cancelTask();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initProgressDialog();
    requestRunTimeData();
  }

  // 请求实时数据
  void requestRunTimeData() {
    var addressId = widget.address ?? '';

    API.runtimeData(addressId, (RuntimeDataResponse data) {
      setState(() {
        this.runtimeData = RuntimeDataAdapter.adapter(data, widget.alias);
      });
    }, (String msg) {});
  }

  //  设备概要头
  Widget terminalBriefHeader() {
    // 半装
    barMaxWidth = MediaQuery.of(context).size.width / 3;

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
                  redLinePercent: voltagePecent,
                  readValuePercent: voltagePecent,
                  showLabel: true),
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '励磁电流',
                  valueText: excitationStr,
                  redLinePercent: excitationPecent,
                  readValuePercent: excitationPecent,
                  showLabel: true),
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
                  redLinePercent: currentPecent,
                  readValuePercent: currentPecent,
                  showLabel: true),
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '功率因数',
                  valueText: powfactorStr,
                  redLinePercent: powfactorPencent,
                  readValuePercent: powfactorPencent,
                  showLabel: true),
            ],
          ),
        ],
      ),
    );
  }

  void onTapPushToHistory(String address) async {
    var host = AppConfig.getInstance().webHost;
    var pageItemHistory = AppConfig.getInstance().pageBundle.history;
    var urlHistory =
        host + pageItemHistory.route ?? AppConfig.getInstance().deadLink;
    var auth = await ShareManager.instance.loadToken();
    var terminalsString = address;
    var titleString = widget?.title ?? '';
    var lastUrl = urlHistory +
        '?auth=' +
        auth +
        '&address=' +
        terminalsString +
        '&title=' +
        Uri.encodeComponent(titleString);
    debugPrint('历史曲线Url:' + lastUrl);
    pushToPage(context, WebViewPage('', lastUrl, noNavBar: true));
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
                                      fontFamily: 'ArialNarrow',
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
                                        fontFamily: 'ArialNarrow',
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
          terminalBriefFooterItem(runtimeData?.other?.radial),
          terminalBriefFooterItem(runtimeData?.other?.thrust),
          terminalBriefFooterItem(runtimeData?.other?.pressure),
        ],
      )),
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
                Text(otherData?.title ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'ArialNarrow')),
                Text(otherData?.subTitle ?? '',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'ArialNarrow')),
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

  Widget operationBoard() {
    return SafeArea(
      child: Container(
        height: 127,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                                    repeat: ImageRepeat.repeatX,
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
                                    repeat: ImageRepeat.repeatX,
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
                                    repeat: ImageRepeat.repeatX,
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
                                      'images/board/board_bottom_right2.png'),
                                ),
                                Expanded(
                                  child: Image.asset(
                                    'images/board/board_center.png',
                                    repeat: ImageRepeat.repeatX,
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
                    )),
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
                                child: Image.asset(
                                    'images/runtime/Time_power_icon_on.png'))),
                      ),
                    )
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
                          // 自动
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => ControlModelDialog());
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('自          动',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: Image.asset(
                                          'images/runtime/Time_list_icon.png'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 127),
                          // 调功率
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => PowerControlDialogWidget(
                                          powerMax: runtimeData
                                                  ?.dashboard?.power?.max
                                                  ?.toInt() ??
                                              0,
                                          onConfirmActivePower:(String activePower) {
                                            debugPrint('有功功率:' + activePower);
                                            requestRemoteSettingActivePower(context,activePower);
                                          },
                                          onConfirmPowerFactor:
                                              (String powerFactor) {
                                            debugPrint('功率因数:' + powerFactor);
                                          },
                                        ));
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset(
                                          'images/runtime/Time_Apower_icon.png'),
                                    ),
                                    SizedBox(width: 4),
                                    Text('调功',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                              ),
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
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => DeviceControlDialog());
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('设备控制',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: Image.asset(
                                          'images/runtime/Time_list_icon.png'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 127),
                          // 更多
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                pushToPage(context,
                                    MorePage(addressId: widget.address));
                              },
                              child: Container(
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
    );
  }

  // 调节有功功率
  void requestRemoteSettingActivePower(BuildContext context, String pswd) async {
    progressDialog.dismiss();
    showDialog(context: context,barrierDismissible: false,builder: (BuildContext context) {
          return PasswordDialog((String pswd) {
            // 检查操作密码
            API.checkOperationPswd(context, pswd, (String succString) {
              debugPrint('操作密码:' + succString);
              // 开始任务
              remoteTask
                  .startTask(TaskName.setttingActivePower, widget.address, null,
                      (String succString) {
                debugPrint('远程控制任务:' + succString);
              }, (String failString) {
                debugPrint('远程控制任务:' + failString);
              }, (String loadingString) {
                debugPrint('远程控制任务:' + loadingString);
              });
            }, (String failString) {
              debugPrint('操作密码:' + failString);
            });
          });
        });
  }

  // 调节功率因数
  void requestRemoteSettingPowerFactor(
      BuildContext context, String pswd) async {
    // 检查操作密码
    API.checkOperationPswd(context, pswd, (String succString) {
      debugPrint('操作密码:' + succString);
      // 开始任务
      remoteTask.startTask(TaskName.setttingActivePower, widget.address, null,
          (String succString) {
        debugPrint('远程控制任务:' + succString);
      }, (String failString) {
        debugPrint('远程控制任务:' + failString);
      }, (String loadingString) {
        debugPrint('远程控制任务:' + loadingString);
      });
    }, (String failString) {
      debugPrint('操作密码:' + failString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // progressDialog.show();
        //     // Future.delayed(Duration(seconds:1),(){
        //     //   // finishProgressDialog('操作成功',true);
        //     //   finishProgressDialog('操作失败', false);
        //     // });
        //   },
        // ),
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
                onTap: () {
                  onTapPushToHistory(widget.address);
                },
                child: Center(
                    child: Text('历史曲线',
                        style: TextStyle(color: Colors.white, fontSize: 16)))),
            SizedBox(width: 20),
          ],
        ),
        body: Container(
          color: Colors.transparent,
          child: Column(children: <Widget>[
            SizedBox(height: 12),
            terminalBriefHeader(),
            RuntimeSqureMasterWidget(
              isMaster: runtimeData?.dashboard?.isMaster ?? false,
              aliasName: runtimeData?.dashboard?.aliasName ?? '',
            ),
            dashBoardWidget(),
            terminalBriefFooter(),
            SizedBox(height: 8),
            Expanded(child: eventList()),
            RunTimeLightDarkShawdow(), // 淡阴影
            operationBoard(),
          ]),
        ),
      ),
    );
  }
}
