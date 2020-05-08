import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RouteAware {
  String tag = T.toString();

  T get widget => super.widget;

  bool _isTop = false;

  @override
  void initState() {
    super.initState();
    onCreate();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (_isTop) {
          onResume();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (_isTop) {
          onPause();
        }
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    _isTop = true;
  }

  @override
  void didPushNext() {
    super.didPushNext();
    onPause();
    _isTop = false;
  }

  @override
  void didPop() {
    super.didPop();
    onPause();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    onResume();
    _isTop = true;
  }

  void onCreate() {
  }

  void onResume() {
  }

  void onPause() {
  }
  
  void onDestroy() {
  }

}
