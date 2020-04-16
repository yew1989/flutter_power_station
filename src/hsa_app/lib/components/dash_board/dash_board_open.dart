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

  AnimationController openControllerStr;
  Animation<double> animation;

  void init(){
    var openOld = widget?.openList[0] ?? 0.0;
    openOld = openOld < 0 ?  -openOld: openOld;
    var openNew = widget?.openList[1] ?? 0.0;
    openNew = openNew < 0 ?  -openNew: openNew;

    openControllerStr = AnimationController(duration: Duration(milliseconds:5000), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: openControllerStr, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: openOld, end: openNew).animate(curvedAnimation);
    openControllerStr.forward();
  }

  @override
  void dispose() {
    openControllerStr?.stop();
    openControllerStr?.dispose();
    eventBird?.off('NEAREST_DATA_OPEN_STR');
    super.dispose();
  }

  @override
  void initState() {
    init();
    eventBird?.on('NEAREST_DATA_OPEN_STR', (dt){
      init();   
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: openControllerStr,
            builder: (BuildContext context, Widget child) => RichText(
              text: TextSpan(
                children: 
                [
                  TextSpan(text:(animation.value*100).toStringAsFixed(1),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
                ]
              ),
            ),
          ),
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
}