import 'package:flutter/material.dart';

class StationProfitWidget extends StatefulWidget {

  final num profit;

  const StationProfitWidget({Key key, this.profit}) : super(key: key);
  
  @override
  _StationProfitWidgetState createState() => _StationProfitWidgetState();
}

class _StationProfitWidgetState extends State<StationProfitWidget> {
  
  @override
  Widget build(BuildContext context) {
    
    final profit = widget?.profit ?? 0.0;

    return Center(
      child: RichText(
        text: TextSpan(
          children: 
          [
            TextSpan(text:profit.toString(),style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 50)),
            TextSpan(text:' 元',style: TextStyle(color: Colors.white,fontSize: 13)),
          ]
        ),
      ),
    );
  }
}