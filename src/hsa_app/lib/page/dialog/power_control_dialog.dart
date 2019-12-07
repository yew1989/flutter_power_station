import 'package:flutter/material.dart';
import 'package:hsa_app/components/data_picker.dart';

class PowerControlDialog extends Dialog {

  List<String> buildPowerFactorList() {
    List<String> list = [];
    for (var i = 0; i < 101; i++) {
      var k = i / 100;
      list.add(k.toStringAsFixed(2));
    }
    list = list.reversed.toList();
    return list;
  }

  List<String> buildActivePowerFactorList() {
    List<String> list = [];
    for (var i = 0; i < 801; i++) {
      list.add(i.toStringAsFixed(0));
    }
    list = list.reversed.toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        //透明类型
        type: MaterialType.transparency,
        //保证控件居中效果
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 75,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 152,
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
                          //  有功调控
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 43,
                              child: Stack(
                                children: <Widget>[

                                  Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('有功调控',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    SizedBox(
                                        height: 22,
                                        width: 22,
                                        // child: Image.asset(
                                        //     'images/runtime/Time_selected_icon.png'),
                                        ),
                                  ],
                                ),
                              ),

                              GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                      showDataPicker(context,'请选择有功功率(kW)',buildActivePowerFactorList(),(String data){

                                      });
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),

                          // 分割线
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 12),
                            height: 1,
                            color: Colors.white12,
                          ),

                          // 无功调控
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                height: 43,
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text('功率因数调控',
                                        style: TextStyle(color: Colors.white, fontSize: 16)),
                                        SizedBox(height: 22,width: 22,
                                            // child: Image.asset('images/runtime/Time_selected_icon.png'),
                                            ),
                                       ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).pop();
                                          showDataPicker(context,'请选择功率因数',buildPowerFactorList(),(String data){

                                          });
                                        },
                                      ),

                                    ],
                                  ),
                            ),
                          ),

                          // 分割线
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.white12,
                          ),

                          // 底部扩展区
                          Expanded(
                            child: Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                // 自动
                                Expanded(
                                  flex: 1,
                                  child:Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('自          动',
                                        style: TextStyle(color: Colors.transparent,
                                        fontSize: 15)),
                                        SizedBox(height: 14,width: 14),
                              ],
                            ),
                           ),
                          ),
                          SizedBox(width: 127),
                          // 调功率
                          Expanded(
                            flex: 1,
                            child:GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                SizedBox(height: 22,width: 22,
                                    child: Image.asset('images/runtime/Time_Apower_icon.png'),
                                  ),
                                SizedBox(width: 4),
                                Text('调功',style: TextStyle(color: Colors.white,fontSize: 15)),

                                ],
                              ),
                           ),
                            ),
                          ),
                        ],
                      ),
                              ),
                            ),
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
