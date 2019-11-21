import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/terminal.dart';
import 'package:hsa_app/page/terminal/terminal_page.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/util/date_tool.dart';
import 'package:hsa_app/util/public_tool.dart';
import 'package:hsa_app/util/share.dart';

class StationPageOld extends StatefulWidget {

  final String title;
  final String customId;
  final String stationId;
 
  StationPageOld(this.title, this.customId, this.stationId);
  @override
  _StationPageOldState createState() => _StationPageOldState();
}

class _StationPageOldState extends State<StationPageOld> {

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
    requestForTerminals(widget.customId,widget.stationId);
  }

  // 获取用户设备
  void requestForTerminals (String customId,String stationId) async {
    var terminals = await API.getTerminalsWithCustomIdAndStationId(customId, stationId);
    setState(() {
      this.terminals = terminals;
    });
  }


  // 水池
  Widget waterWave() => Container(
    height: 250,
    color: Theme.of(context).primaryColor,
  );

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
    height: 50,
    color: Colors.transparent,
    child: Stack(
      children: <Widget>[
        
        // 机组信息
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Align(
          alignment: Alignment.centerLeft,
          child: Text('机组信息',style: TextStyle(color: Colors.white, fontSize: 18)))),

        // 视频
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(Icons.videocam),iconSize: 30,onPressed: (){},),
                // Text('视频1',style:TextStyle(color:Colors.white,fontSize:16)),
                // SizedBox(width: 20),
                // Text('视频2',style:TextStyle(color:Colors.white,fontSize:16)),
              ],
            ),
          ),
        )

      ],
    ));
  } 
  


  // 机组列表
  Widget terminalList() => Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: terminals?.length ?? 0,
          itemBuilder: (_, idx) => terminalTile(idx),
        ),
      );

  // 分割线
  Widget divWidget() => Container(
      height: 1,
      width: double.infinity,
      color: Theme.of(context).disabledColor,
      margin: EdgeInsets.symmetric(horizontal: 12));

  // 设备Tile列表
  Widget terminalTile(int idx) {

    Terminal terminal = terminals[idx];
    
    var number = idx + 1;
    var isHaveAlert = number == 3;
    var visualPower = terminal.waterTurbineRatedActivePower.toString() + 'kW';
    var dateString = DateTool.dnetDateToDart(terminal.lastSwitchNetTime);
    var isOnline = terminal.isConnected;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
      onTap: () {
        pushToPage(context, TerminalPage('${terminal.waterTurbineAliasName}实时数据',terminal));
      },
      title: Container(
        color: Color.fromRGBO(27, 25, 35, 1),
        height: 80,
        child: Stack(
          children:[ 
            
          // 渐变层
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                  Color.fromRGBO(27, 25, 35, 1), 
                  Color.fromRGBO(18, 80, 128, 1)]),
              ),
              // color: Colors.redAccent,
            ),
          ),
            
            Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 左边距
              SizedBox(width: 10),
              // 风机图标
              Expanded(
                flex: 1,
                child: Center(
                  child: Badge(
                    badgeContent: Text('$number'),
                    badgeColor: isOnline ? Color.fromRGBO(61, 58, 153, 1) : Color(0xFF8F8F8F),
                    child: Icon(Icons.face,size: 50),
                  ),
                ),
              ),

              // 文字区
              Expanded(
                  flex: 4,
                  child: Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(isOnline ? visualPower : '断开连接'),
                      Text(dateString,style: TextStyle(color: Color(0xFF8F8F8F), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 提示栏 
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Badge(
                          showBadge: !isHaveAlert,
                          badgeContent: Text('8'),
                          child: !isHaveAlert ? Icon(
                            Icons.add_alert,
                            size: 50,
                          ) : Text(''),
                        ),
                      ),
                    ],
                  )),
              // 
              Expanded(flex: 1, child: Center(child: Text('--',style: TextStyle(
                fontSize: 16,fontWeight: FontWeight.w600
              )))),
            ],
          )),
          

          
          ]
        ),
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title),
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
            waterWave(),
            terminalListHeader(),
            // divWidget(),
            terminalList(),
          ],
        ),
      ),
    );
  }
}
