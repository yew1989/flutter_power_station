import 'package:flutter/material.dart';
import 'package:native_color/native_color.dart';

// 统一渐变色背景
class ThemeGradientBackground extends StatefulWidget {
  final Widget child;
  const ThemeGradientBackground({Key key, this.child}) : super(key: key);
  @override
  _ThemeGradientBackgroundState createState() => _ThemeGradientBackgroundState();
}

class _ThemeGradientBackgroundState extends State<ThemeGradientBackground> {
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