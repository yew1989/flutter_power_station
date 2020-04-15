import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hsa_app/api/apis/api_login.dart';
import 'package:hsa_app/api/share_instance.dart';
import 'package:hsa_app/page/framework/root_page.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/util/share.dart';
import 'package:ovprogresshud/progresshud.dart';
import 'package:native_color/native_color.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  TextEditingController usrCtrl = TextEditingController();
  TextEditingController pwdCtrl = TextEditingController();
  bool checkBoxValue = true;
  bool isShowPassword = true;

  @override
  void initState() {
    UMengAnalyticsService.enterPage('登录');
    super.initState();
    autoFillAndAutoLogin(context);
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('登录');
    super.dispose();
  }

  void autoFillAndAutoLogin(BuildContext context) async {
    var name = await ShareManager.instance.loadUserName();
    var pswd = await ShareManager.instance.loadUserPassword();
    var isSave = await ShareManager.instance.loadIsSavePassword();

    setState(() {
        usrCtrl.text = name;
        pwdCtrl.text = pswd;
    });

    if(isSave && pswd.length > 0) {
      login(context);
    }
  }

  void login(BuildContext context) async {

    Progresshud.showWithStatus('正在登录...');

    APILogin.login(context,name:usrCtrl.text, pswd:pwdCtrl.text,onSucc: (s,msg){
      var token = ShareInstance.getInstance().auth;
      if (token.length > 0) {

      debugPrint('✅登录成功:' + token);

      ShareManager.instance.saveToken(token);
      ShareManager.instance.saveUserName(usrCtrl.text);
      if(checkBoxValue == true) {
        ShareManager.instance.savaUserPassword(pwdCtrl.text);
      }
      else {
        ShareManager.instance.savaUserPassword('');
      }
      ShareManager.instance.saveIsSavePassword(checkBoxValue);
      Progresshud.dismiss();
      Progresshud.showSuccessWithStatus('登录成功');
      var route = CupertinoPageRoute(
         builder: (_) => RootPage(),
          );
         Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(route, (route) => route == null);
      return;
    }
    debugPrint('❌登录失败');
    Progresshud.dismiss();
    Progresshud.showInfoWithStatus('登录失败,请检查您的信息');
    },onFail: (msg){
      debugPrint('❌登录失败');
      Progresshud.dismiss();
      Progresshud.showInfoWithStatus('登录失败,请检查网络');
    });

  }

  @override
  Widget build(BuildContext context) {

    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children:[
          // 背景
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * (800.0 / 1224.0),
                  child: AspectRatio(
                    aspectRatio: 504.0/1148.0,
                    child: Center(
                      child: Image.asset('images/login/Login_rock_icon.png')
                    ),
                  ),
                ),
              ), 
          ),

          // 控件群 
          Positioned(
            bottom: 122,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Form(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        
                        // 用户名编辑框
                        Container(
                          height: 54,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                          color: Colors.white54,
                          width: 1,
                          style: BorderStyle.solid),
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
                                  style:TextStyle(color: Colors.white,fontSize: 14),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: "",
                                      hintText: '请输入用户名',
                                      hintStyle: TextStyle(color: Colors.white54,fontSize: 14)),
                                  maxLength: 20,
                                  controller: usrCtrl,
                                ),
                              ),
                              InkWell(
                                child: SizedBox(height: 20,width: 20,
                                  child: Image.asset('images/login/Login_del_btn.png'),
                                ),
                                onTap: (){
                                  setState(() {
                                    usrCtrl.text = '';
                                  });
                                },
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),

                        // 编辑框之间间隔
                        SizedBox(height: 10),

                        // 输入密码编辑框
                        Container(
                          height: 54,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                          color: Colors.white54,
                          width: 1,
                          style: BorderStyle.solid),),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 20),
                              SizedBox(
                                  child: Image.asset('images/login/Login_pw_icon.png'),
                                  height: 24,
                                  width: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  style:TextStyle(color: Colors.white,fontSize: 14),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: "", 
                                      hintText: '请输入密码',
                                      hintStyle: TextStyle(color: Colors.white54,fontSize: 14)),
                                  maxLength: 20,
                                  obscureText: isShowPassword ? true : false,
                                  controller: pwdCtrl,
                                ),
                              ),
                              InkWell(
                                child: SizedBox(height: 20,width: 20,
                                  child: isShowPassword ? Image.asset('images/login/Login_hide_btn.png') 
                                  : Image.asset('images/login/Login_show_btn.png'),
                                ),
                                onTap: (){
                                  setState(() {
                                    isShowPassword = !isShowPassword;
                                  });
                                },
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),

                       // 
                       SizedBox(height: 10),

                       // 自动登录按钮
                       Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 40,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.5,
                                        style: BorderStyle.solid),
                                  ),
                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          checkBoxValue = !checkBoxValue;
                                        });
                                      },
                                      child: checkBoxValue ? Image.asset('images/login/Login_reb_icon.png')
                                      : Container(),
                                    ),
                                ),
                                ),
                                SizedBox(width: 4),
                                Text('自动登录',style: TextStyle(color: Colors.white, fontSize: 13))
                              ],
                            ),
                          ),
                        ),

                        // 
                        SizedBox(height: 20),

                        // 登录按钮
                        SizedBox(
                          height: 54,
                          width: double.infinity,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            splashColor: Colors.white,
                            color: HexColor('6699ff'),
                            child: Text('登录',style: TextStyle(color: Colors.white, fontSize: 16)),
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
                              login(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ]
        ),
      ),
    );
  }
}
