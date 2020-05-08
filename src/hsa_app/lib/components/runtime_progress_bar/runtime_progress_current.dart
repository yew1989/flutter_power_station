import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class  RuntimeProgressCurrent extends StatefulWidget {
  final double maxData;
  final String leftText;
  final int seconds;
  final List<double> doubleList;
  final double barMaxWidth;


  const RuntimeProgressCurrent({Key key, this.barMaxWidth,this.maxData , this.leftText,this.doubleList,this.seconds}) : super(key: key);

  @override
  _RuntimeProgressCurrentState createState() => _RuntimeProgressCurrentState();
}

class _RuntimeProgressCurrentState extends State<RuntimeProgressCurrent> with TickerProviderStateMixin{
  
  AnimationController controller;
  Animation<double> animation;

  double ratio;
  double oldData ;
  double newData ;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 1;

  void initAnimateController(){

    this.oldData = widget?.doubleList[0] ?? 0.0;
    this.newData = widget?.doubleList[1] ?? 0.0;
    if(canPlayAnimationOnZero <= 0  && mounted) {
      controller?.dispose();
      controller = AnimationController(duration: Duration(seconds:widget.seconds), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: oldData, end: newData).animate(curvedAnimation);
      controller.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero --;

  }

  @override
  void initState() {

    super.initState();
    initAnimateController();
    eventBird?.on('NEAREST_DATA', (_){
      initAnimateController();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    eventBird?.off('NEAREST_DATA');
    super.dispose();
  }

  void math(){
    var maxData = widget?.maxData;
    ratio = RuntimeDataAdapter.caclulatePencent(this.newData,maxData);
  } 
  
  @override
  Widget build(BuildContext context) {

    math();

    final maxWidth = widget?.barMaxWidth ?? 0.0;
    
    bool isBeyond = false;
    double right = 0;

    // 超量程
    if(ratio > 1.0) {
      isBeyond = true;
      var beyond = ratio - 1.0;
      if(beyond > 1.0) {
        beyond = 1.0;
      }
      right = maxWidth * beyond;
    }
    // 正常发电
    else {
      isBeyond = false;
      right = maxWidth * (1 - ratio);
    }

    Widget redAlaph(){
      return AnimatedContainer(
        alignment: Alignment.centerRight,
        width: maxWidth ,
        margin: EdgeInsets.only(right: 0 ,left:  0),
        curve: Curves.easeOutSine,
        duration: Duration(seconds:widget.seconds),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isBeyond ? Color(0xfff8083a) : Colors.transparent, 
              isBeyond ? Color(0x99f8083a) : Colors.transparent, 
            ],
          ),
        ),
      );
    }

    Widget blue(){
      return AnimatedContainer(
        width: maxWidth - right,
        curve: Curves.easeOutSine,
        duration: Duration(seconds: widget.seconds),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor('4778f7'), 
              HexColor('66f7f9'), 
            ],
          ),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 左侧
          SizedBox(width: 10),
          // 左侧文本
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
                  redAlaph(),
                  // 渐变颜色条 蓝色
                  blue(),
                  // 文字动画
                  animateNumberWidget(),
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

  // 数字动画
  Widget animateNumberWidget() {
    final defaultValue = widget?.doubleList[0] ?? 0.0;
    if(controller == null || animation == null) {
      return Positioned(
        left: 0,right: 0,bottom: 0,
        child: Center(child: RichText(text: TextSpan(text:defaultValue.toStringAsFixed(2)+'A',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 12)))));
    }
    else {
      return Positioned(left: 0,right: 0,bottom: 0,child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) => RichText(
            text: TextSpan(text:animation.value.toStringAsFixed(2)+'A',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 12)),
          ),
        )),
      );
    }
  }
}