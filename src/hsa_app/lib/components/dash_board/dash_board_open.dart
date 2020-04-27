import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';

class DashBoardOpen extends StatefulWidget {

  final List<double> openList;

  const DashBoardOpen(this.openList,{Key key}) : super(key: key);
  @override
  _DashBoardOpenState createState() => _DashBoardOpenState();
}

class _DashBoardOpenState extends State<DashBoardOpen> with TickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 2;

  void init(){
    var openOld = widget?.openList[0] ?? 0.0;
    openOld = openOld < 0 ?  -openOld: openOld;
    var openNew = widget?.openList[1] ?? 0.0;
    openNew = openNew < 0 ?  -openNew: openNew;

    if(canPlayAnimationOnZero <= 0 && mounted) {
      controller?.dispose();
      controller = AnimationController(duration: Duration(milliseconds:3000), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: openOld, end: openNew).animate(curvedAnimation);
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
          SizedBox(
              height: 2,
              width: 52,
              child: Image.asset(
                  'images/runtime/Time_line1.png')),
          Text('开度:%',
              style: TextStyle(
                  color: Colors.white30, fontSize: 11)),
          ],
      ),
    );
  }

  // 数字动画
  Widget animateNumberWidget() {

    var openOld = widget?.openList[0] ?? 0.0;
    openOld = openOld < 0 ?  -openOld: openOld;
    final defaultValue = openOld ?? 0.0;

      if(controller == null || animation == null) {
      return RichText(text: TextSpan(
        children: 
          [
            TextSpan(text:defaultValue.toStringAsFixed(1),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
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
              TextSpan(text:(animation.value*100).toStringAsFixed(1),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
            ]
          ),
        ),
      );
    }
  }

}