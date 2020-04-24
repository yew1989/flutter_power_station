import 'package:flutter/material.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/model/model/more_data.dart';
import 'package:hsa_app/page/more/more_page_tile.dart';
import 'package:hsa_app/service/umeng_analytics.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:ovprogresshud/progresshud.dart';

class MorePage extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  const MorePage({Key key, this.deviceTerminal}) : super(key: key);
  
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
 
  List<MoreItem> moreItems = [];
  DeviceTerminal deviceTerminal;

  @override
  void initState() {
    UMengAnalyticsService.enterPage('机组更多');
    requestMoreData();
    super.initState();
  }

  @override
  void dispose() {
    UMengAnalyticsService.exitPage('机组更多');
    Progresshud.dismiss();
    super.dispose();
  }
  // 请求更多数据
  void requestMoreData() {
    Progresshud.showWithStatus('读取数据中...');
    deviceTerminal = widget?.deviceTerminal;

    if(deviceTerminal == null) {
      Progresshud.showInfoWithStatus('获取更多信息失败');
      return;
    }

    moreData(deviceTerminal);
    // API.moreData(address,(List<MoreItem> items){
    //   Progresshud.dismiss();
    //   setState(() {
    //     this.moreItems = items;
    //   });
    // }, (String msg){
    //   Progresshud.showInfoWithStatus('获取更多信息失败');
    //   debugPrint(msg);
    // });

  }

  void moreData(DeviceTerminal deviceTerminal){
    
    moreItems = MoreData().fromData(deviceTerminal);
    if(moreItems.isEmpty){
      Progresshud.showInfoWithStatus('获取更多信息失败');
    }else{
      Progresshud.dismiss();
      setState(() {});
    }
    
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
            padding: EdgeInsets.only(left:10.0,right: 10.0,bottom: 10.0),
              child: ListView.builder(
                itemCount: moreItems?.length ?? 0,
                itemBuilder: (_,index) {
                  var item = moreItems[index];
                  return MorePageTile(item: item);
                },
              ),
          ),
        ),
      ),
    );
  }

  
}