import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_config.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:native_color/native_color.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:date_format/date_format.dart';

class StationDeviceListTile extends StatefulWidget {

  final Function onTap;
  final WaterTurbine waterTurbine;
  final int index;

  const StationDeviceListTile(this.waterTurbine, this.index,this.onTap,{Key key}) : super(key: key);

  @override
  _StationDeviceListTileState createState() => _StationDeviceListTileState();
}

class _StationDeviceListTileState extends State<StationDeviceListTile> with TickerProviderStateMixin{

  double barRight = 0.0;
  double barLeft = 0.0;
  bool isBeyond = false;

  bool isShowCyanComet = false;
  bool isShowRedComet = false;

  List<double> list = [0.0,0.0]; 

  AnimationController fanAnimationController;// 风机页片动画
  AnimationController wordController; //文字动态
  Animation<double> animation;

  // 防止内存泄漏 当等于0时才触发动画
  var canPlayAnimationOnZero = 1;

  void showProgressCyanBar() async {

    if(mounted) {
      setState(() {
      
      var maxWidth = MediaQuery.of(context).size.width - 20;
      var ratio = caculatePowerRatio(widget.waterTurbine);
      // 超发
      if(ratio > 1.0) {
        isBeyond = true;
        barRight = maxWidth * 1;
        isShowCyanComet = true;
        isShowRedComet = false;
      }
      // 无功率
      else if(ratio < 0.05){
        isBeyond = false;
        barRight = 0;
        isShowCyanComet = false;
        isShowRedComet = false;
      }
      // 正常发电  
      else {
        isBeyond = false;
        barRight = maxWidth * ratio;
        isShowCyanComet = true;
        isShowRedComet = false;
      }
      });
    }
  }

    void showProgressRedBar() async {

    if(mounted) {
      setState(() {
      var maxWidth = MediaQuery.of(context).size.width - 20;
      var ratio = caculatePowerRatio(widget?.waterTurbine);

      // 超发
      if(ratio > 1.0) {
        isBeyond = true;
        var beyond = ratio - 1.0;
        barLeft  = maxWidth * beyond;
      
        isShowCyanComet = false;
        isShowRedComet = true;

      }
      // 无功率
      else if(ratio < 0.05){
        isBeyond = false;
        barRight = 0;
        isShowCyanComet = false;
        isShowRedComet = false;
      }
      // 正常发电
      else {
        isBeyond = false;
        barLeft  = 0;
        isShowCyanComet = true;
        isShowRedComet = false;
      }  
      });
    }
  }

  void initFanAnimtaionController() {
    fanAnimationController?.dispose();
    fanAnimationController  = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    fanAnimationController.forward();
    fanAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fanAnimationController.reset();
        fanAnimationController.forward();
      }
    });
  }

  void initWordAnimtaionController(){

    list.add(widget?.waterTurbine?.deviceTerminal?.nearestRunningData?.power ?? 0.0);
    if(list.length > 2){
      list.removeAt(0);
    }
    final oldPower = list[0] ?? 0.0;
    final powerNow = list[1] ?? 0.0;

    if(canPlayAnimationOnZero <= 0  && mounted) {
      wordController?.dispose();
      wordController = AnimationController(duration: Duration(seconds:AppConfig.getInstance().stationPageAnimationDuration), vsync: this);
      CurvedAnimation curvedAnimation = CurvedAnimation(parent: wordController, curve: Curves.fastOutSlowIn);
      animation = Tween<double>(begin: oldPower, end: powerNow).animate(curvedAnimation);
      wordController.forward();
      canPlayAnimationOnZero = 0 ;
    }
    canPlayAnimationOnZero--;
  }

  @override
  void initState() {
    super.initState();
    showProgress();
    initFanAnimtaionController();
    initWordAnimtaionController();
    eventBird?.on('REFLASH_DATA', (_){
      showProgressCyanBar();
      showProgressRedBar();
      initWordAnimtaionController();
    });
  }

  void showProgress() async{
    await Future.delayed(Duration(milliseconds:50)); // 这句的目的是为了解决界面未加载就从MediaQuery获取设备宽引起报错
    showProgressCyanBar();
    showProgressRedBar();
  }

  @override
  void dispose() {
    fanAnimationController?.dispose();
    wordController?.dispose();
    eventBird?.off('REFLASH_DATA');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final waterTurbine = widget.waterTurbine;
    final index = widget.index;
    final badgeName = (index + 1).toString();
    final isMaster = waterTurbine?.deviceTerminal?.isMaster ?? false;
    final isOnline =  waterTurbine?.deviceTerminal?.isOnLine ?? false;
    final currentPower =  waterTurbine?.deviceTerminal?.nearestRunningData?.power ?? 0.0; 
    var now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    final hour = now.hour;
    final minute = now.minute;
    final second = now.second;
    final start = formatDate(DateTime(year, month, day,hour, minute, second,),[yyyy, '-', mm, '-', dd,' ',hh,':',nn,':',ss]);
    var startTimeStamp =  waterTurbine?.deviceTerminal?.sessionStartupTime ?? start;
    var closeTimeStamp =  waterTurbine?.deviceTerminal?.sessionStartupTime ?? '0000-00-00 00:00:00';
    var timeStamp = isOnline ? startTimeStamp + '         ' : closeTimeStamp + ' 离线';
    final maxPower = waterTurbine?.ratedPowerKW ?? 0;
    final maxPowerStr = maxPower.toString() + 'kW';
    final eventCount = waterTurbine?.undisposedAlarmEventCount ?? 0;
    final eventStr = buildEventCount(eventCount);
    final isRotate = (isOnline == true) && (currentPower > 1.0); 

    return Container(
      height: 80,
      child: Stack(
        children: <Widget>[
          
            Center(
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
                        fanWidget(isRotate,isOnline),
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
                        fontFamily: AppTheme().numberFontName,fontSize: 20)),
                        SizedBox(height: 4),
                        Text(timeStamp,style: TextStyle(color: Colors.white54,fontFamily: AppTheme().numberFontName,fontSize: 15)),
                      ],
                    ),

                    // 事件告警
                    alarmWidget(eventStr,eventCount),
                    // 当前功率带动画
                    animateNumberWidget(wordController, canPlayAnimationOnZero == 0 ? animation?.value?.toStringAsFixed(0) ?? (currentPower.toStringAsFixed(0) ?? '0') : (currentPower.toStringAsFixed(0) ?? '0'), isOnline),
                  ],
                ),
            ),
          ),

          // 功率 渐进线
          gradientPowerLine(waterTurbine.deviceTerminal,isOnline,index),
          // 功率 Tag
          gradientPowerLineTag(waterTurbine.deviceTerminal,isOnline),

          // 分割线
          Positioned(left: 0,right: 0,bottom: 4,child: Container(height:1,color: Colors.white10)),

           // 点击进入机组详情页
           GestureDetector(
             onTap: (){
               if(widget?.onTap != null) {
                 widget?.onTap();
               }
             },
           )
        ],
      ),
    );
  }

  Widget alarmWidget(String eventStr,int eventCount) {
     return FLBadge(
        position: FLBadgePosition.topRight,
        shape: FLBadgeShape.circle,
        hidden: eventCount == 0,
        textStyle:TextStyle(color: Colors.white,fontSize:10),
        text: eventStr,
        color: Colors.red,
        child: SizedBox(height: 24,width: 24,child: Image.asset('images/home/Home_Aalarm_icon.png')),
      );
  }


  // 功率动画数字
  Widget animateNumberWidget(AnimationController controller,String text,bool isOnline) {

    if(isOnline == false) {
      return SizedBox(width: 54,child: Align(alignment: Alignment.centerRight,
        child: Text(text,style:TextStyle(color:Colors.white60,fontFamily: AppTheme().numberFontName,fontSize: 28))));
    }
    else {
      if(animation == null || controller == null) {
        return SizedBox(width: 54,child: Align(alignment: Alignment.centerRight,
        child: Text(text,style:TextStyle(color:Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 28))));
      } else {
        return SizedBox(width: 54,child: Align(alignment: Alignment.centerRight,
          child: AnimatedBuilder(animation: controller,builder: (BuildContext context, Widget child) => 
          Text(animation?.value?.toStringAsFixed(0) ?? '0.0',style:TextStyle(color: Colors.white,fontFamily: AppTheme().numberFontName,fontSize: 28)))));
      }
    }
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

  Widget gradientPowerLine(DeviceTerminal device,bool isOnline,int index) {

       return  isOnline ? Stack(
         children: <Widget>[

          //蓝色正常部分
          Positioned(bottom: 5,left: 0,height: 2,
          child: AnimatedContainer(
              width: barRight,
              curve: Curves.easeOutSine,
              duration: Duration(seconds: AppConfig.getInstance().stationPageAnimationDuration),
              decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [HexColor('4778f7'), HexColor('66f7f9')])))),
          // 红色超发部分
          Positioned(bottom: 5,right: 0,height:2,
            child: AnimatedContainer(
              width: barLeft,
              curve: Curves.easeOutSine,
              duration: Duration(seconds: AppConfig.getInstance().stationPageAnimationDuration),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor('fff8083a'),HexColor('ff7A0009')])))),
         ],
       ) : Container();

  }

  // 渐变标签
  Widget gradientPowerLineTag(DeviceTerminal device,bool isOnline) {
      isBeyond = false;
      // 渐变条指示器
      return isOnline ? Stack(
          children: <Widget>[
            // 蓝色正常部分
            Positioned(
            left: 0,bottom: -3.5,
            child: AnimatedContainer(
              transform: Matrix4.translationValues(barRight - 20, 0, 0),
              curve: Curves.easeOutSine, 
              duration: Duration(seconds: AppConfig.getInstance().stationPageAnimationDuration),
              child: isShowCyanComet ? SizedBox(width: 35,height: 19, child: Image.asset('images/station/cyan_comet.png')) : Container())),
            // 红色超发部分
            Positioned(
                right: 0,bottom: -3.5,
                child: AnimatedContainer(
                transform: Matrix4.translationValues(-barLeft + 20, 0, 0),
                curve: Curves.easeOutSine,
                duration: Duration(seconds: AppConfig.getInstance().stationPageAnimationDuration),
                child: isShowRedComet ? SizedBox(width: 35,height: 19, child: Image.asset('images/station/red_comet.png')) : Container())),
          ],
      ) : Container();
  }
  
  // 风机控件
  Widget fanWidget(bool isRotation,bool isOnline) {
    return Center(
      child: SizedBox(height: 34,width: 34,
      child: isRotation ? RotationTransition(
        alignment: Alignment.center,
        turns: fanAnimationController,
        child: Image.asset('images/station/GL_unit_on_icon.png')) 
        : isOnline ? Image.asset('images/station/GL_unit_on_icon.png') 
        : Image.asset('images/station/GL_unit_off_icon.png')
      ),
    );
  }

  // 展示 EventCount
  String buildEventCount(int eventCount) {
    if(eventCount == null) return '';
    if(eventCount == 0) return '';
    if(eventCount > 99) return '99';
    return eventCount.toString();
  }

  // 计算 功率比率
  static double caculatePowerRatio(WaterTurbine waterTurbine) {

    var powerMax = waterTurbine?.ratedPowerKW ?? 0.0;
    var powerCurrent = waterTurbine?.deviceTerminal?.nearestRunningData?.power ?? 0.0;
    if( powerMax == 0 ) return 0.0;
    if( powerCurrent == 0 ) return 0.0; 
    var ratio =  powerCurrent / powerMax;
    return ratio;

  }

}