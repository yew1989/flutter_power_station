import 'package:flutter/material.dart';

class PowerControlDialog extends Dialog { 
  @override
  Widget build(BuildContext context) {
    return Material(
      //透明类型
      type: MaterialType.transparency,
      //保证控件居中效果
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            height: 152,
            child: Container(
              decoration: ShapeDecoration(
                color: Color.fromRGBO(57, 137, 199, 1),
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
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             Text('有功调控',style: TextStyle(color: Colors.white,fontSize: 16)),
                             SizedBox(height: 22,width: 22,
                             child: Image.asset('images/runtime/Time_selected_icon.png')),
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
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             Text('无功调控',style: TextStyle(color: Colors.white,fontSize: 16)),
                             SizedBox(height: 22,width: 22,
                             child: Image.asset('images/runtime/Time_selected_icon.png')),
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




                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}