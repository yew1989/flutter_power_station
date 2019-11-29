import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:native_color/native_color.dart';

class ModifyPswdPage extends StatefulWidget {
  @override
  _ModifyPswdPageState createState() => _ModifyPswdPageState();
}

class _ModifyPswdPageState extends State<ModifyPswdPage> {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController againController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget pwswdTile(String rightHint, TextEditingController controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(10)
        ),
        height: 54,
        child: TextFormField(
          style: TextStyle(fontSize: 16, color: Colors.white),
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: true,
          controller: controller,
          decoration: InputDecoration(
            icon: SizedBox(width: 0),
            hintStyle: TextStyle(fontSize: 16, color: Colors.white38),
            hintText: '$rightHint',
            border: InputBorder.none,
          ),
        ),
      );
    }

    Widget modifyPasword() {
      return Container(
        height: 54,
        width: double.infinity,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          splashColor: Colors.white,
          color: HexColor('6699ff'),
          child:
              Text('确认提交', style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: () {
            onTapSave();
          },
        ),
      );
    }

    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '修改密码',
            style: TextStyle(fontSize: 17),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              pwswdTile('请输入当前密码', oldController),
              SizedBox(height: 20),
              pwswdTile('请输入新密码', newController),
              SizedBox(height: 20),
              pwswdTile('确认新密码', againController),
              SizedBox(height: 20),
              modifyPasword(),
            ],
          ),
        ),
      ),
    );
  }

  // 保存密码
  void onTapSave() {
    var oldText = oldController.text ?? '';
    var newText = newController.text ?? '';
    var againText = againController.text ?? '';

    if (oldText.length == 0) {
      showToast('请输入当前密码');
      return;
    }
    if (newText.length == 0) {
      showToast('请输入新密码');
      return;
    }

    if (oldText.length < 6 || oldText.length > 20) {
      showToast('请输入6到20位旧密码');
      return;
    }
    if (newText.length < 6 || newText.length > 20) {
      showToast('请输入6到20位新密码');
      return;
    }

    if (againText.length == 0) {
      showToast('请重复输入新密码');
      return;
    }

    if (againText.compareTo(newText) != 0) {
      showToast('新密码和确认密码不同,请确认');
      return;
    }

    if (oldText.compareTo(newText) == 0) {
      showToast('新密码与旧密码不能相同,请修改');
      return;
    }

    httpModifyLoginPswd();
  }

  //  修改登录密码请求
  void httpModifyLoginPswd() async {
    var oldWord = oldController.text;
    var newWord = againController.text;
    var result = await API.modifyPswd(oldWord, newWord);
    if (result.success) {
      // showToast('密码修改成功');
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      return;
    }
  }
}
