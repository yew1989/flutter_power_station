import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/util/public_tool.dart';

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

    Widget pwswdTile(
        String leftText, String rightHint, TextEditingController controller) {
      return Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          color: Colors.transparent,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, child: Text(leftText)),
              Expanded(
                flex: 4,
                child: Container(
                  height: 40,
                  child: TextFormField(
                    style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    obscureText: true,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '$rightHint',
                      border: InputBorder.none,
                      //  labelStyle: TextStyle(color: Colors.redAccent),
                      //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          child: Divider(),
          height: 1,
        ),
      ]);
    }

    Widget buttonTile() {
      return Container(
        height: 60,
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                onTapSave();
              },
              child: Center(
                  child: Text('修改密码',
                      style: TextStyle(color: Colors.white, fontSize: 18))),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('修改密码'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            pwswdTile('旧密码', '点击输入旧密码', oldController),
            pwswdTile('新密码', '点击输入新密码', newController),
            pwswdTile('确认密码', '点击重复输入新密码', againController),
            SizedBox(height: 60),
            buttonTile(),
          ],
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
      showToast('请输入旧密码');
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
    var result = await API.modifyPswd(oldWord,newWord);
    if(result.success) {
      // showToast('密码修改成功');
      Future.delayed(Duration(seconds:1),(){
         Navigator.of(context).pop();
      });
      return;
    }
    // showToast(result?.msg ?? '密码修改失败');
  }


}
