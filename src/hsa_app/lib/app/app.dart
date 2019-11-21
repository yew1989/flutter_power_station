import 'package:flutter/material.dart';
import 'package:hsa_app/page/welcome/welcome_page.dart';
import 'package:hsa_app/theme/theme_dark.dart';

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'智能电站',
      debugShowCheckedModeBanner: false,
      // showSemanticsDebugger: false,
      // showPerformanceOverlay: true,
      // theme: ThemeData(
      // //   // brightness: Brightness.dark,
      //   // primarySwatch: Colors.red,
      // ),
      // theme: appThemeDark,
      home: WelcomePage(),
    );
  }
}