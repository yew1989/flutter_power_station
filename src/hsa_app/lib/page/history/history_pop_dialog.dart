import 'package:flutter/material.dart';

class HistoryEventDialogWidget extends StatefulWidget {

  const HistoryEventDialogWidget({Key key}): super(key: key);

  @override
  _ControlModelDialogWidgetState createState() => _ControlModelDialogWidgetState();
}

class _ControlModelDialogWidgetState extends State<HistoryEventDialogWidget> {
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
    return HistoryEventDialog();
  }
}

class HistoryEventDialog extends Dialog {


  Widget modelTile(BuildContext context, String string, bool enable,bool isSelected) {

    return Container(
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
                  Text(string,
                      style: TextStyle(
                          color: enable ? Colors.white : Colors.white60,
                          fontSize: 16)),
                  SizedBox(
                      height: 22,
                      width: 22,
                      child: isSelected ? Image.asset('images/runtime/Time_selected_icon.png') : null
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                  Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget divider(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIphone5s = MediaQuery.of(context).size.width == 320.0 ? true : false;

    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            GestureDetector(onTap: () => Navigator.of(context).pop()),
            Positioned(
              left: 0,
              right: 0,
              top: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5s ? 9 : 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 396,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color.fromRGBO(53, 117, 191, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          modelTile(context, '图表筛选', false,false),
                          divider(12),
                          modelTile(context, '水位&功率图', true,true),
                          divider(12),
                          modelTile(context, '日志筛选', false,false),
                          divider(12),
                          modelTile(context, '全部', true,true),
                          divider(12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
