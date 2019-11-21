import 'package:flutter/material.dart';
import 'package:native_color/native_color.dart';

class RuntimeProgressBar extends StatelessWidget {

  RuntimeProgressBar({
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
  
  @override
  Widget build(BuildContext context) {
    var isRed = redLinePercent > readValuePercent;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 左侧
          SizedBox(width: 10),
          // 左侧电压
          Text(leftText ?? '',style: TextStyle(color: Colors.white, fontSize: 12)),
          // 间隔
          SizedBox(width: 6),
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              color: Colors.white24,
              height: 14,
              width: barMaxWidth,
              child: Stack(
                children: <Widget>[

                  // 红色警戒条
                  // AnimatedContainer(
                  //   width: barMaxWidth * redLinePercent,
                  //   color: Color(0xFFF30042),
                  //   curve: Curves.easeOutSine,
                  //   duration: Duration(milliseconds: 300),
                  // ),

                  // 渐变颜色条
                  AnimatedContainer(
                    width: barMaxWidth * readValuePercent,
                    curve: Curves.easeOutSine,
                    duration: Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          HexColor('4778f7'), 
                          HexColor('66f7f9'), 
                        ],
                      ),
                    ),
                  ),

                  // 文字交火动画
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
                                    fontSize: 12,
                                    fontFamily: 'ArialNarrow',
                                    // fontWeight: isRed
                                    //     ? FontWeight.w600
                                    //     : FontWeight.normal,
                                  ))))),
                ],
              ),
            ),
          ),
          // 右侧
          SizedBox(width: 10),
        ],
      ),
    );
  }
}