
class ShareInstance {

  // 登录成功后 服务器将返回 set-authorization 保存在这里
  String auth = '';
  // 极光推送 ID
  String regId = '';
  
  ShareInstance._();

  static ShareInstance _instance;

  static ShareInstance getInstance() {
    if (_instance == null) {
      _instance = ShareInstance._();
    }
    return _instance;
  }
}