import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/page/search/search_bar.dart';
import 'package:hsa_app/page/update/update_station_list.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';

class UpdatePage extends StatefulWidget {

  final BuildContext parentContext;

  const UpdatePage(this.parentContext,{Key key}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  bool isEditEnable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold( 
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(widget.parentContext);
            },
            child: Image.asset('images/mine/My_back_btn.png',scale: 3,),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('电站列表',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SearchBar(isEditEnable: isEditEnable),
            SizedBox(height: 10,),
            Expanded(child: 
              UpdateStationList(
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