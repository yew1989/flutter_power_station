// 方形主从机标志.别名
import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';

class RuntimeSqureMasterWidget extends StatelessWidget {

  final bool isMaster;
  final String aliasName;

  const RuntimeSqureMasterWidget({Key key, this.isMaster, this.aliasName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final alias = this.aliasName ?? '';
    final isMaster = this.isMaster ?? false;

    return Container(
      padding: EdgeInsets.only(top: 10,bottom: 10),
      child: Stack(
        children: [

          // 中位文字
          Center(
          child: SizedBox(
          height: 50,
          width: 50,
            child: Stack(
              children: 
              [
                Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Center(
                child:Transform.translate(
                  offset: Offset(0, 6),
                  child: Text(alias,style: TextStyle(color: Colors.white,fontFamily: AppConfig.getInstance().numberFontName,fontSize: 30),
                    ),
                ),
                  ),
                ),
            
            // 角标志
            Positioned(
              left: 0,top: 0,
              child: Center(
                child: SizedBox(
                height: 29,
                width: 29,
                child: isMaster ? Image.asset('images/runtime/Time_host_icon.png') 
                : Image.asset('images/runtime/Time_slave_icon.png')),
              ),
              ),

            // 文字
            Positioned(
              left: 4,top: 0,
              child: Center(
                child: isMaster ? Text('主',style: TextStyle(color: Colors.white,fontSize: 12)) :
                Text('从',style: TextStyle(color: Colors.white,fontSize: 12))),
              ),
              
              ]
            ),
            ),
          ),
        ]
      ),
    );
  }
  
}