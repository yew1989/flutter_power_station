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
  
  AnimationController controller;
  Animation<double> animation;

  double ratio;
  double oldData ;
  double newData ;
  int seconds ;

  bool isBeyond = false;
  double right = 0;
  double left = 0;
  // int redT = 0;
  // int blueT = 0;
  int t = 0;

  var maxWidth;

  void init(){
    this.seconds = widget?.seconds ?? 5;

    this.oldData = widget?.doubleList[0] ?? 0.0;
    this.newData = widget?.doubleList[1] ?? 0.0;

    controller = AnimationController(duration: Duration(seconds:seconds), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: oldData, end: newData).animate(curvedAnimation);
    controller.forward();
  }

  @override
  void initState() {
    init();
    EventBird().on('REFLASH_DATA_VOLTAGE', (dt){
      init();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    EventBird().off('REFLASH_DATA_VOLTAGE');
    super.dispose();
  }

  void math(){
    var maxData = widget?.maxData;
    ratio = RuntimeDataAdapter.caclulatePencent(this.newData,maxData);
    maxWidth = widget?.barMaxWidth ?? 0.0;

    if(oldData < newData){
      if(maxData - oldData > 0 ){
        t = ((maxData - oldData) / (newData - oldData) * seconds * 1000).round();
      } else{
        t = 0;
      }
    }else if(oldData > newData){
      if(oldData - maxData > 0){
        t = ((oldData - maxData) / (oldData - newData) * seconds * 1000).round();
      }else{
        t = 0;
      }
    }
     

    // 超量程
    if(ratio > 1.0) {
      isBeyond = true;
      var beyond = ratio - 1.0;
      // 为了好看,超量程部分放大3倍
      // beyond = beyond * 3;
      //final rightRatio = 1.0 - beyond;
      right = maxWidth * beyond;
      //right = 0;
      left =  maxWidth - (maxWidth *  beyond);
      
      // setState(() {
      //   right = maxWidth * beyond;
      //   t = seconds * 1000 - t;
      // });
    }
    // 正常发电
    else {
      isBeyond = false;
      right = maxWidth * (1 - ratio);
    }
  } 
  
  Widget red(){
    math();
    //await Future.delayed(Duration(microseconds:blueT));
    return AnimatedContainer(
      alignment: Alignment.centerRight,
      // width: left ,
      margin: EdgeInsets.only(right: 0 ,left:  left),
      curve: Curves.easeOutSine,
      duration: Duration(seconds:seconds ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xfff8083a), 
            Color(0x99f8083a), 
          ],
        ),
      ),
    );
  }

    Widget redAlaph(){
    // math();
    //await Future.delayed(Duration(microseconds:blueT));
    return AnimatedContainer(
      alignment: Alignment.centerRight,
      width: maxWidth ,
      margin: EdgeInsets.only(right: 0 ,left:  0),
      curve: Curves.easeOutSine,
      duration: Duration(seconds:0 ),
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
    math();
    //await Future.delayed(Duration(microseconds:redT));
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
                  // red() ,
                  redAlaph(),
                  // 渐变颜色条 蓝色
                  blue(),

                  

                  // 文字交火动画
                  Positioned(
                    left: 0,right: 0,bottom: 0,
                    child: Container(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) => RichText(
                            text: TextSpan(text:animation.value.toStringAsFixed(2)+'V',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 12)),
                          ),
                        ))),
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