import 'package:flutter/material.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text('历史曲线',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18)),
          ),
          body: SafeArea(
            child: Container(
              child: Center(child: Text('历史曲线')),
            ),
          ),
      ),
    );
  }
}