import 'package:flutter/material.dart';

class AppTheme {

  String numberFontName = 'DINCondensedC';
  double navigationAppBarFontSize = 18;

  AppBar buildAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(title ?? '',
      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: AppTheme().navigationAppBarFontSize)));
  }
}
