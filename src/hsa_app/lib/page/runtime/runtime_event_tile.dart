import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/runtime_adapter.dart';

class RuntimeEventTile extends StatelessWidget {

  final EventTileData event;

  const RuntimeEventTile({Key key, this.event}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 44,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                     SizedBox(height: 8,width: 8,child: Image.asset('images/runtime/Time_err_list_btn.png')),
                     SizedBox(width: 4),
                     Center(
                        child: Text(event?.leftString ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: AppConfig.getInstance().numberFontName,
                          fontWeight: FontWeight.normal),
                      )),
                    ]
                  ),
                  Center(
                      child: Text(event?.rightString ?? '',
                      style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppConfig.getInstance().numberFontName,
                      color: Colors.white54,
                    ),
                  )),
                ],
              )),
            ),
            Positioned(
              left: 0,right: 0,bottom: 0,
              child: Divider(
                height: 1,
                color: Colors.white38,
              ),
            )
          ],
        ),
      );
  }




  

}