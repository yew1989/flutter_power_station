import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';

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

  @override
  void dispose() {
    controller?.stop();
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final oldPower = widget?.powerNowList[0] ?? 0.0;
    final powerNow = widget?.powerNowList[1] ?? 0.0;


    controller = AnimationController(duration: Duration(milliseconds:5000), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: oldPower, end: powerNow).animate(curvedAnimation);
    controller.forward();


    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) => RichText(
              text: TextSpan(
                children: 
                [
                  TextSpan(text:animation.value.toStringAsFixed(1),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 34)),
                ]
              ),
            ),
          ),
          //Text(widget.powerNowStr ?? '',style: TextStyle(color: Colors.white,fontSize: 34,fontFamily: AppTheme().numberFontName)),
          SizedBox(height: 2,width:50,child: Image.asset('images/runtime/Time_line1.png')),
          SizedBox(height: 2),
          Text(widget.powerMaxStr ?? '',style: TextStyle(color: Colors.white38,fontSize: 15,fontFamily: AppTheme().numberFontName)),
          ],
      ),
    );
  }
}