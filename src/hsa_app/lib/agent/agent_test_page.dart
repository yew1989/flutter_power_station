import 'package:flutter/material.dart';
import 'package:hsa_app/agent/agent_api.dart';
import 'package:hsa_app/agent/agent_task.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/debug/API/debug_api_login.dart';

class AgentTestPage extends StatefulWidget {
  @override
  _DebugAgentTestPageState createState() => _DebugAgentTestPageState();
}

class _DebugAgentTestPageState extends State<AgentTestPage> {

  final List<String> leftLabels = [

    '登录',
    '获取Cmd AFN0C.F1(单条)',
    '召测任务 AFN0C.F1',
    '召测任务 AFN0C.F2',
    '操作票获取 (单条)',
    '控制指令 AFN05.F2',
    
    ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 列表中的每个行
  Widget listTile(BuildContext context,int index) {
    final String titleText = leftLabels[index];
    return ListTile(title: Text('${(index+1)}、 $titleText'),onTap:()=> onTapTile(index));
  }

  // 点击了单元格
  void onTapTile(int index) async {
    // 登录
    if(index == 0 ) {
      DebugAPILogin.login(context,name:'admin',pswd: '456',onSucc: (auth,msg){
        showToast(msg + auth.toString());
      },onFail:(msg){
        showToast(msg);
      });

    }
    else if(index == 1 ) {

      // 发送命令 00020013/AFN0C_F1/0
      AgentAPI.getCommandId(
        address: '00020013',
        afn: '0C',
        func: 'F1',
        onSucc: (cmdId,msg){
          showToast(msg + '\n' + cmdId);
        },
        onFail:(msg){
        showToast(msg);
      });

    }

    else if(index == 2 ) {

      AgentTask().sendCommandTask(
        context,
        address: '00020013', 
        afn: '0C',
        func: 'F1',
        onSucc: (msg) {
          showToast(msg);
        },
        onLoading: (msg) {
          showToast(msg);
        },
        onFail: (msg){
          showToast(msg);
        },
      );
    }

    else if(index == 3 ) {

      AgentTask().sendCommandTask(
        context,
        address: '00020013', 
        afn: '0C',
        func: 'F2',
        param: {'远程主阀开关':true},
        onSucc: (msg) {
          showToast(msg);
        },
        onLoading: (msg) {
          showToast(msg);
        },
        onFail: (msg){
          showToast(msg);
        },
      );

    }
    // 操作票获取
    else if(index == 4) {

      AgentAPI.getCheckOperation(context, '123abc', (ticket,msg){
        showToast(msg + '\n' + ticket);
      }, (msg){
        showToast(msg);
      });

    }
    else if(index == 5) {

      // 远程控制主阀开关
      AgentTask().sendCommandTask(
        context,
        password: '123abc',

        address: '00020013', 
        afn: '05',
        func: 'F2',
        param: { '远程主阀开关' : false },

        onSucc: (msg) {
          showToast(msg);
        },

        onLoading: (msg) {
          showToast(msg);
        },

        onFail: (msg){
          showToast(msg);
        },

      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('招测指令')),
      body:ListView.builder(
        itemBuilder: (_, index) => listTile(context,index),
        itemCount: leftLabels.length,
      ),
    );
  }
}