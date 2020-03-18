import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsa_app/debug/bloc/login/login/bloc/login_bloc.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:native_color/native_color.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isShowPassword = true;
  bool checkBoxValue = true;

  
  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
          context:context,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return ThemeGradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children:[

              // 背景
              _background(),

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
                            _userInput(),

                            // 编辑框之间间隔
                            SizedBox(height: 10),

                            // 输入密码编辑框
                            _pswdInput(),

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
                                onPressed:(){
                                  state is! LoginLoading ? _onLoginButtonPressed : null;
                                } 
                                //   () {
                                //   final user = _usernameController.text;
                                //   final pswd = _passwordController.text;
                                //   if (user.length == 0 || pswd.length == 0) {
                                //     var tip = '';
                                //     if (user.length == 0) tip = '请输入用户名';
                                //     if (pswd.length == 0) tip = '请输入密码';
                                //     if (user.length == 0 && pswd.length == 0)
                                //       tip = '请输入用户名和密码';
                                //     showDialog(
                                //         context: context,
                                //         builder: (b) => CupertinoAlertDialog(
                                //           title: Text('提示'),
                                //           content: Text(tip),
                                //           actions: <Widget>[
                                //             CupertinoDialogAction(
                                //               child: Text('好的'),
                                //               isDefaultAction: true,
                                //               onPressed: () {
                                //                 Navigator.of(context).pop();
                                //               },
                                //             ),
                                //           ],
                                //         ));
                                //     return;
                                //   }
                                //   // 登录
                                //   //login(context);
                                // },
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
      )
    );
  }

  //背景
  Widget _background() {
    return Positioned(
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
    );
  }

  // 用户名编辑框
  Widget _userInput(){
    return Container(
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
              controller: _usernameController,
            ),
          ),
          InkWell(
            child: SizedBox(height: 20,width: 20,
              child: Image.asset('images/login/Login_del_btn.png'),
            ),
            onTap: (){
              setState(() {
                _usernameController.text = '';
              });
            },
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  // 输入密码编辑框
  Widget _pswdInput(){
    return Container(
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
              controller: _passwordController,
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
    );
  }
}