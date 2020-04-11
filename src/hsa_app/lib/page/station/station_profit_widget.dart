import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';

class StationProfitWidget extends StatefulWidget {

  final List<num> profit;

  const StationProfitWidget({Key key, this.profit}) : super(key: key);
  
  @override
  _StationProfitWidgetState createState() => _StationProfitWidgetState();
}

class _StationProfitWidgetState extends State<StationProfitWidget> with TickerProviderStateMixin{
  
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
    final oldProfit = widget?.profit[0] ?? 0.0;
    final profit = widget?.profit[1] ?? 0.0;

    controller = AnimationController(duration: Duration(milliseconds:3000), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: oldProfit, end: profit).animate(curvedAnimation);
    controller.forward();

    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) => RichText(
          text: TextSpan(
            children: 
            [
              TextSpan(text:animation.value.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 50)),
              TextSpan(text:' 元',style: TextStyle(color: Colors.white,fontSize: 13)),
            ]
          ),
        ),
      ),
    );
  }
}