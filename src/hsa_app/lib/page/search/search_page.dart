import 'package:flutter/material.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/home/home_station_list.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Widget seachingBar() {

     return SizedBox(height: 70,width: double.infinity,
     child: Container(
       margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
       decoration: BoxDecoration(
         border: Border.all(color: Colors.white38),
         borderRadius: BorderRadius.all(Radius.circular(35)),
       ),
       child: TextFormField(
         maxLength: 20,
         autofocus: false,
         cursorColor: Colors.white,
         style: TextStyle(color: Colors.white,fontSize: 16),
         decoration: InputDecoration(
           icon: SizedBox(width: 12),
           counterText: "",
           border:InputBorder.none,
           hintText: '请输入电站中文名或拼音首字母',
           labelStyle: TextStyle(color: Colors.white,fontSize: 16),
           hintStyle: TextStyle(color: Colors.white30,fontSize: 16),
         ),
         onChanged:(String text){
          EventBird().emit(AppEvent.searchKeyWord,text);
         },
       ),
     )
    );
  }

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
          title: Text('搜索电站',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 20)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            seachingBar(),
            Expanded(child: HomeStationList(homeParam:'全部电站',isFromSearch: true)),
          ],
        ),
      ),
    );
  }
}