import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/page/runtime/runtime_page.dart';
import 'package:native_color/native_color.dart';

class StationDeviceListTile extends StatefulWidget {

  final Devices device;
  final int index;

  const StationDeviceListTile(this.device, this.index,{Key key}) : super(key: key);

  @override
  _StationDeviceListTileState createState() => _StationDeviceListTileState();
}

class _StationDeviceListTileState extends State<StationDeviceListTile> {

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final index = widget.index;
    final badgeName = (index + 1).toString();
    final isMaster = device?.isMaster ?? false;
    final isOnline = device?.status == 'online' ? true : false;
    final currentPower = device?.power?.current ?? 0.0;
    final currentPowerStr = currentPower.toString() + '';
    var timeStamp = device?.updateTime ?? '';
    timeStamp += isOnline ? '         ' : ' 离线';
    final maxPower = device?.power?.max ?? 0;
    final maxPowerStr = maxPower.toString() + 'kW';
    final eventCount = device?.eventCount ?? 0;
    final eventStr = buildEventCount(eventCount);

    return Container(
      height: 76,
      child: Stack(
        children: <Widget>[
          
          // 内容
          GestureDetector(
            onTap: (){
              pushToPage(context, 
              RuntimePage(device?.name ?? '',device.address,badgeName + '#',isOnline));
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    // 堆叠视图
                    SizedBox(height: 50,width: 50,
                      child: Stack(
                        children:[
                        // 水轮机图标
                        fanWidget(isOnline),
                        // 角标
                        Positioned(right: 2,top: 0,
                          child: badgeRight(isMaster,isOnline,badgeName)
                        ),
                        ]
                      ),
                    ),

                    // 文字
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 8),
                        Text(maxPowerStr,style: TextStyle(color: isOnline ? Colors.white : Colors.white60,
                        fontFamily: 'ArialNarrow',fontSize: 20)),
                        SizedBox(height: 4),
                        Text(timeStamp,style: TextStyle(color: Colors.white54,fontFamily: 'ArialNarrow',fontSize: 15)),
                      ],
                    ),

                    // 告警铃
                    eventCount != 0 ? Badge(
                      badgeContent: Center(child: Text(eventStr,style: TextStyle(color: Colors.white,fontSize: 12))),
                      position: BadgePosition.topRight(top: -12,right: -4),
                      badgeColor: Colors.red,toAnimate: false,
                      child:  SizedBox(height: 24,width: 24,child: Image.asset('images/station/GL_Alarm_icon.png')))
                    : SizedBox(height: 24,width: 24),

                    // 当前功率
                    Text(currentPowerStr,style: TextStyle(color: isOnline ? Colors.white : Colors.white60,fontFamily: 'ArialNarrow',fontSize: 28)),
                  ],
                ),
              ),
            ),
          ),

          // 功率 Tag
          gradientPowerLineTag(device,isOnline),
          // 功率 渐进线
          gradientPowerLine(device,isOnline),
          // 分割线
          Positioned(left: 0,right: 0,bottom: 0,child: Container(height:1,color: Colors.white10)),
        ],
      ),
    );
  }

  // 右上角标
  Widget badgeRight(bool isMaster,bool isOnline,String text) {
    return  isMaster ? Container(
        height: 16,width: 16,
        decoration: BoxDecoration(
          color: HexColor('009EE4'),
          border: Border.all(color: HexColor('009EE4'),width: 1.5),
          borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontSize: 12))))
      : Container(
        height: 16,width: 16,
        decoration: BoxDecoration(
          border: Border.all(color: isOnline ? Colors.white : Colors.white60,width: 1.5),
          borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(text,style: TextStyle(color: isOnline ? Colors.white : Colors.white60,fontSize: 12))),
     );
  }

  Widget gradientPowerLine(Devices device,bool isOnline) {

      var maxWidth = MediaQuery.of(context).size.width - 20;
      var ratio = caculatePowerRatio(device);

      bool isBeyond = false;
      double right = 0;
      double left = 0;

      // 超发
      if(ratio > 1.0) {
        isBeyond = true;
        var beyond = ratio - 1.0;
        // 为了好看,超发部分放大 3 倍
        beyond = beyond * 3;
        final rightRatio = 1.0 - beyond;
        right = maxWidth * (1.0 - rightRatio);
        left =  maxWidth - (maxWidth *  beyond);
      }
      // 正常发电
      else {
        isBeyond = false;
        right = maxWidth * (1 - ratio);
      }

       return  isOnline ? Stack(
         children: <Widget>[

           // 蓝色正常部分
           Positioned(
            left: 0,right: right,bottom: 1,height:2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor('4778f7'),HexColor('66f7f9')]
                )))),
          
           // 红色超发部分
           isBeyond == true ? Positioned(
            left: left,right: 0,bottom: 1,height:2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor('fff8083a'),HexColor('00f8083a'),]
                )))) : Container(),
         ],
       ) : Container();

  }

  // 渐变标签
  Widget gradientPowerLineTag(Devices device,bool isOnline) {

      var maxWidth = MediaQuery.of(context).size.width - 20;
      var ratio = caculatePowerRatio(device);
      
      bool isBeyond = false;
      double right = 0;
      double left = 0;

      // 超发
      if(ratio > 1.0) {
        isBeyond = true;
        var beyond = ratio - 1.0;
        // 为了好看,超发部分放大 3 倍
        beyond = beyond * 3;
        final rightRatio = 1.0 - beyond;
        right = maxWidth * (1.0 - rightRatio);
        left =  maxWidth - (maxWidth *  beyond);
      }
      // 正常发电
      else {
        isBeyond = false;
        right = maxWidth * (1 - ratio);
      }

      // 渐变条指示器
      return isOnline ? Stack(
          children: <Widget>[
            // 蓝色正常部分
            isBeyond == false ? Positioned(
            right: right,bottom: 0,
              child: SizedBox(width: 30,height: 18, child: Image.asset('images/station/GL_BLight.png'))) : Container(),
            // 红色超发部分
            isBeyond == true ? Positioned(
                left: left,bottom: 0,
              child: SizedBox(width: 30,height: 18, child: Image.asset('images/station/GL_RLight.png'))) : Container(),
          ],
      ) : Container();
  }
  
  // 风机控件
  Widget fanWidget(bool isMaster) {
    return Center(
      child: SizedBox(height: 34,width: 34,
      child: isMaster ? Image.asset('images/station/GL_unit_on_icon.png') 
        : Image.asset('images/station/GL_unit_off_icon.png')
      ),
    );
  }

  // 展示 EventCount
  String buildEventCount(int eventCount) {
    if(eventCount == null) return '';
    if(eventCount == 0) return '';
    if(eventCount > 99) return '99+';
    return eventCount.toString();
  }

  // 计算 功率比率
  static double caculatePowerRatio(Devices devices) {

    var powerMax = devices?.power?.max ?? 0.0;
    var powerCurrent = devices?.power?.current ?? 0.0;
    if( powerMax == 0 ) return 0.0;
    if( powerCurrent == 0 ) return 0.0; 
    var ratio =  powerCurrent / powerMax;
    return ratio;

  }

}