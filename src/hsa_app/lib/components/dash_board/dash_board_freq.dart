import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/event_bird.dart';

class DashBoardFreq extends StatefulWidget {

  final List<double> freqList;

  const DashBoardFreq(this.freqList,{Key key}) : super(key: key);
  @override
  _DashBoardFreqState createState() => _DashBoardFreqState();
}

class _DashBoardFreqState extends State<DashBoardFreq> with TickerProviderStateMixin{

  AnimationController freqControllerStr;
  Animation<double> animation;

  void init(){
    final freqOld = widget?.freqList[0] ?? 0.0;
    final freqnew = widget?.freqList[1] ?? 0.0;


    freqControllerStr = AnimationController(duration: Duration(milliseconds:5000), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: freqControllerStr, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: freqOld, end: freqnew).animate(curvedAnimation);
    freqControllerStr.forward();
    
  }
  
  @override
  void dispose() {
    freqControllerStr?.stop();
    freqControllerStr?.dispose();
    EventBird().off('NEAREST_DATA_FREQ_STR');
    super.dispose();
  }

  @override
  void initState() {
    init();
    EventBird().on('NEAREST_DATA_FREQ_STR', (dt){
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
            animation: freqControllerStr,
            builder: (BuildContext context, Widget child) => RichText(
              text: TextSpan(
                children: 
                [
                  TextSpan(text:animation.value.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 24)),
                ]
              ),
            ),
          ),
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
}