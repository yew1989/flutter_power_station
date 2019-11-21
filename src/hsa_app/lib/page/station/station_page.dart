import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/terminal.dart';
import 'package:hsa_app/page/runtime/runtime_page.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';
import 'package:native_color/native_color.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class StationPage extends StatefulWidget {

  final String title;
  final String customId;
  final String stationId;
 
  StationPage(this.title, this.customId, this.stationId);
  @override
  _StationPageState createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {

  List<Terminal> terminals =[];

  Future<String> buildHistoryUrl(List<Terminal> terminals) async {

    var host = AppConfig.getInstance().webHost;
    var pageItemHistory = AppConfig.getInstance().pageBundle.history;
    var urlHistory = host + pageItemHistory.route ?? AppConfig.getInstance().deadLink;
    var auth = await ShareManager.instance.loadToken();
    List<String> temp = [];
    for (var terminal in terminals) {
      temp.add(terminal.terminalAddress);
    }
    var terminalsString = temp.join(',');
    return urlHistory + '?auth=' + auth + '&address=' + terminalsString;
  }

  @override
  void initState() {
    super.initState();
    // requestForTerminals(widget.customId,widget.stationId);
  }

  // 获取用户设备
  void requestForTerminals (String customId,String stationId) async {
    var terminals = await API.getTerminalsWithCustomIdAndStationId(customId, stationId);
    setState(() {
      this.terminals = terminals;
    });
  }


  // 大水池
  Widget waterPool() {
    var width = MediaQuery.of(context).size.width - 46;
    return  Container(
      height: 266,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          
          // 波浪效果
          Center(
            child: WaveWidget(
                    waveFrequency: 3.6,
                    config: CustomConfig(
                      gradients: [
                        [Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)],
                        // [Color.fromRGBO(92,180,224, 1),Color.fromRGBO(92,180,224, 0.3)],
                      ],
                      durations: [10000],
                      heightPercentages: [0.50],
                      gradientBegin: Alignment.topCenter,
                      gradientEnd: Alignment.bottomCenter,
                    ),
                    waveAmplitude: 0,
                    backgroundColor: Colors.transparent,
                    size: Size(width, double.infinity),
              ),
          ),
            
          // 富文本收益值
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text:'425.1',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 50)),
                  TextSpan(text:'元',style: TextStyle(color: Colors.white,fontSize: 13)),
                ]
              ),
            ),
          ),

          // 左侧水库图片
          Positioned(
            left: 0,bottom: 12,
            child: SizedBox(
              height: 186,
              width: 33,
              child: Image.asset('images/station/GL_Water_Line.png')),
          ),

          // 渐变条左边
           Positioned(
            left: 0,bottom: 0,
            child: SizedBox(
              height: 160,
              width: 23,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)],
                    begin:Alignment.topCenter,
                    end:Alignment.bottomCenter

                  ),
                ),
              )),
          ),

          // 渐变条右边
           Positioned(
            right: 0,bottom: 0,
            child: SizedBox(
              height: 130,
              width: 23,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromRGBO(3,169,244, 1),Color.fromRGBO(3,169,244, 0.3)],
                    begin:Alignment.topCenter,
                    end:Alignment.bottomCenter

                  ),
                ),
              )),
          ),

          // 水库文本
          Positioned(
            left: 0,bottom: 200,
            child: Text('水库',style: TextStyle(color: Colors.white,fontSize: 13),
            ),
          ),
          
          // 右侧尾水图片
          Positioned(
            right: 0,bottom: 12,
            child: SizedBox(
              height: 186,
              width: 33,
              child: Image.asset('images/station/GL_Water_Line2.png')),
          ),

          // 尾水文本
          Positioned(
            right: 0,bottom: 200,
            child: Text('尾水',style: TextStyle(color: Colors.white,fontSize: 13),
            ),
          ),
          
          // 当前功率 / 总功率
          Positioned(
            right: 50,bottom: 15,
            child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text:'4325.1',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 25)),
                  TextSpan(text:'/4200',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 18)),
                  TextSpan(text:'kW',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 16)),
                ]
              ),
            ),
          ),
          ),

          // 底部分割线
          Positioned(
            left: 0,right: 0,bottom: 0,
            child: SizedBox(height: 2,child: Container(color: Colors.white54,),),
          ),
        ],
      ),
    );
  }

  // 
  void onTapVideo() {
    var host = AppConfig.getInstance().webHost;
    var pageItem = AppConfig.getInstance().pageBundle.video;
    var url = host + pageItem.route ?? AppConfig.getInstance().deadLink;
    var title = pageItem.title ?? '';
    url = url +
        '?videoUrl=' +
        'http://hls01open.ys7.com/openlive/834678865c9943d78f773e9188eb6146.m3u8';
    pushToPage(context, WebViewPage(title, url));
  }


  // 机组信息
  Widget terminalListHeader() {
    return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    height: 54,
    color: Colors.transparent,
    child: Stack(
      children: <Widget>[
        
        Positioned(
          left: 0,right: 0,bottom: 4,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('机组信息',style: TextStyle(color: Colors.white,fontSize: 15)),
                Text('天气:晴',style: TextStyle(color: Colors.white,fontSize: 15)),
                SizedBox(
                  height: 22,
                  width: 22,
                  child: Image.asset('images/station/GL_Locationbtn.png'),
                ),
                SizedBox(
                  height: 32,
                  width: 32,
                  child: Image.asset('images/station/GL_Video_btn.png'),
                ),
              ],
            ),
          ),
        ),

        // 分割线
        Positioned(
            left: 0,right: 0,bottom: 0,
            child: SizedBox(height: 1,child: Container(color: Colors.white38)),
        ),

      ],
    ));
  } 
  


  // 机组列表
  Widget terminalList() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (_, index) => deviceTile(index),
        ),
    );
  }

  Widget deviceTile(int index){
    var name = (index + 1).toString();

    return Container(
      height: 76,
      child: Stack(
        children: <Widget>[
          
          // 内容
          GestureDetector(
            onTap: (){
              pushToPage(context, RuntimePage('1#实时数据'));
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    // 堆叠视图
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Stack(
                        children:[
                        
                        // 水轮机图标
                        Center(
                          child: SizedBox(height: 34,width: 34,
                            child: Image.asset('images/station/GL_unit_on_icon.png'),
                          ),
                        ),

                        // 右上角标志
                        Positioned(
                          right: 2,top: 0,
                          child: Container(
                            height: 16,width: 16,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white,width: 1.5),
                              borderRadius: BorderRadius.circular(8),),
                            child: Center(
                              child: Text(name,style: TextStyle(color: Colors.white,fontSize: 12)),
                            ),
                          ),
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
                        Text('450kW',
                        style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 20)),
                        SizedBox(height: 4),
                        Text('2019.09.03 11:26',
                        style: TextStyle(color: Colors.white54,fontFamily: 'ArialNarrow',fontSize: 15)),
                      ],
                    ),

                    // 告警铃
                    Badge(
                      badgeContent: Text('8',style: TextStyle(color: Colors.white)),
                      position: BadgePosition.topRight(top: -12,right: -4),
                      badgeColor: Colors.red,
                      toAnimate: false,
                      child: 
                    SizedBox(height: 24,width: 24,child: Image.asset('images/station/GL_Alarm_icon.png'))),

                    // 当前功率
                    Text('423',style: TextStyle(color: Colors.white,fontFamily: 'ArialNarrow',fontSize: 28)),
                  ],
                ),
              ),
            ),
          ),

          // 渐变条指示器
          Positioned(
          right: 80,bottom: 0,
            child: SizedBox(
              width: 30,
              height: 18,
              child: Image.asset('images/station/GL_BLight.png'),
            ),
          ),

          // 渐变条
          Positioned(
          left: 0,right: 80,bottom: 1,child: 
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: 
                [
                  HexColor('4778f7'),
                  HexColor('66f7f9'),
                ]
              )
            ),
            height:2,
          )),

          // 分割线
          Positioned(left: 0,right: 0,bottom: 0,child: Container(height:1,color: Colors.white10)),
        ],
      ),
    );
  }

  void onTapPushToHistory() async{
    var url = await buildHistoryUrl(terminals);
    debugPrint(url);
    pushToPage(context, WebViewPage('历史', url,noNavBar: true,));
  }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Stack(
        children:[
          
          // 天气背景 TODO 外层包裹
          Image.asset('images/station/GL_sun_icon.png'),
          Image.asset('images/station/GL_rain_icon.png'),
          Image.asset('images/station/GL_cloudy_icon.png'),

          Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            // title: Text(widget.title),
            title: Text('登云水电站',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 16)),
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  onTapPushToHistory();
                },
                // 此处跳转到历史曲线
                child: Center(child: Text('历史曲线',style:TextStyle(color: Colors.white,fontSize: 16)))),
              SizedBox(width: 20),
            ],
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                waterPool(),
                terminalListHeader(),
                terminalList(),
              ],
            ),
          ),
        ),
        
        ]
      ),
    );
  }
}
