import 'package:flutter/material.dart';
import 'package:hsa_app/util/number_picker.dart';

class CustomDialog  extends Dialog {

  final String title;
  final int current;
  final int max;
  final int decimal;
  final ValueChanged<num> onChanged;

  CustomDialog({
    this.title,
    this.current,
    this.max,
    this.decimal,
    this.onChanged
  });

  // 分割线
  Widget divLine(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }

  @override
  Widget build(BuildContext context) {
    num _change;
    final isIphone5S = MediaQuery.of(context).size.width == 320.0 ? true : false;
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            GestureDetector(onTap: () => Navigator.of(context).pop()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5S ? 5 : 5),
                child: SizedBox(
                  width: double.infinity,
                  height: 250,
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
                          Padding(padding: EdgeInsets.all(6.0),),
                          Text(title ?? '',style: TextStyle(color: Colors.white, fontSize: 18)),
                          Padding(padding: EdgeInsets.all(6.0),),
                          divLine(0),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 90),
                              Expanded(
                                child: Container(
                                  child: NumberPickerRow.integer(
                                    max: max, 
                                    current: current,
                                    decimal: decimal,
                                    defaultStyle: TextStyle(color: Colors.white24,fontSize: 16),
                                    selectedStyle: TextStyle(color: Colors.white,fontSize: 25), 
                                    onChanged: (num value) {
                                      _change = value;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 90),
                            ],
                          ),
                          divLine(0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child:Text('确定',style: TextStyle(color: Colors.white, fontSize: 16)), 
                                onPressed: () {
                                  onChanged(_change);
                                },
                              )
                            ]
                          )
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