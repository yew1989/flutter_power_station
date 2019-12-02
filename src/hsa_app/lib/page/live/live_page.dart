import 'package:flutter/material.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class LivePage extends StatefulWidget {
  final List<String> openLives;
  final String title;
  const LivePage({Key key, this.openLives, this.title}) : super(key: key);
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(widget.title ?? '',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18)),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28)
          ),
        ),
      ),
    );
  }
}