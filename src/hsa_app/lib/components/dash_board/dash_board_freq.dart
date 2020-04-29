import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';

class DashBoardFreq extends StatefulWidget {

  final List<double> freqList;

  const DashBoardFreq(this.freqList,{Key key}) : super(key: key);
  @override
  _DashBoardFreqState createState() => _DashBoardFreqState();
}

class _DashBoardFreqState extends State<DashBoardFreq> with TickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 1;


  void init(){

    final freqOld = widget?.freqList[0] ?? 0.0;
    final freqnew = widget?.freqList[1] ?? 0.0;

    if(canPlayAnimationOnZero <= 0 && mounted) {
      controller?.dispose();
      controller = AnimationController(duration: Duration(milliseconds:AppConfig.getInstance().runtimePageAnimationDuration), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: freqOld, end: freqnew).animate(curvedAnimation);
      controller.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero --;
    
  }
  
  @override
  void dispose() {
    controller?.dispose();
    eventBird?.off('NEAREST_DATA');
    super.dispose();
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
  Widget build(BuildContext context) {
    
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          animateNumberWidget(),
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
    );
  }

  // 数字动画
  Widget animateNumberWidget() {
    final defaultValue = widget?.freqList[0] ?? 0.0;
      if(controller == null || animation == null) {
      return RichText(text: TextSpan(
        children: 
          [
            TextSpan(text:defaultValue.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
          ]
        ),
      );
    }
    else {
      return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) => RichText(
          text: TextSpan(
            children: 
            [
              TextSpan(text:animation.value.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
            ]
          ),
        ),
      );
    }
  }
}