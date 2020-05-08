import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/page/home/home_station_list.dart';
import 'package:hsa_app/page/search/search_bar.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool isEditEnable = false;

  @override
  void initState() {
    UMengAnalyticsService.enterPage('搜索电站');
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('搜索电站');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold( 
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('搜索电站',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SearchBar(isEditEnable: isEditEnable),
            Expanded(child: 
              HomeStationList(
                homeParam:'全部电站',
                isFromSearch: true,
                onFirstLoadFinish: (){
                  setState(() {
                      this.isEditEnable = true;
                  });
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}