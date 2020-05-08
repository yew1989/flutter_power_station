import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HistoryCalendarBar extends StatefulWidget {

  final bool isLoading;
  final String startDateTime;
  final String endDateTime;
  final Function() onChoose;
  
  const HistoryCalendarBar({Key key, this.isLoading, this.startDateTime, this.endDateTime, this.onChoose}) : super(key: key);
  @override
  _HistoryCalendarBarState createState() => _HistoryCalendarBarState();
}

class _HistoryCalendarBarState extends State<HistoryCalendarBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      height: 36,
      child: Stack(children: [
        Positioned(
          left: 32,
          top: 8,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 20,
              width: 20,
              child: widget.isLoading == false ? Container() :
              LoadingIndicator(
                indicatorType: Indicator.ballPulse, 
                color: Colors.white70,
              )
            ),
          ),
        ),
        Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                  height: 22,
                  width: 22,
                  child:
                      Image.asset('images/history/History_calendar_btn.png'))),
        ),
        Positioned(
          right: 32,
          top: 8,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${widget.startDateTime} ～ ${widget.endDateTime}',
              style: TextStyle(
                  color: Colors.white, fontFamily: AppTheme().numberFontName, fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => widget.onChoose(),
        ),
      ]),
    );
  }
}