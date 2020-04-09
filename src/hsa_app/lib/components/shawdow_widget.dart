import 'package:flutter/material.dart';
import 'package:native_color/native_color.dart';

class WaterPoolWaveShawdow extends StatelessWidget {
  const WaterPoolWaveShawdow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(12, 50, 113, 1),
              offset: Offset(0,-20.0),
              blurRadius: 50.0,
              spreadRadius: 30,
            )
          ],
        ),
      ),
    );
  }
}

class RunTimeLightDarkShawdow extends StatelessWidget {
  const RunTimeLightDarkShawdow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor('4077B3'),
              offset: Offset(0, 10.0),
              blurRadius: 50.0,
              spreadRadius: 30,
            )
          ],
        ),
      ),
    );
  }
}

class TabBarLineShawdow extends StatelessWidget {
  const TabBarLineShawdow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 10.0),
              blurRadius: 10.0,
              spreadRadius: 10,
            )
          ],
        ),
      ),
    );
  }
}