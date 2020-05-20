import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_update.dart';
import 'package:hsa_app/components/shawdow_widget.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/page/update/update_file_list.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:hsa_app/components/public_tool.dart';

class UpdateChooseFilePage extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  //当选择的值改变时调用
  final ValueChanged<UpdateFile> onChoose;

  UpdateChooseFilePage({this.deviceTerminal,this.onChoose});

  @override
  _UpdateChooseFileState createState() => _UpdateChooseFileState(onChoose:onChoose);
}

class _UpdateChooseFileState extends State<UpdateChooseFilePage>{

  _UpdateChooseFileState({this.onChoose});

  //当选择的值改变时调用
  final ValueChanged<UpdateFile> onChoose;

  // 类型列表
  List<String> types = [];

  // UI分节列表
  List<String> sections = ['全部'];

  DeviceTerminal deviceTerminal = DeviceTerminal();


  //省份列表(新)
  void requestProvinces(){
    APIUpdate.upgradeFileType(
      onSucc: (list){
        setState(() {
          this.types = list.map((v) => v).toList();
          this.sections.addAll(types.map((name) => name).toList());
        });

      },onFail: (msg){
        showToast(msg);
        progressShowError('升级文件类型获取失败');
      });
  }

  @override
  void initState() {
    super.initState();
    requestProvinces();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 标签页 Header
  Widget tabBarHeader() {
    return Center(
      child: TabBar(
        indicator: const BoxDecoration(),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white, 
        labelStyle: TextStyle(color: Colors.white, fontSize: 15.5), 
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle:TextStyle(color: Colors.grey, fontSize: 15), 
        indicatorColor: Colors.transparent,
        isScrollable: true,
        tabs: this.sections.map((name) => SizedBox(height: 40, child: Center(child: Text(name)))).toList(),
      ),
    );
  }

  // 标签页 Body
  Widget tabBarBody() {
    return Expanded(
        child: TabBarView(
          physics: BouncingScrollPhysics(),
          children: this.sections.map((name){
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: UpdateFileList(
                upgradeFileType : name,
                deviceTerminal : deviceTerminal,
                onChoose:(UpdateFile updateFile){
                  onChoose(updateFile);
                  Navigator.pop(context);
                }
              ),
            );
          }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceTerminal = widget?.deviceTerminal ?? DeviceTerminal();
    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('选择文件',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 1, child: Container(color: Colors.white24)),
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: this.sections?.length ?? 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    tabBarHeader(),
                    tabBarBody(),
                    TabBarLineShawdow(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
