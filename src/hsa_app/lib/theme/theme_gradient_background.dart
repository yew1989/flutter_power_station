import 'package:flutter/material.dart';
import 'package:native_color/native_color.dart';

// 统一渐变色背景
class ThemeGradientBackgroud extends StatefulWidget {
  final Widget child;
  const ThemeGradientBackgroud({Key key, this.child}) : super(key: key);
  @override
  _ThemeGradientBackgroudState createState() => _ThemeGradientBackgroudState();
}

class _ThemeGradientBackgroudState extends State<ThemeGradientBackgroud> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:[
              HexColor('071C5F'),
              HexColor('4077B3'),
            ]
          ),
        ),
        child: widget.child,
    );
  }
}