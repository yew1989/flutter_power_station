import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:native_color/native_color.dart';

class  RuntimeProgressBar extends StatefulWidget {

  final double barMaxWidth;
  final double pencent;
  final String leftText;
  final String valueText;

  const RuntimeProgressBar({Key key, this.barMaxWidth, this.pencent, this.leftText, this.valueText}) : super(key: key);

  @override
  _RuntimeProgressBarState createState() => _RuntimeProgressBarState();
}

class _RuntimeProgressBarState extends State<RuntimeProgressBar> {
  
  bool isShowText = false;

  void showText() async {
    await Future.delayed(Duration(milliseconds: 500));
    if(mounted) {
      setState(() {
        isShowText = true;
      });
    }
  }

  @override
  void initState() {
    showText();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

      final ratio = widget?.pencent ?? 0.0;
      final maxWidth = widget?.barMaxWidth ?? 0.0;
      
      bool isBeyond = false;
      double right = 0;
      double left = 0;

      // 超量程
      if(ratio > 1.0) {
        isBeyond = true;
        var beyond = ratio - 1.0;
        // 为了好看,超量程部分放大3倍
        beyond = beyond * 3;
        final rightRatio = 1.0 - beyond;
        right = maxWidth * (1.0 - rightRatio);
        left =  maxWidth - (maxWidth *  beyond);
      }
      // 正常发电
      else {
        isBeyond = false;
        right = maxWidth * (1 - ratio);
      }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 左侧
          SizedBox(width: 10),
          // 左侧电压
          Text(widget?.leftText ?? '',style: TextStyle(color: Colors.white, fontSize: 12)),
          // 间隔
          SizedBox(width: 6),
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              color: Colors.white24,
              height: 14,
              width: widget.barMaxWidth,
              child: Stack(
                children: <Widget>[

                  // 渐变颜色条 红色
                  isBeyond ? AnimatedContainer(
                        alignment: Alignment.centerRight,
                        width: isShowText == true ? left : maxWidth,
                        margin: EdgeInsets.only(left: isShowText == true ? left : 0),
                        curve: Curves.easeOutSine,
                        duration: Duration(milliseconds: 600),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                             Color(0xfff8083a), 
                             Color(0x99f8083a), 
                          ],
                        ),
                      ),
                    ): Container(),
                  // 渐变颜色条 蓝色
                  AnimatedContainer(
                      width: maxWidth - right,
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
                  Positioned(
                    left: 0,right: 0,bottom: 0,
                    child: AnimatedCrossFade(
                        crossFadeState: isShowText ?  CrossFadeState .showSecond : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 300),
                        firstChild: Text(''),
                        secondChild: Container(
                            child: Center(
                                child: Text(widget?.valueText ?? '',
                                    style: TextStyle(
                                      color: isBeyond
                                          ? Color(0xfff8083a)
                                          : Colors.white,
                                      fontSize: 12,
                                      fontFamily: AppConfig.getInstance().numberFontName))))),
                  ),



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