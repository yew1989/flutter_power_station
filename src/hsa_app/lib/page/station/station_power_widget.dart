import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/model/model/station.dart';

class StationPowerWidget extends StatefulWidget {
  
  final StationInfo stationInfo;

  const StationPowerWidget(this.stationInfo,{Key key}) : super(key: key);
  @override
  _StationPowerWidgetState createState() => _StationPowerWidgetState();
}

class _StationPowerWidgetState extends State<StationPowerWidget> with TickerProviderStateMixin {

  List<double> list = [0.0,0.0];

  AnimationController controller;
  Animation<double> animation;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 1;

  void initPowerWordController(){

    list.add(widget?.stationInfo?.totalActivePower ?? 0.0);
    if(list.length > 2){
      list.removeAt(0);
    }

    final oldPower = list[0] ?? 0.0;
    final powerNow = list[1] ?? 0.0;
    
    if(canPlayAnimationOnZero <= 0  && mounted) {
      controller?.dispose();
      controller = AnimationController(duration: Duration(milliseconds:3000), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: oldPower, end: powerNow).animate(curvedAnimation);
      controller.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero --;

  }

  @override
  void dispose() {
    controller?.dispose();
    eventBird?.off('REFLASH_DATA');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPowerWordController();
    eventBird?.on('REFLASH_DATA', (_){
      initPowerWordController();
    });
  }

  @override
  Widget build(BuildContext context) {
   return Center(
      child:richTextWrapWidget(),
    );
  }


  Widget richTextWrapWidget() {

    final max = widget?.stationInfo?.totalEquippedKW ?? 0.0;
    final current = animation?.value?.toStringAsFixed(1) ?? '0';

    if(animation == null || controller == null) {
      return RichText(
          text: TextSpan(
          children: 
            [ 
              TextSpan(text:'0.0',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 25)),
              TextSpan(text:'/',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:max.toString(),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:'kW',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 16)),
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
              TextSpan(text:current,style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 25)),
              TextSpan(text:'/',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:max.toString(),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:'kW',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 16)),
            ]
          ),
        ),
      );
    }
  }
}