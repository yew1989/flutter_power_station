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
  int seconds ;

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
    EventBird().on('REFLASH_DATA_CURRENT', (dt){
      init();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    EventBird().off('REFLASH_DATA_CURRENT');
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
                    width: left ,
                    margin: EdgeInsets.only(left: left ),
                    curve: Curves.easeOutSine,
                    duration: Duration(seconds: this.seconds),
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
                    duration: Duration(seconds: this.seconds),
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
                    child: Container(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) => RichText(
                            text: TextSpan(text:animation.value.toStringAsFixed(2)+'A',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 12)),
                          ),
                        )
                      )
                    ),
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