import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/runtimedata.dart';
import 'package:hsa_app/model/terminal.dart';
import 'package:hsa_app/page/debug/widget_page.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/page/more/more_page.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';

class TerminalPage extends StatefulWidget {
  final String title;
  final Terminal terminal;
  TerminalPage(this.title, this.terminal);
  @override
  _StationPageState createState() => _StationPageState();
}

class _StationPageState extends State<TerminalPage> {

  // 计算宽度
  double barMaxWidth = 0;

  // 电压
  double voltPercent = 0;
  double voltPercentRed = 0;
  bool showVoltText = false;

  // 励磁电流
  double excitationCurrentPercent = 0;
  double excitationCurrentPercentRed = 0;
  bool showexcitationCurrentText = false;

  // 电流
  double currentPercent = 0;
  double currentPercentRed = 0;
  bool showCurrentText = false;

  // 功率因数
  double powerFactorPercent = 0;
  double powerFactorPercentRed = 0;
  bool showPowerFactorText = false;

  static const double kHeaderHeight = 120;
  static const double kDashBoardHeight = 200;
  static const double kFootHeight = 70;
  static const double kControlBoardHeight = 126;

  // 运行时数据
  RunTimeData runTimeData;

  @override
  void initState() {
    super.initState();
    // toggleAnimationAll();
    requestForRunTimeData();
  }

  // 动画触发器
  void toggleAnimationAll() {
    toggleAnimationVolt();
    toggleAnimationExcitationCurrent();
    toggleAnimationCurrent();
    toggleAnimationPowerFactor();
  }

  void toggleAnimationVolt() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        voltPercent = 0.65;
        voltPercentRed = 0.65;
        showVoltText = true;
      });
    });
  }

  // 获取运行时数据
  void requestForRunTimeData() async {
    var data = await API.runtimeData(widget.terminal.terminalAddress);
    if( data == null)return;
    setState(() {
      this.runTimeData = data;
    });
  }

  void toggleAnimationExcitationCurrent() {
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        excitationCurrentPercent = 0.40;
        excitationCurrentPercentRed = 0.40;
        showexcitationCurrentText = true;
      });
    });
  }

  void toggleAnimationCurrent() {
    Future.delayed(Duration(milliseconds: 1400), () {
      setState(() {
        currentPercent = 0.75;
        currentPercentRed = 0.85;
        showCurrentText = true;
      });
    });
  }

  void toggleAnimationPowerFactor() {
    Future.delayed(Duration(milliseconds: 1600), () {
      setState(() {
        powerFactorPercent = 0.76;
        powerFactorPercentRed = 0.76;
        showPowerFactorText = true;
      });
    });
  }

  void resetAndToggle() {
    setState(() {
      voltPercent = 0;
      voltPercentRed = 0;
      showVoltText = false;

      excitationCurrentPercent = 0;
      excitationCurrentPercentRed = 0;
      showexcitationCurrentText = false;

      currentPercent = 0;
      currentPercentRed = 0;
      showCurrentText = false;

      powerFactorPercent = 0;
      powerFactorPercentRed = 0;
      showPowerFactorText = false;
    });
    toggleAnimationVolt();
    toggleAnimationCurrent();
    toggleAnimationExcitationCurrent();
    toggleAnimationPowerFactor();
  }

  //  设备概要头
  Widget terminalBriefHeader() {
    barMaxWidth = MediaQuery.of(context).size.width / 3;
    return Container(
      color: Colors.transparent,
      height: kHeaderHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DeviceParamBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '电压',
                  valueText: '400V',
                  redLinePercent: voltPercentRed,
                  readValuePercent: voltPercent,
                  showLabel: showVoltText),
              DeviceParamBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '励磁电流',
                  valueText: '3.22A',
                  redLinePercent: excitationCurrentPercentRed,
                  readValuePercent: excitationCurrentPercent,
                  showLabel: showexcitationCurrentText),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DeviceParamBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '电流',
                  valueText: '140A',
                  redLinePercent: currentPercentRed,
                  readValuePercent: currentPercent,
                  showLabel: showCurrentText),
              DeviceParamBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '功率因数',
                  valueText: '0.76',
                  redLinePercent: powerFactorPercentRed,
                  readValuePercent: powerFactorPercent,
                  showLabel: showPowerFactorText),
            ],
          ),
        ],
      ),
    );
  }

  /// dashboard URL
  Future<String> buildHistoryUrl(Terminal terminals) async {
    var host = AppConfig.getInstance().webHost;
    var pageItemHistory = AppConfig.getInstance().pageBundle.history;
    var urlHistory =
        host + pageItemHistory.route ?? AppConfig.getInstance().deadLink;
    var auth = await ShareManager.instance.loadToken();
    return urlHistory +
        '?auth=' +
        auth +
        '&address=' +
        terminals.terminalAddress;
  }

  // 仪表盘
  Widget dashBoard(String url) {
    return Container(
        height: 200,
        color: Colors.black,
        child: Container(
          color: Colors.black,
        ));
  }

  //  设备概要尾
  Widget terminalBriefFooter() => Container(
        height: kFootHeight,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            terminalBriefFooterItem('54.5', '径向  '),
            terminalBriefFooterItem('46.5', '推力:N'),
            terminalBriefFooterItem('65.1', '水压:MPa'),
          ],
        )),
        color: Colors.transparent,
      );

  Widget terminalBriefFooterItem(String upString, String downString) =>
      Container(
        height: kFootHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(upString, style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 6),
            Text(downString,
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );

  // 事件列表
  Widget eventList() {
    return Container(
      child: ListView.builder(
        // primary: false,
        // shrinkWrap: true,
        // physics:NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (_, idx) => eventTile(idx),
      ),
    );
  }

  Widget innerButton(String title, {String url, String navTitle}) => Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text('$title', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (title == '历史') {
                url = url + '?address=' + '00130071';
                pushToPage(context, WebViewPage(navTitle, url));
              }
            }), 
      ));

  Widget operationBoard(String historyTitle, String historyUrl) => SafeArea(
        child: Container(
  
          margin: EdgeInsets.symmetric(horizontal: 12),
          height: kControlBoardHeight,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // 列布局
              Column(
                children: <Widget>[
                  // 第一行
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(27, 25, 34, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '自      动',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.white, size: 30),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.card_giftcard,
                                    color: Colors.white, size: 22),
                                Text(
                                  '  调功',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 中间间隔
                  SizedBox(height: 6),

                  // 第二行
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(27, 25, 34, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '设备控制',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.white, size: 30),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),

     
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                pushToPage(context, MorePage(data: this.runTimeData));
                              },
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Icon(Icons.settings,color: Colors.white, size: 22),
                                  Text('  更多',style: TextStyle(color: Colors.white, fontSize: 20)),
                                ],
                              ),
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
                  height: kControlBoardHeight,
                  width: kControlBoardHeight,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(27, 25, 34, 1),
                    border: Border.all(
                        color: Colors.black,
                        width: 4,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('空',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Text('转',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ))),
                          SizedBox(
                            width: 4,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('空',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Text('载',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ))),
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.white,
                              child: Icon(Icons.power_settings_new,
                                  color: Colors.blueAccent, size: 30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget eventTile(int idx) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 36,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text(
                    '• ERC31--超速保护',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  )),
                  Center(
                      child: Text(
                    '2019-08-23 09:37:30',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )),
                ],
              )),
            ),
            SizedBox(height: 4),
            Divider(
              height: 1,
              color: Colors.grey[700],
            )
          ],
        ),
      );

  void onTapHistory() async {
    var historyUrl = await buildHistoryUrl(widget.terminal);
    pushToPage(context, WebViewPage('历史', historyUrl, noNavBar: true));
  }

  String buildDashBoardUrl(Terminal terminals) {
    var host = AppConfig.getInstance().webHost;
    var pageItemDashBoard = AppConfig.getInstance().pageBundle.mypowerchart;
    var urlDashBoard =
        host + pageItemDashBoard.route ?? AppConfig.getInstance().deadLink;
    var auth = ShareManager.instance.token;
    return urlDashBoard + '?auth=' + auth + '&address=' + terminals.terminalAddress;
  }

  @override
  Widget build(BuildContext context) {
    var host = AppConfig.getInstance().webHost;
    var pageItemPower = AppConfig.getInstance().pageBundle.mypowerchart;
    var urlPower =  host + pageItemPower.route ?? AppConfig.getInstance().deadLink;

    var pageItemHistory = AppConfig.getInstance().pageBundle.history;
    var urlHistory =
        host + pageItemHistory.route ?? AppConfig.getInstance().deadLink;
    var titleHistory = pageItemHistory.title ?? '';

    var dashBoardUrl = buildDashBoardUrl(widget.terminal);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                onTapHistory();
              },
              child: Center(
                  child: Text('历史曲线',
                      style: TextStyle(color: Colors.white, fontSize: 16)))),
          SizedBox(width: 20),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(children: <Widget>[
          terminalBriefHeader(),
          dashBoard(dashBoardUrl),
          terminalBriefFooter(),
          Expanded(child: eventList()),
          // 淡阴影
          LightDarkShawdow(),
          operationBoard(titleHistory, urlHistory),
          SizedBox(height: 10),
        ]),
      ),
    );
  }
}

class LightDarkShawdow extends StatelessWidget {
  const LightDarkShawdow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(20.0, 10.0),
              blurRadius: 50.0,
              spreadRadius: 40,
            )
          ],
        ),
      ),
    );
  }
}
