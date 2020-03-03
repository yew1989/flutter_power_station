import 'package:flutter/material.dart';

class AppTheme {

  String numberFontName = 'DINCondensedC';
  double navigationAppBarFontSize = 20;

  AppBar buildAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(title ?? '',
      style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)));
  }
}
