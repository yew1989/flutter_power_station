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

  //开启设备控制
  bool equipmentControl = false;
  //开启输入框调功
  bool editBox = false;

  factory ShareManager() =>_getInstance();
  static ShareManager get instance => _getInstance();
  static ShareManager _getInstance() {
    if (_instance == null) {
      _instance =  ShareManager._internal();
    }
    return _instance;
  }

  static ShareManager _instance;

  ShareManager._internal();
  
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

  // 记住密码状态保存
  void saveIsSavePassword(bool isSavePassword) async{
   ShareManager.instance.isSavePassword = isSavePassword;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setBool('IsSavePassword',isSavePassword);
  }

  // 记住密码状态读取
  Future<bool> loadIsSavePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isSavePassword = prefs.getBool('IsSavePassword') ?? false;
    ShareManager.instance.isSavePassword = isSavePassword;
    return isSavePassword;
  }



  // 记住设备控制状态保存
  void saveIsSaveEquipmentControl(bool equipmentControl) async{
   ShareManager.instance.equipmentControl = equipmentControl;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setBool('equipmentControl',equipmentControl);
  }

  // 记住设备控制状态读取
  Future<bool> loadIsSaveEquipmentControl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var equipmentControl = prefs.getBool('equipmentControl') ?? false;
    ShareManager.instance.equipmentControl = equipmentControl;
    return equipmentControl;
  }

  // 记住开启输入框调功保存
  void saveIsSaveEditBox(bool editBox) async{
   ShareManager.instance.editBox = editBox;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setBool('editBox',editBox);
  }

  // 记住开启输入框调功读取
  Future<bool> loadIsSaveEditBox() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var editBox = prefs.getBool('editBox') ?? false;
    ShareManager.instance.editBox = editBox;
    return editBox;
  }

}