import 'package:flutter/material.dart';

class WidgetDebugPage extends StatefulWidget {
  @override
  _WidgetDebugPageState createState() => _WidgetDebugPageState();
}

class _WidgetDebugPageState extends State<WidgetDebugPage> {
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    barMaxWidth = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          resetAndToggle();
        },
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.transparent,
              // child: DashBoard(),
            ),
            Container(
              color: Colors.transparent,
              height: 120,
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
            )
          ],
        ),
      ),
    );
  }
}

class DeviceParamBar extends StatelessWidget {
  DeviceParamBar({
    Key key,
    @required this.barMaxWidth,
    @required this.leftText,
    @required this.valueText,
    @required this.redLinePercent,
    @required this.readValuePercent,
    @required this.showLabel,
  }) : super(key: key);

  final double barMaxWidth;
  final double redLinePercent;
  final double readValuePercent;
  final bool showLabel;
  final String leftText;
  final String valueText;

  bool isRed = false;

  @override
  Widget build(BuildContext context) {
    isRed = redLinePercent > readValuePercent;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(leftText ?? '',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: Colors.white,
              height: 20,
              width: barMaxWidth,
              child: Stack(
                children: <Widget>[
                  // 红色警戒条
                  AnimatedContainer(
                    width: barMaxWidth * redLinePercent,
                    color: Color(0xFFF30042),
                    curve: Curves.easeOutSine,
                    duration: Duration(milliseconds: 300),
                  ),

                  // 渐变颜色条
                  AnimatedContainer(
                    width: barMaxWidth * readValuePercent,
                    curve: Curves.easeOutSine,
                    duration: Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3E3A9A), Color(0xFF7853A8)],
                      ),
                    ),
                  ),

                  // 交火动画
                  AnimatedCrossFade(
                      crossFadeState: showLabel
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 600),
                      firstChild: Text(''),
                      secondChild: Container(
                          width: barMaxWidth * readValuePercent,
                          child: Center(
                              child: Text(valueText ?? '',
                                  style: TextStyle(
                                    color: isRed
                                        ? Color(0xFFF30042)
                                        : Colors.white,
                                    fontSize: 13,
                                    fontWeight: isRed
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ))))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
