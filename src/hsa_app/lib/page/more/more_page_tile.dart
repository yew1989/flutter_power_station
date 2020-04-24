import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/more_data.dart';
import 'package:hsa_app/config/app_theme.dart';

class MorePageTile extends StatefulWidget { 

  final MoreItem item;

  const MorePageTile({Key key, this.item}) : super(key: key);
  @override
  _MorePageTileState createState() => _MorePageTileState();
}

class _MorePageTileState extends State<MorePageTile> {

  @override
  Widget build(BuildContext context) {
    
    var item = widget.item;

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
              Text(item.nameZh ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppTheme().numberFontName,
                  fontSize: 18,
                  ),
              ),
              Text(item.dataStr ?? '',
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: AppTheme().numberFontName,
                  fontSize: 18,
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