import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

typedef PasswordDialogOnSuccCallback = void Function(String pswd);

class PasswordDialog extends Dialog {

  final PasswordDialogOnSuccCallback onSucc;

  PasswordDialog(this.onSucc);

  @override
  Widget build(BuildContext context) {

    final boxSize = MediaQuery.of(context).size.width / 8;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children:[
        GestureDetector(onTap: () => Navigator.of(context).pop()),
        Center(
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
                    // 头部
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 46,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('请输入操作密码',style:TextStyle(color: Colors.black, fontSize: 16)),

                           GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: Image.asset('images/runtime/Time_close_icon.png')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Color(0xDCDCDCFF)),
                    // 间隔
                    SizedBox(height: 30),
                    // 密码输入框
                    PinCodeTextField(
                      autofocus: true,
                      hideCharacter: true,
                      highlight: true,
                      highlightColor: Colors.black26,
                      defaultBorderColor: Colors.black26,
                      hasTextBorderColor: Colors.black26,
                      maxLength: 6,
                      keyboardType: TextInputType.text,
                      maskCharacter: "●",
                      onTextChanged: (text) {},
                      onDone: (text) {
                        Future.delayed(Duration(milliseconds: 500),(){
                          Navigator.of(context).pop();
                          onSucc(text);
                        });
                      },
                      wrapAlignment: WrapAlignment.center,
                      pinBoxDecoration:ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      pinTextStyle: TextStyle(fontSize: 18.0),
                      pinTextAnimatedSwitcherTransition:ProvidedPinBoxTextAnimation.scalingTransition,
                      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                      pinBoxHeight: boxSize,
                      pinBoxWidth: boxSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ]
      ),
    );
  }
}
