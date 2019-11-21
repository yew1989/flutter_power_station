import 'package:flutter/material.dart';
import 'package:native_color/native_color.dart';

// 渐变色背景
class BackgroudGradient extends StatefulWidget {
  final Widget child;
  const BackgroudGradient({Key key, this.child}) : super(key: key);
  @override
  _BackgroudGradientState createState() => _BackgroudGradientState();
}

class _BackgroudGradientState extends State<BackgroudGradient> {
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