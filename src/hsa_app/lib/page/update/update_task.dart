// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/apis/api_update.dart';
import 'package:hsa_app/components/smart_refresher_style.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/model/model/all_model.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UpdateTaskPage extends StatefulWidget {
  final BuildContext parentContext;
  const UpdateTaskPage(this.parentContext,{Key key}) : super(key: key);

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  int currentSegment = 0;
  List<UpdateTask> taskProcessingList = [];
  List<UpdateTask> taskCompletedList = [];
  RefreshController taskProcessingRefreshController = RefreshController(initialRefresh: true);
  RefreshController taskCompletedRefreshController = RefreshController(initialRefresh: true);
  int taskProcessingCurrentPage = 1;
  int taskCompletedCurrentPage = 1;
  int pageRowsMax = 20;
  List<String> taskProcessingStates = ['Ready','TaskSuspended','TaskProcessing'];
  List<String> taskCompletedStates = ['TaskCompleted','TaskCancelled','TaskConflict','UpgradeFileBeChanged','UpgradeFileNoExist','UpgradeFileCrcCheckFail','UpgradeFileBeRefuse'];
  // 是否空视图
  bool isEmpty = false;
  // 是否首次数据加载完毕
  bool isLoadFinsh = false;


  @override
  void initState() {
    super.initState();
    isLoadFinsh = false;
    taskProcessingLoadFirst();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
      if(currentSegment == 0){
        taskProcessingCurrentPage = 1;
        taskProcessingList = [];
        taskProcessingLoadFirst();
      }else{
        taskCompletedCurrentPage = 1;
        taskCompletedList = [];
        taskCompletedLoadFirst();
      }
      
    });
  }

  String changeENtoZH(String state){
    String str = '';
    switch (state) {
      case 'Ready' : str = '任务就绪'; break;
      case 'TaskSuspended' : str = '任务挂起'; break;
      case 'TaskProcessing' : str = '正在升级'; break;
      case 'TaskCompleted' : str = '任务完成'; break;
      case 'TaskCancelled' : str = '任务取消'; break;
      case 'TaskConflict' : str = '任务冲突'; break;
      case 'UpgradeFileBeChanged' : str = '文件被修改'; break;
      case 'UpgradeFileNoExist' : str = '文件不存在'; break;
      case 'UpgradeFileCrcCheckFail' : str = '(文件)校验失败'; break;
      case 'UpgradeFileBeRefuse' : str = '终端拒绝'; break;
    }
    return str;
  }

  //正在升级任务起始
  void taskProcessingLoadFirst(){
    APIUpdate.upgradeTaskList(
      upgradeTaskStates: taskProcessingStates,
      page: taskProcessingCurrentPage,
      pageSize: pageRowsMax,
      onSucc: (list){
        if(mounted) {
          setState(() {
            this.taskProcessingList = list;
            taskProcessingRefreshController.refreshCompleted();
            if(list.length == 0) {
              this.isEmpty = true;
            }
          });
        }
      },onFail: (msg){
        setState(() {
          isLoadFinsh = true;
          taskProcessingRefreshController.refreshFailed();
        });
    });
  }

  //已完成任务起始
  void taskCompletedLoadFirst(){
    APIUpdate.upgradeTaskList(
      upgradeTaskStates: taskCompletedStates,
      page: taskCompletedCurrentPage,
      pageSize: pageRowsMax,
      onSucc: (list){
        if(mounted) {
          setState(() {
            this.taskCompletedList = list;
            taskCompletedRefreshController.refreshCompleted();
            if(list.length == 0) {
              this.isEmpty = true;
            }
          });
        }
      },onFail: (msg){
        setState(() {
          isLoadFinsh = true;
          taskCompletedRefreshController.refreshFailed();
        });
    });
  }


  //正在升级任务next
  void taskProcessingLoadNext(){
    taskProcessingCurrentPage++;
    APIUpdate.upgradeTaskList(
      upgradeTaskStates : taskProcessingStates,
      page: taskProcessingCurrentPage,
      pageSize: pageRowsMax,
      onSucc: (list){
        if(mounted) {
          setState(() {
            isLoadFinsh = true;
            debugPrint(list.toString());
            if(list == null || list?.length == 0) {
              taskProcessingRefreshController.loadNoData();
            }
            else{
              this.taskProcessingList.addAll(list);
              taskProcessingRefreshController.refreshCompleted();
            }
          });
        }
      },onFail: (msg){
        setState(() {
          isLoadFinsh = true;
          taskProcessingRefreshController.refreshFailed();
        });
    });
  }

  //已完成任务next
  void taskCompletedLoadNext(){
    taskCompletedCurrentPage++;
    APIUpdate.upgradeTaskList(
      upgradeTaskStates : taskCompletedStates,
      page: taskCompletedCurrentPage,
      pageSize: pageRowsMax,
      onSucc: (list){
        if(mounted) {
          setState(() {
            isLoadFinsh = true;
            debugPrint(list.toString());
            if(list == null || list?.length == 0) {
              taskCompletedRefreshController.loadNoData();
            }
            else{
              this.taskCompletedList.addAll(list);
              taskCompletedRefreshController.refreshCompleted();
            }
          });
        }
      },onFail: (msg){
        setState(() {
          isLoadFinsh = true;
          taskCompletedRefreshController.refreshFailed();
        });
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    
    
    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(widget.parentContext);
            },
            child: Image.asset('images/mine/My_back_btn.png',scale: 3,),
          ),
          backgroundColor: Colors.transparent,elevation: 0,centerTitle: true,
          title: Text('升级队列',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
        ),
        body: Column( 
          children: [
            SizedBox(
              width: size.width,
              //height: 40,
              child: Container(
                child: CupertinoSegmentedControl<int>(
                  unselectedColor : Colors.transparent,
                  borderColor:  Colors.white,
                  selectedColor: Colors.white,
                  pressedColor: Colors.white,
                  children: <int, Widget>{
                    0: Text('正在升级' , style: TextStyle(color: currentSegment == 0 ? Colors.black : Colors.white),),
                    1: Text('已完成',style: TextStyle(color: currentSegment == 0 ? Colors.white : Colors.black),),
                  },
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment,
                ),
              )
            ),
            SizedBox(height: 5,),
            Expanded(
              child: currentSegment == 0 ? taskProcessingListView(context) : taskCompletedListView(context),
            )
            
            
          ],  
        ),
        
      ),
    );
  }

  // 正在任务列表
  Widget taskProcessingListView(BuildContext context) {
    //if(isLoadFinsh == false) return SpinkitIndicator(title: '正在加载',subTitle: '请稍后');
    //if(isEmpty == true) return EmptyPage(title: '暂无数据',subTitle: '');
    return SmartRefresher(
      header: appRefreshHeader(),
      footer: appRefreshFooter(),
      enablePullDown: true,
      enablePullUp: true,
      onLoading: ()=> taskProcessingLoadNext(),
      onRefresh: ()=> taskProcessingLoadFirst(),
      controller: taskProcessingRefreshController,
      child: ListView.builder(
        itemCount: this.taskProcessingList?.length ?? 0,
        itemBuilder:  (BuildContext context, int index) => taskTile(context,index,this.taskProcessingList),
      )
    );
  }

  // 任务完成列表
  Widget taskCompletedListView(BuildContext context) {
    //if(isLoadFinsh == false) return SpinkitIndicator(title: '正在加载',subTitle: '请稍后');
    //if(isEmpty == true) return EmptyPage(title: '暂无数据',subTitle: '');
    return SmartRefresher(
      header: appRefreshHeader(),
      footer: appRefreshFooter(),
      enablePullDown: true,
      enablePullUp: true,
      onLoading: ()=> taskCompletedLoadNext(),
      onRefresh: ()=> taskCompletedLoadFirst(),
      controller: taskCompletedRefreshController,
      child: ListView.builder(
        itemCount: this.taskCompletedList?.length ?? 0,
        itemBuilder:  (BuildContext context, int index) => taskTile(context,index,this.taskCompletedList),
      )
    );
  }


  Widget taskTile(BuildContext context, int index ,List<UpdateTask> list) {

    var updateTask = list[index];

    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              // 新版电站滑块
              pushNewScreen(
                context,
                screen: null,//UpdateStationInfoPage(stations[index].stationNo),
                platformSpecific: true, 
                withNavBar: true, 
              );
              //pushToPage(context,UpdateStationInfoPage(stations[index].stationNo));
            },
            child: Container(
              child: SizedBox(
                  height: 55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      taskTileTop(updateTask),
                     
                    ],
                ),
              ),
            ),
          ),
          // 底部分割线
          SizedBox(height: 1, child: Container(color: Colors.white24)),
        ],
      ),
    );
  }

  Widget taskTileTop(UpdateTask updateTask) {
    // 离线在线状态
    //var isOnline = station?.terminalOnLineCount == 0 ? false : true  ;
    var width = MediaQuery.of(context).size.width;
    

    return SizedBox(
      height: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // 行
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 24,width: 24,
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage:AssetImage('images/about/about_icon.png'),
                ),
              ),
              SizedBox(width: 10),
              Text(changeENtoZH(updateTask.upgradeTaskState ?? '') ,style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width:width/2-20,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 24,width: 24,
                    ),
                    SizedBox(width: 10),
                    Text(updateTask.missionCreateTime,style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
          //     SizedBox(
          //       width:width/2-20,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           SizedBox(height: 24,width: 24,
          //           ),
          //           SizedBox(width: 8),
          //           Text(updateTask.upgradeFileMD5,style: TextStyle(color: Colors.white,fontSize: 15)),
          //           SizedBox(width: 8),
          //           SizedBox(
          //             height: 22,
          //             width: 22,
          //             child: Image.asset('images/mine/My_next_btn.png'),
          //           ),
          //         ]
          //       ),
          //     ),
            ],
          ),
        ],
      ),
    );
  }
}

