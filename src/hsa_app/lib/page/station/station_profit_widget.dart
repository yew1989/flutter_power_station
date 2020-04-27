import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';

class StationProfitWidget extends StatefulWidget {

  final List<num> profit;

  const StationProfitWidget({Key key, this.profit}) : super(key: key);
  
  @override
  _StationProfitWidgetState createState() => _StationProfitWidgetState();
}

class _StationProfitWidgetState extends State<StationProfitWidget> with TickerProviderStateMixin{
  
  AnimationController controller;
  Animation<double> animation;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 2;

  void initAnimateController() {

    final oldProfit = widget?.profit[0] ?? 0.0;
    final profit    = widget?.profit[1] ?? 0.0;
    
    if(canPlayAnimationOnZero <= 0  && mounted ) {
      controller?.dispose();
      controller = AnimationController(duration: Duration(milliseconds:3000), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: oldProfit, end: profit).animate(curvedAnimation);
      controller.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero --;
  }

  @override
  void dispose() {
    eventBird?.off(AppEvent.onRefreshProfit);
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initAnimateController();
    eventBird?.on(AppEvent.onRefreshProfit, (_){
      initAnimateController();
    });
  }

  Widget richTextMoneyWidget() {

    final current = animation?.value?.toStringAsFixed(2) ?? '0.00';

    if(animation == null || controller == null) {
      return RichText(text:TextSpan(children: 
          [
            TextSpan(text:current,style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 50)),
            TextSpan(text:' 元',style: TextStyle(color: Colors.white,fontSize: 13)),
          ]
        ));
    }
    else {
      return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) => RichText( text: TextSpan(children: 
            [
              TextSpan(text:animation.value.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 50)),
              TextSpan(text:' 元',style: TextStyle(color: Colors.white,fontSize: 13)),
            ]
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: richTextMoneyWidget()
    );
  }
}