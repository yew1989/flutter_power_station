import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';

class DashBoardCenterLabel extends StatefulWidget {

  final List<double> powerNowList;
  final String powerMaxStr;

  const DashBoardCenterLabel(this.powerNowList, this.powerMaxStr,{Key key}) : super(key: key);
  @override
  _DashBoardCenterLabelState createState() => _DashBoardCenterLabelState();
}

class _DashBoardCenterLabelState extends State<DashBoardCenterLabel> with TickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 2;

  void init(){

    final oldPower = widget?.powerNowList[0] ?? 0.0;
    final powerNow = widget?.powerNowList[1] ?? 0.0;

    if(canPlayAnimationOnZero <= 0) {
      controller = AnimationController(duration: Duration(milliseconds:5000), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: oldPower, end: powerNow).animate(curvedAnimation);
      controller.forward();
      canPlayAnimationOnZero = 0;
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
          SizedBox(height: 2,width:50,child: Image.asset('images/runtime/Time_line1.png')),
          SizedBox(height: 2),
          Text(widget.powerMaxStr ?? '',style: TextStyle(color: Colors.white38,fontSize: 15,fontFamily: AppTheme().numberFontName)),
          ],
      ),
    );
  }
  
  // 数字动画
  Widget animateNumberWidget() {

    final defaultValue = widget?.powerNowList[0] ?? 0.0;
    if(controller == null || animation == null) {
      return RichText(text: TextSpan(text:defaultValue.toStringAsFixed(1),
      style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 34)));
    }
    else {
      return AnimatedBuilder(animation: controller,
          builder: (BuildContext context, Widget child) => RichText(
          text: TextSpan(text:animation.value.toStringAsFixed(1),
          style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 34))),
      );
    }
  }

}