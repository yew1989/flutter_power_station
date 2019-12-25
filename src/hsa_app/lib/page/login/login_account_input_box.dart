import 'package:flutter/material.dart';

class LoginAccountInputBox extends StatefulWidget {

  final TextEditingController controller;
  const LoginAccountInputBox({Key key, this.controller}) : super(key: key);

  @override
  _LoginAccountInputBoxState createState() => _LoginAccountInputBoxState();
}

class _LoginAccountInputBoxState extends State<LoginAccountInputBox> {

  @override
  Widget build(BuildContext context) {
    // 用户名编辑框
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Colors.white54, width: 1, style: BorderStyle.solid),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 20),
          SizedBox(
              child: Image.asset('images/login/Login_user_icon.png'),
              height: 24,
              width: 24),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: '请输入用户名',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14)),
              maxLength: 20,
              controller: widget.controller,
            ),
          ),
          InkWell(
            child: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('images/login/Login_del_btn.png'),
            ),
            onTap: () {
              setState(() {
                widget.controller.text = '';
              });
            },
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
