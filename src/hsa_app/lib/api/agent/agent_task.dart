import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/http_helper.dart';
import 'api/agent_api.dart';

enum TaskName {
  remotePowerOn,// 远程开机
  remotePowerOff,// 远程关机
  remoteMainValveOn,// 远程开主阀门
  remoteMainValveOff,// 远程关主阀门
  remoteSideValveOn, // 远程开旁通阀
  remoteSideValveOff,// 远程关旁通阀
  remoteSwitchRemoteModeOn,// 远程切换智能控制方案 - 打开远程控制
  remoteSwitchRemoteModeOff, // 远程切换智能控制方案 - 关闭远程控制
  remoteClearRubbishOn,// 远程控制垃圾清扫 - 开
  remoteClearRubbishOff,// 远程控制垃圾清扫 - 关
  remoteSettingActivePower,// 远程设定目标有功功率
  remoteSettingPowerFactor,// 远程设定目标功率因数
}

class AgentTask {

  AgentTask({this.maxRetryTimes = 10,this.loopInterval = 1});

   // 最大重试次数
   final int maxRetryTimes;
   // 轮询周期间隔 单位 s 秒
   final int loopInterval;
   Timer timer;
   int retryTime = 0;

   // 复位定时器
   void resetTimer() {
      retryTime = 0;
      timer?.cancel();
   }

    // 开启SendCommand新任务
    void sendCommandTask(
    // 上下文环境
    BuildContext context,{
    // 终端地址
    @required String address,
    // AFN
    @required String afn,
    // 功能编码
    @required String func,
    // 参数值
    Map<String,dynamic> param,
    // 操作密码
    String password,
    // 成功、失败、执行中回调函数
    HttpSuccMsgCallback onSucc,HttpFailCallback onFail,HttpSuccMsgCallback onLoading}) async {
      
      resetTimer();

      if(address == null || address.length == 0 ){
        if(onFail != null) onFail('终端地址缺失');
        return;
      }

      if(afn == null || afn.length == 0 ){
        if(onFail != null) onFail('AFN参数缺失');
        return;
      }

      if(func == null || func.length == 0 ){
        if(onFail != null) onFail('功能码缺失');
        return;
      }

      final isControlCmd = isControl(afn);

      // 控制指令 - 先获取操作票
      if(isControlCmd == true) {
        AgentAPI.getCheckOperation(context, password, (ticket,msg){
          debugPrint('操作票: ' +ticket.toString());
          // 再下发指令
          AgentAPI.getCommandId(address: address,afn: afn,func: func,param:param,operationTicket: ticket,onFail:(_){
          if(onFail != null) onFail('命令发送失败');
          return;
          },onSucc: (cmdId,msg){
          pollingTask(cmdId:cmdId,isControl: isControlCmd,onFail:onFail,onLoading: onLoading,onSucc:onSucc);
          }); 
        }, onFail);
      }
      // 查询指令 - 无需操作票
      else {
        AgentAPI.getCommandId(address: address,afn: afn,func: func,param:param,onFail:(_){
          if(onFail != null) onFail('命令发送失败');
          return;
        },onSucc: (cmdId,msg){
          pollingTask(cmdId:cmdId,isControl: isControlCmd,onFail:onFail,onLoading: onLoading,onSucc:onSucc);
        }); 
      }

    }

    // 判断是否是控制指令
    bool isControl(String afn){

      if(afn.toUpperCase() == '05') {
        return true;
      }
      return false;
      
    }


    // 轮询任务逻辑
    void pollingTask({@required String cmdId,@required bool isControl,HttpFailCallback onFail, HttpSuccMsgCallback onLoading, HttpSuccMsgCallback onSucc}) {

      if(cmdId == null || cmdId.length == 0 ){
        if(onFail != null) onFail('CmdID缺失');
        return;
      }

      if(isControl == null){
        if(onFail != null) onFail('isControl参数缺失缺失');
        return;
      }

        // 一秒一个周期查询
      timer = Timer.periodic(Duration(seconds: loopInterval), (timer) {

        retryTime ++;

        if(retryTime > maxRetryTimes) {

          resetTimer();

          if(onFail != null) onFail('操作超时');
          return;
        }

        AgentAPI.followCommandId(cmdId,isControl,onSucc:(msg){
            
            resetTimer();
            if(onSucc != null) onSucc(msg);

          },
          onLoading: (msg){

            if(onLoading != null) onLoading(msg);
          },
          onFail: (msg){

            resetTimer();
            if(onFail != null) onFail(msg);
              
          },
        );

      });
    }



} 
