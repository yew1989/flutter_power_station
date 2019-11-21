import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/page/framework/root_page.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';

class LoginPageOld extends StatefulWidget {
  @override
  LoginPageStateOld createState() => LoginPageStateOld();
}

class LoginPageStateOld extends State<LoginPageOld> {

  BuildContext _context;
  TextEditingController usrCtrl = TextEditingController();
  TextEditingController pwdCtrl = TextEditingController();
  bool checkBoxValue = true;

  void login() async {
    var token = await API.getLoginToken(usrCtrl.text, pwdCtrl.text);
    if (token.length > 0) {
      debugPrint('🔑:登录成功:' + token);
      ShareManager.instance.saveToken(token);
      showToast('登录成功');
      var route = CupertinoPageRoute(
         builder: (_) => RootPage(),
          );
         Navigator.of(_context,rootNavigator: true).pushAndRemoveUntil(route, (route) => route == null);
      return;
    }
    debugPrint('❌:登录失败');
    showToast('登录失败');
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){

      //   },
      // ),
      // backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
       
                SizedBox(height: 20),
                Container(
                  // color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10),
                      SizedBox(
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          height: 10,
                          width: 10),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              counterText: "",
                              hintText: '请输入用户名',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          maxLength: 20,
                          controller: usrCtrl,
                        ),
                      ),
                      // SizedBox(width: 10),
                      // SizedBox(
                      //     child: Image.asset('assets/img/tickgrey.png'),
                      //     height: 12,
                      //     width: 12),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  // color: Color.fromRGBO(35, 35, 35, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10),
                      SizedBox(
                          child: Icon(
                            Icons.vpn_key,
                            color: Theme.of(context).primaryColor,
                          ),
                          height: 10,
                          width: 10),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              hintText: '请输入密码',
                              counterText: "",
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          maxLength: 20,
                          obscureText: true,
                          controller: pwdCtrl,
                        ),
                      ),
                      // SizedBox(width: 10),
                      // SizedBox(
                      //     child: Image.asset('assets/img/tickgrey.png'),
                      //     height: 12,
                      //     width: 12),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),

                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: RaisedButton(
                    splashColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text('登录',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {
                      final user = usrCtrl.text;
                      final pswd = pwdCtrl.text;
                      if (user.length == 0 || pswd.length == 0) {
                        var tip = '';
                        if (user.length == 0) tip = '请输入用户名';
                        if (pswd.length == 0) tip = '请输入密码';
                        if (user.length == 0 && pswd.length == 0)
                          tip = '请输入用户名和密码';
                        showDialog(
                            context: context,
                            builder: (b) => CupertinoAlertDialog(
                                  title: Text('提示'),
                                  content: Text(tip),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('好的'),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                        return;
                      }
                      // 登录
                      login();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
