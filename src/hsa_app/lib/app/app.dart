import 'package:flutter/material.dart';
import 'package:hsa_app/page/welcome/welcome_page.dart';

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'智能电站',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}