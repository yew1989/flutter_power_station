
class DebugShareInstance {

  // 登录成功后 服务器将返回 set-authorization 保存在这里
  String auth = '';
  // 账号名称
  String accountName = '';
  
  DebugShareInstance._();

  static DebugShareInstance _instance;

  static DebugShareInstance getInstance() {
    if (_instance == null) {
      _instance = DebugShareInstance._();
    }
    return _instance;
  }
}