import 'package:flutter/material.dart';
import 'package:hsa_app/model/event_types.dart';
import 'package:hsa_app/page/history/history_pop_dialog_tile.dart';

class HistoryEventDialogWidget extends StatefulWidget {

  final List<EventTypes> eventTypes;

  const HistoryEventDialogWidget({Key key, this.eventTypes}): super(key: key);

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
    List<HistoryPopDialogTile> tiles = [
       HistoryPopDialogTile('图表筛选', false,false),
       HistoryPopDialogTile('水位&功率图', true,true),
       HistoryPopDialogTile('日志筛选', false,false),
       HistoryPopDialogTile('全部', true,true,ercFlag: '全部'),
    ];
    for (var type in widget.eventTypes) {
      tiles.add(HistoryPopDialogTile('ERC${type.eRCFlag}${type.eRCTitle}', 
      true,false,ercFlag:'${type.eRCFlag}'));
    }
     return HistoryEventDialog(tiles);
  }
}

class HistoryEventDialog extends Dialog {

  final List<HistoryPopDialogTile> tiles;

  HistoryEventDialog(this.tiles);

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
                    child: ListView.builder(
                      itemBuilder: (context,index) => tiles[index],
                      itemCount: tiles?.length??0,
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
