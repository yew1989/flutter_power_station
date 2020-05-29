import 'package:flutter/material.dart';
import 'package:hsa_app/app/boot.dart';
import 'package:hsa_app/page/welcome/welcome_page.dart';
import 'package:hsa_app/service/life_cycle/lifecycle_state.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    BootApp.boot();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能电站',
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: WelcomePage(),
    );
  }
}
