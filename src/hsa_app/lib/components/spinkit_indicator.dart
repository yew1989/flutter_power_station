import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinkitIndicator extends StatefulWidget {
  final String title;
  final String subTitle;

  const SpinkitIndicator({Key key, this.title, this.subTitle}) : super(key: key);
  @override
  _SpinkitIndicatorState createState() => _SpinkitIndicatorState();
}

class _SpinkitIndicatorState extends State<SpinkitIndicator> with TickerProviderStateMixin{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                
                SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                ),
                SizedBox(height: 20),
                Text(widget.title ??'',style: TextStyle(color: Colors.white70,fontSize: 16)),
                SizedBox(height: 4),
                Text(widget.subTitle ??'',style: TextStyle(color: Colors.white38,fontSize: 12)),

            ],
          ),
        ),
      ),
    );
  }
}