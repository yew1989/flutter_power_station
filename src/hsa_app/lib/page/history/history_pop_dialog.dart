import 'package:flutter/material.dart';
import 'package:hsa_app/debug/model/all_model.dart';
import 'package:hsa_app/page/history/history_pop_dialog_tile.dart';

class HistoryEventDialogWidget extends StatefulWidget {

  final List<ERCFlagType> eventTypes;
  final String ercFlag;

  const HistoryEventDialogWidget({Key key, this.eventTypes, this.ercFlag}): super(key: key);

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
    
    final ercFlag = widget?.ercFlag ?? '-1';
    final isTickAll = ercFlag.compareTo('0');

    List<HistoryPopDialogTile> tiles = [
       HistoryPopDialogTile('图表筛选', false,false),
       HistoryPopDialogTile('水位&功率图', true,true),
       HistoryPopDialogTile('日志筛选', false,false),
       HistoryPopDialogTile('全部', true,(isTickAll == 0 ? true : false),ercFlag: '-1'),
    ];
    for (var type in widget.eventTypes) {
      final isTickERCFlag = ercFlag.compareTo('${type.ercFlag}');
      tiles.add(HistoryPopDialogTile('ERC${type.ercFlag}${type.ercTitle}', 
      true,(isTickERCFlag == 0 ? true : false),ercFlag:'${type.ercFlag}'));
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
