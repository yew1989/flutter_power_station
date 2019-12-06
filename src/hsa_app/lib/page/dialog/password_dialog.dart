import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PasswordDialog extends Dialog {
  final String text;

  PasswordDialog({Key key, @required this.text}) : super(key: key);

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //创建透明层
    return Material(
      //透明类型
      type: MaterialType.transparency,
      //保证控件居中效果
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            height: 190.0,
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 46,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                              height: 22,
                              width: 22,
                              child: Image.asset(
                                  'images/runtime/Time_close_icon.png')),
                        ),
                        SizedBox(width: 10),
                        Text('请输入执行密码',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xDCDCDCFF)),
                  // 间隔
                  SizedBox(height: 30),
                  // 密码输入框
                  PinCodeTextField(
                    autofocus: true,
                    controller: controller,
                    hideCharacter: true,
                    highlight: true,
                    highlightColor: Colors.black26,
                    defaultBorderColor: Colors.black26,
                    hasTextBorderColor: Colors.black26,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    maskCharacter: "●",
                    onTextChanged: (text) {},
                    onDone: (text) {
                      print("DONE $text");
                      Future.delayed(Duration(milliseconds: 500),(){
                        Navigator.of(context).pop();
                      });
                    },
                    wrapAlignment: WrapAlignment.center,
                    pinBoxDecoration:ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 18.0),
                    pinTextAnimatedSwitcherTransition:ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                    pinBoxHeight: 50,
                    pinBoxWidth: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
