import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/more_data.dart';

class MorePageTile extends StatefulWidget { 

  final MoreItem item;
  final int index;

  const MorePageTile({Key key, this.item, this.index}) : super(key: key);
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
              Text(item.mItem1 ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppConfig.getInstance().numberFontName,
                  fontSize: 16,
                  ),
              ),
              Text(item.mItem2 ?? '',
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: AppConfig.getInstance().numberFontName,
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