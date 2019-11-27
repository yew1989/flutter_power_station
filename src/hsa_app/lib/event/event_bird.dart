//订阅者回调签名
typedef void EventCallback(arg);

class EventBird {
  //私有构造函数
  EventBird._internal();

  //保存单例
  static EventBird _singleton = EventBird._internal();

  //工厂构造函数
  factory EventBird()=> _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者
  var _emap = Map<String, EventCallback>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName]=f;
  }

  //移除订阅者
  void off(eventName) {
    _emap[eventName] = null;
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var f = _emap[eventName];
    f(arg);
  }
}