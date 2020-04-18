import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  void init(){

    list.add(widget?.stationInfo?.totalActivePower ?? 0.0);
    if(list.length > 2){
      list.removeAt(0);
    }

    final oldPower = list[0] ?? 0.0;
    final powerNow = list[1] ?? 0.0;
    
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: oldPower, end: powerNow).animate(curvedAnimation);
    controller.value = 0;
    controller.forward();
  }

  @override
  void dispose() {
    controller?.stop();
    controller?.dispose();
    eventBird?.off('REFLASH_DATA');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds:5000), vsync: this);
    init();
    eventBird?.on('REFLASH_DATA', (dt){
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    
   final max = widget?.stationInfo?.totalEquippedKW ?? 0.0;

   return Center(
      child:AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) => RichText(
          text: TextSpan(
          children: 
            [ 
              TextSpan(text:animation.value.toStringAsFixed(1),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 25)),
              TextSpan(text:'/',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:max.toString(),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 18)),
              TextSpan(text:'kW',style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 16)),
            ]
          ),
        ),
      )
    );
  }
}