import 'package:flutter/material.dart';

class DeviceControlDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('有功调控',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset(
                                          'images/runtime/Time_selected_icon.png')),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('无功调控',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset(
                                          'images/runtime/Time_selected_icon.png')),
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
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  // 设备控制
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text('设备控制',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                            SizedBox(
                                              height: 14,
                                              width: 14,
                                              child: Image.asset(
                                                  'images/runtime/Time_list_icon_down.png'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 127),
                                  // 更多
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(width: 4),
                                            Text('更多',
                                                style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
