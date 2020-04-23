import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/runtime_adapter.dart';
import 'package:native_color/native_color.dart';

class  RuntimeProgressVoltage extends StatefulWidget {
  final double maxData;
  final String leftText;
  final int seconds;
  final List<double> doubleList;
  final double barMaxWidth;


  const RuntimeProgressVoltage({Key key, this.barMaxWidth,this.maxData , this.leftText,this.doubleList,this.seconds}) : super(key: key);

  @override
  _RuntimeProgressVoltageState createState() => _RuntimeProgressVoltageState();
}

class _RuntimeProgressVoltageState extends State<RuntimeProgressVoltage> with TickerProviderStateMixin{
  
  AnimationController _controller;
  Animation<double> animation;

  double ratio;
  double oldData ;
  double newData ;
  int seconds ;

  bool isBeyond = false;
  double right = 0;
  double left = 0;
  var beyond;
  int t = 0;

  var maxWidth;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 2;

  void init(){
    this.seconds = widget?.seconds ?? 5;
    this.oldData = widget?.doubleList[0] ?? 0.0;
    this.newData = widget?.doubleList[1] ?? 0.0;

    if(canPlayAnimationOnZero <= 0  && mounted ) {
      _controller = AnimationController(duration: Duration(seconds:seconds), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: oldData, end: newData).animate(curvedAnimation);
      _controller.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero --;

  }

  @override
  void initState() {
    super.initState();
    init();
    eventBird?.on('NEAREST_DATA', (dt){
        init();
    });
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    eventBird?.off('NEAREST_DATA');
    super.dispose();
  }

  void math(){
    var maxData = widget?.maxData;
    ratio = RuntimeDataAdapter.caclulatePencent(this.newData,maxData);
    maxWidth = widget?.barMaxWidth ?? 0.0;

    // 超量程
    if(ratio > 1.0) {
      isBeyond = true;
      beyond = ratio - 1.0;
      if(beyond > 1.0) {
        beyond = 1.0;
      }
      right = maxWidth * beyond;
      left =  maxWidth - (maxWidth *  beyond);
    }
    // 正常发电
    else {
      isBeyond = false;
      right = maxWidth * (1 - ratio);
    }
  } 

  Widget redAlaph(){
    return AnimatedContainer(
      alignment: Alignment.centerRight,
      width: maxWidth ,
      margin: EdgeInsets.only(right: 0 ,left:  0),
      curve: Curves.easeOutSine,
      duration: Duration(seconds:seconds ),
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
      duration: Duration(milliseconds: seconds*1000),
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


  @override
  Widget build(BuildContext context) {
    math();
      
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
    if(_controller == null || animation == null) {
      return Positioned(
        left: 0,right: 0,bottom: 0,
        child: Center(child: RichText(text: TextSpan(text:defaultValue.toStringAsFixed(2)+'V',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 12)))));
    }
    else {
      return Positioned(left: 0,right: 0,bottom: 0,child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) => RichText(
            text: TextSpan(text:animation.value.toStringAsFixed(2)+'V',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 12)),
          ),
        )),
      );
    }
  }
  
}