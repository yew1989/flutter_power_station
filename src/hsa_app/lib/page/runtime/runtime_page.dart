import 'package:flutter/material.dart';
import 'package:hsa_app/components/dash_board_widget.dart';
import 'package:hsa_app/components/runtime_progress_bar.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/terminal.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:native_color/native_color.dart';

class RuntimePage extends StatefulWidget {
  final String title;
  RuntimePage(this.title);
  @override
  _RuntimePageState createState() => _RuntimePageState();
}

class _RuntimePageState extends State<RuntimePage> {

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

  static const double kHeaderHeight = 44;
  static const double kDashBoardHeight = 200;
  static const double kFootHeight = 70;
  static const double kControlBoardHeight = 126;

  @override
  void initState() {
    super.initState();
    toggleAnimationAll();
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
                  valueText: '400V',
                  redLinePercent: voltPercentRed,
                  readValuePercent: voltPercent,
                  showLabel: showVoltText),
              RuntimeProgressBar(
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
              RuntimeProgressBar(
                  barMaxWidth: barMaxWidth,
                  leftText: '电流',
                  valueText: '140A',
                  redLinePercent: currentPercentRed,
                  readValuePercent: currentPercent,
                  showLabel: showCurrentText),
              RuntimeProgressBar(
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
  Widget dashBoard() {

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
                  flex: 1,child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      // 左侧文字
                      Positioned(
                        right: 126,top: 10,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('50',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 24)),
                              SizedBox(height: 2,width: 52,child: Image.asset('images/runtime/Time_line1.png')),
                              Text('频率:Hz',style: TextStyle(color: Colors.white30,fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      // 左侧一根引出线
                      Positioned(
                        right: 62,top: 37,
                        child: Container(
                          height: 24,
                          width: 66,
                          child: Image.asset('images/runtime/Time_light_line1.png'),
                        ),
                      ),
                    ],
                  ),
                )),

                // 右侧大区
                Expanded(
                  flex: 1,child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      // 左侧文字
                      Positioned(
                        left: 113,top: 10,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('80',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 24)),
                              SizedBox(height: 2,width: 52,child: Image.asset('images/runtime/Time_line1.png')),
                              Text('开度:%',style: TextStyle(color: Colors.white30,fontSize: 11)),
                            ],
                          ),
                        ),
                      ),

                     // 右侧一根引出线
                      Positioned(
                        left: 84,top: 37,
                        child: Container(
                          height: 20,
                          width: 35,
                          child: Image.asset('images/runtime/Time_light_line2.png'),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            // 中央仪表盘
            DashBoardWidget(),
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
            terminalBriefFooterItem('54.5', '径向  '),
            terminalBriefFooterItem('46.5', '推力:N'),
            terminalBriefFooterItem('65.1', '水压:MPa'),
          ],
        )),
        color: Colors.transparent,
      );
  }

  Widget terminalBriefFooterItem(String upString, String downString) =>
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(upString, 
            style: TextStyle(color: Colors.white, fontSize: 22,fontFamily: 'ArialNarrow')),
            Text(downString,
            style: TextStyle(
              color: Colors.grey, 
              fontSize: 15,
              fontFamily: 'ArialNarrow'
              )),
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

  Widget operationBoard() {
    return SafeArea(
      child: Container(
        height: 127,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child:Stack(
          children: <Widget>[

              // 背景 分成上下两个区
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  // 上方大区
                  Expanded(
                    flex: 1,child: Container(
                    child: Row(
                      children: <Widget>[
                        
                        // 左上角
                        Expanded(flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(width: 10,
                              child:Image.asset('images/board/board_top_left1.png'),
                            ),

                            Expanded(
                                child:Image.asset('images/board/board_center.png',
                                  repeat: ImageRepeat.repeatX,
                                ),
                            ),

                            SizedBox(width: 27,
                              child:Image.asset('images/board/board_top_left2.png'),
                            ),
                          ],
                        ),
                      ),
                        SizedBox(width: 80),

                        // 右上角
                        Expanded(flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(width: 27,
                              child:Image.asset('images/board/board_top_right2.png'),
                            ),

                            Expanded(
                                child:Image.asset('images/board/board_center.png',
                                  repeat: ImageRepeat.repeatX,
                                ),
                            ),

                            SizedBox(width: 10,
                              child:Image.asset('images/board/board_top_right1.png'),
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
                    flex: 1,child: Container(
                    child: Row(
                      children: <Widget>[
                        
                        // 左上角
                        Expanded(flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(width: 10,
                              child:Image.asset('images/board/board_bottom_left1.png'),
                            ),

                            Expanded(
                                child:Image.asset('images/board/board_center.png',
                                  repeat: ImageRepeat.repeatX,
                                ),
                            ),

                            SizedBox(width: 27,
                              child:Image.asset('images/board/board_bottom_left2.png'),
                            ),
                          ],
                        ),
                      ),
                        SizedBox(width: 80),

                        // 右上角
                        Expanded(flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(width: 27,
                              child:Image.asset('images/board/board_bottom_right2.png'),
                            ),

                            Expanded(
                                child:Image.asset('images/board/board_center.png',
                                  repeat: ImageRepeat.repeatX,
                                ),
                            ),

                            SizedBox(width: 10,
                              child:Image.asset('images/board/board_bottom_right1.png'),
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
                              image: AssetImage('images/runtime/Time_power_btn.png')
                            ),
                          ),
                          child:  Center(
                              child: SizedBox(
                                height: 68,
                                width: 68,
                                child: Image.asset('images/runtime/Time_power_icon_on.png'))
                            ),
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
                  Expanded(flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // 自动
                        Expanded(
                          flex: 1,child:Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('自          动',style: TextStyle(color: Colors.white,fontSize: 15)),
                              SizedBox(height: 14,width: 14,
                                child: Image.asset('images/runtime/Time_list_icon.png'),
                              )
                            ],
                          ),
                         ),
                        ),
                        SizedBox(width: 127),
                        // 调功率
                        Expanded(
                          flex: 1,child:Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                            SizedBox(height: 22,width: 22,
                                child: Image.asset('images/runtime/Time_Apower_icon.png'),
                              ),
                            SizedBox(width: 4),
                            Text('调功',style: TextStyle(color: Colors.white,fontSize: 15)),

                            ],
                          ),
                         ),
                        ),
                      ],
                    ),
                  )),
                  // 分割线
                  SizedBox(height: 3),
                  // 下半区
                  Expanded(flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // 自动
                        Expanded(
                          flex: 1,child:Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('设备控制',style: TextStyle(color: Colors.white,fontSize: 15)),
                              SizedBox(height: 14,width: 14,
                                child: Image.asset('images/runtime/Time_list_icon.png'),
                              )
                            ],
                          ),
                         ),
                        ),
                        SizedBox(width: 127),
                        // 调功率
                        Expanded(
                          flex: 1,child:Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                            SizedBox(height: 22,width: 22,
                                child: Image.asset('images/runtime/Time_set_icon.png'),
                              ),
                            SizedBox(width: 4),
                            Text('更多',style: TextStyle(color: Colors.white,fontSize: 15)),

                            ],
                          ),
                         ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
          ],
        ) ,
      ),
    );
  }

  Widget operationBoardOld(String historyTitle, String historyUrl) => SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 127,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // 列布局
              Column(
                children: <Widget>[
                  // 第一行
                  Container(
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.black38,
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
                                      color: Colors.white, fontSize: 16),
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
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 中间间隔
                  SizedBox(height: 3),

                  // 第二行
                  Container(
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.black38,
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
                                      color: Colors.white, fontSize: 16),
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
                                // pushToPage(context, MorePage(data: this.runTimeData));
                              },
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Icon(Icons.settings,color: Colors.white, size: 22),
                                  Text('  更多',style: TextStyle(color: Colors.white, fontSize: 16)),
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
                  height: 127,
                  width: 127,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(
                        color: HexColor('4077B3'),
                        width: 3,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child:  Center(
                              child: SizedBox(
                                height: 68,
                                width: 68,
                                child: Image.asset('images/runtime/Time_power_icon_on.png'))
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

  Widget eventTile(int idx) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 44,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                     SizedBox(height: 8,width: 8,child: Image.asset('images/runtime/Time_err_list_btn.png')),
                     SizedBox(width: 4),
                     Center(
                        child: Text(
                      'ERC31--超速保护',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'ArialNarrow',
                          fontWeight: FontWeight.normal),
                      )),
                    ]
                  ),
                  Center(
                      child: Text(
                    '2019-08-23 09:37:30',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'ArialNarrow',
                      color: Colors.white54,
                    ),
                  )),
                ],
              )),
            ),
            Positioned(
              left: 0,right: 0,bottom: 0,
              child: Divider(
                height: 1,
                color: Colors.white38,
              ),
            )
          ],
        ),
      );
  }

  void onTapHistory() async {
    // var historyUrl = await buildHistoryUrl(widget.terminal);
    // pushToPage(context, WebViewPage('历史', historyUrl, noNavBar: true));
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

    // var dashBoardUrl = buildDashBoardUrl(widget.terminal);
    var dashBoardUrl = '';
    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(widget.title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 16)),
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
          color: Colors.transparent,
          child: Column(children: <Widget>[
            SizedBox(height: 12),
            terminalBriefHeader(),
            SqureMasterWidget(),
            dashBoard(),
            terminalBriefFooter(),
            SizedBox(height: 8),
            Expanded(child: eventList()),
            LightDarkShawdow(),// 淡阴影
            operationBoard(),
          ]),
        ),
      ),
    );
  }
}



class SqureMasterWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10,bottom: 10),
      child: Stack(
        children: [


          // 中位文字
          Center(
          child: SizedBox(
          height: 50,
          width: 50,
            child: Stack(
              children: 
              [
                Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Center(
                child:Transform.translate(
                  offset: Offset(0, 6),
                  child: Text('2#',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 30),
                    ),
                ),
                  ),
                ),
            
            // 角标志
            Positioned(
              left: 0,top: 0,
              child: Center(
                child: SizedBox(
                height: 29,
                width: 29,
                child: Image.asset('images/runtime/Time_host_icon.png'),
                ),
              ),
              ),

            // 文字
            Positioned(
              left: 4,top: 0,
              child: Center(
                child: Text('主',style: TextStyle(color: Colors.white,fontSize: 12)),
              ),
              ),

              ]
            ),
            ),
          ),



        ]
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
              color: HexColor('4077B3'),
              offset: Offset(20.0, 10.0),
              blurRadius: 50.0,
              spreadRadius: 30,
            )
          ],
        ),
      ),
    );
  }
}