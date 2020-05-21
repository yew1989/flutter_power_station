import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_update.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:ovprogresshud/progresshud.dart';

class UpdateFileList extends StatefulWidget {

  final DeviceTerminal deviceTerminal;
  final String upgradeFileType;
  //当选择的值改变时调用
  final ValueChanged<UpdateFile> onChoose;

  UpdateFileList({this.deviceTerminal,this.upgradeFileType,this.onChoose});

  @override
  _UpdateFileListState createState() => _UpdateFileListState(onChoose:onChoose);
}

class _UpdateFileListState extends State<UpdateFileList> {

  //当选择的值改变时调用
  final ValueChanged<UpdateFile> onChoose;
  _UpdateFileListState({this.onChoose});
  double width = 375.0;
  List<UpdateFile> updateFileList = List<UpdateFile>();
  
  @override
  void initState() {
    super.initState();
    reqeustUpdateFileList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 请求文件列表
  void reqeustUpdateFileList() { 

    Progresshud.showWithStatus('读取数据中...');
    
    APIUpdate.upgradeFileList(
      upgradeFileType : widget?.upgradeFileType == '全部' ? null : widget?.upgradeFileType ?? null,
      deviceType: widget?.deviceTerminal?.deviceType ?? null,
      deviceVersion: widget?.deviceTerminal?.deviceVersion ?? null,
      onSucc: (List<UpdateFile> updateFileList) {
      
        updateFileList  = updateFileList;

        Progresshud.dismiss();

        if (updateFileList == null) return;
        if(mounted) {
          setState(() {
            this.updateFileList = updateFileList;
          });
        }
      }, onFail: (String msg) {
        Progresshud.showInfoWithStatus('获取升级文件失败');
      });
  }

  @override
  Widget build(BuildContext context) {
    
    width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView.builder(
        itemCount: updateFileList.length ?? 0,
        itemBuilder: (context, index) => updateFileTile(context,index),
      ),
    );
  }


  Widget updateFileTile(BuildContext context, int index) {

    UpdateFile updateFile = updateFileList[index];

    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          Container(
            alignment:Alignment.center,
            child: SizedBox(
                height: 62,
                child: tileTop(updateFile.upgradeFileName,updateFile.uploadDateTime,updateFile.upgradeFileType,updateFile.deviceVersion),
            ),
          ),
          GestureDetector(
            onTap: (){
              onChoose(updateFile);
            },
          ),
          // 底部分割线
          SizedBox(height: 1, child: Container(color: Colors.white24)),
        ],
      ),
    );
  }

  Widget tileTop(String name ,String date,String type,String version) {  

    return SizedBox(
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // 行
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(name ?? '',style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(width: 15),
              Text(type ?? '',style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: width/2-20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(version ?? '',style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text(date ?? '',style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ]
                ),
              ),
              SizedBox(
                width: width/2-20,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset('images/mine/My_next_btn.png'),
                    ),
                  ],
                )
              ),
              
            ],
          ),
        ],
      ),
    );
  }
  

  
  
}
