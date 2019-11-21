import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareManager {
 
  // 登录令牌
  String token = '';
  // 记住密码
  bool isSavePassword = true;
  // 用户密码
  String userPassword = '';
  // 用户账号名称
  String userName = '';

  factory ShareManager() =>_getInstance();
  static ShareManager get instance => _getInstance();
  static ShareManager _getInstance() {
    if (_instance == null) {
      _instance =  ShareManager._internal();
    }
    return _instance;
  }

  static ShareManager _instance;

    ShareManager._internal() {
    // token = '';
    // isSavePassword = true;
    // userPassword = '';
    // userName = '';
  }

  static initConfig() async {
    var token = await ShareManager().loadToken();
    ShareManager._getInstance().token = token;
  }

  void clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  // 读写 Token
  void saveToken(String token) async {
   ShareManager.instance.token = token;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString('Token',token);
  }

  Future<String> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Token') ?? '';
    ShareManager.instance.token = token;
    return token;
  }

  // 读写用户名称
  void saveUserName(String userName) async {
   ShareManager.instance.userName = userName;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString('UserName',userName);

   var fff = prefs.getString('UserName') ?? '';
    debugPrint(fff);
  }

  Future<String> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('UserName') ?? '';
    ShareManager.instance.userName = userName;
    return userName;
  }

  // 读写用户密码
  void savaUserPassword(String userPassword) async {
   ShareManager.instance.userPassword = userPassword;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString('UserPassword',userPassword);
  }

  Future<String> loadUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var password = prefs.getString('UserPassword') ?? '';
    ShareManager.instance.userPassword = userPassword;
    return password;
  }




}