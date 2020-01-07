import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/page/welcome/welcome_page.dart';
import 'package:syncfusion_flutter_core/core.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    AppConfig.initConfig();
    API.touchNetWork();
    SyncfusionLicense.registerLicense("NT8mJyc2IWhiZH1nfWN9YGpoYmF8YGJ8ampqanNiYmlmamlmanMDHmhia2NnZWNmYGJqYBNiZWB9MDw+");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能电站',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
