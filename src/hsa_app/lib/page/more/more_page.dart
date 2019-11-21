import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtimedata.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';


class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
 
  @override
  void initState() {
    super.initState();
    
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
          title: Text('更多',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 20)),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left:14.0,right: 14.0,bottom: 14.0),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context,index) => moreTile(index),
              ),
          ),
        ),
      ),
    );
  }

  Widget moreTile(int idnex){
    return Container(
      height: 44,
      margin: EdgeInsets.only(left: 16,right: 16),
      child: Stack(
        children:[
          Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('控制选项',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ArialNarrow',
                  fontSize: 16,
                  ),
              ),
              Text('888.8',
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'ArialNarrow',
                  fontSize: 16,
                  ),
              ),
            ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Divider(height: 0.5,color: Colors.white24)
          )

        ]
      ),
    );
  }
}