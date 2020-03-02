import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';

class HistoryPopDialogTile extends StatefulWidget {
  final String string;
  final bool enable;
  final bool isSelected;
  final String ercFlag;

  const HistoryPopDialogTile(this.string, this.enable, this.isSelected,
      {Key key, this.ercFlag})
      : super(key: key);

  @override
  _HistoryPopDialogState createState() => _HistoryPopDialogState();
}

class _HistoryPopDialogState extends State<HistoryPopDialogTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 12, left: 12),
              child: SizedBox(
                height: 43,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(widget?.string ?? '',
                              style: TextStyle(
                                  color: widget?.enable ?? false
                                      ? Colors.white
                                      : Colors.white60,
                                  fontSize: 16,
                                  fontFamily: AppConfig.getInstance().numberFontName)),
                          SizedBox(
                              height: 22,
                              width: 22,
                              child: widget?.isSelected ?? false
                                  ? Image.asset(
                                      'images/runtime/Time_selected_icon.png')
                                  : null),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        final erc = widget?.ercFlag ?? '';
                        EventBird().emit(AppEvent.eventFilterChoose, erc);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          divider(12),
        ]);
  }

  Widget divider(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }
}
