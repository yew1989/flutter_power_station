import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/API/debug_api_login.dart';
import 'package:meta/meta.dart';

class UserRepository {

  

  Future<String> authenticate({
    @required String username,
    @required String password,
    @required BuildContext context,
  }) async {
    DebugAPILogin.login(context,name:username,pswd:password,onSucc: (auth,msg){
      showToast(msg + auth.toString());
    },onFail:(msg){
      showToast(msg);
    });
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}