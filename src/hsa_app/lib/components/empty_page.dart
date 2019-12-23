import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  final String title;
  final String subTitle;

  const EmptyPage({Key key, this.title, this.subTitle}) : super(key: key);
  @override
  _EmptyPageState createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  
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
                
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Icon(CupertinoIcons.folder,size: 50,color: Colors.white38),
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