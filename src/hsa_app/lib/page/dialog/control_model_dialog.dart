import 'package:flutter/material.dart';

class ControlModelDialog extends Dialog {
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
              bottom: 75,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 280,
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
                          // 手动
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('手动',
                                      style: TextStyle(
                                          color: Colors.white60, fontSize: 16)),
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

                          // 自动
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('自动',
                                      style: TextStyle(
                                          color: Colors.white60, fontSize: 16)),
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

                          // 智能
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: '智能',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 16)),
                                      TextSpan(
                                          text: ' (下位机智能控制屏旋钮处于智能模式时,方可开启)',
                                          style: TextStyle(
                                              color: Colors.white60, fontSize: 12)),
                                    ]),
                                  ),
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



                          // // 分割线
                          // Container(
                          //   width: double.infinity,
                          //   height: 1,
                          //   color: Colors.white12,
                          // ),

                          // 远程控制
                          Container(
                            margin: EdgeInsets.only(right: 12,left: 40),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('远程控制',
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
                            margin: EdgeInsets.only(left: 40),
                            height: 1,
                            color: Colors.white12,
                          ),

                          // 智能水位控制
                          Container(
                            margin: EdgeInsets.only(right: 12,left: 40),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('智能水位控制',
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

                          // 分割线顶格
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // 自动
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
                                              Text('自          动',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                              SizedBox(
                                                height: 14,
                                                width: 14,
                                                child: Image.asset(
                                                    'images/runtime/Time_list_icon_down.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 127),
                                    // 调功率
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(height: 22, width: 22),
                                            SizedBox(width: 4),
                                            Text('调功',
                                                style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 15)),
                                          ],
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
