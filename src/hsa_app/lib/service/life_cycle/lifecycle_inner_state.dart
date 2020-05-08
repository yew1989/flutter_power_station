import 'package:flutter/material.dart';
import 'route_name_util.dart';
import 'package:event_bus/event_bus.dart';

abstract class LifecycleInnerState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  bool _isResume = false;
  bool _isPause = false;
  int _position;
  String _tag;
  String _className;

  get className => _className;

  int setPosition();

  String setTag();

  @override
  void initState() {

    _className = RouteNameUtil.getRouteNameWithId(context);
    _position = setPosition();
    _tag = setTag();
    onCreate();
    onResume();
    onLoadData();
    eventBus.on<LifecycleInnerEvent>().listen((event) {
      if (event.tag == _tag) {
        if (_position == event.currentPage) {
          if (!_isResume) {
            onResume();
          }
        } else {
          if (!_isPause) {
            onPause();
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    onDestroy();
    super.dispose();
  }

  void onCreate() {}

  void onResume() {
    _isResume = true;
    _isPause = false;
  }

  void onLoadData() {}

  void onPause() {
    _isResume = false;
    _isPause = true;
  }

  void onDestroy() {}

  @override
  bool get wantKeepAlive => keepAlive();

  bool keepAlive() {
    return true;
  }
}

class LifecycleInnerEvent extends Notification {
  final int currentPage;
  final String tag;

  LifecycleInnerEvent(this.currentPage, this.tag);
}

EventBus eventBus = EventBus();

onPageChanged(index, tag) {
  eventBus.fire(LifecycleInnerEvent(index, tag));
}
