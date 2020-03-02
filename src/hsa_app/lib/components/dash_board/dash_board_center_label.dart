import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';

class DashBoardCenterLabel extends StatefulWidget {

  final String powerNowStr;
  final String powerMaxStr;

  const DashBoardCenterLabel(this.powerNowStr, this.powerMaxStr,{Key key}) : super(key: key);
  @override
  _DashBoardCenterLabelState createState() => _DashBoardCenterLabelState();
}

class _DashBoardCenterLabelState extends State<DashBoardCenterLabel> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(widget.powerNowStr ?? '',style: TextStyle(color: Colors.white,fontSize: 34,fontFamily: AppConfig.getInstance().numberFontName)),
          SizedBox(height: 2,width:50,child: Image.asset('images/runtime/Time_line1.png')),
          SizedBox(height: 2),
          Text(widget.powerMaxStr ?? '',style: TextStyle(color: Colors.white38,fontSize: 15,fontFamily: AppConfig.getInstance().numberFontName)),
          ],
      ),
    );
  }
}