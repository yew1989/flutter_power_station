// 远程控制 API
import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/http_helper.dart';

class AgentControlAPI {
  
  // 远程开机
  static void remotePowerOn(BuildContext context , {String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F1',password: password,param: {'远程开停机':true},onFail: onFail,onSucc: onSucc);
  }
  
  // 远程关机
  static void remotePowerOff(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F1',password: password,param: {'远程开停机':false},onFail: onFail,onSucc: onSucc);
  }

  // 远程开主阀门
  static void remoteMainValveOn(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F2',password: password,param: {'远程主阀开关':true},onFail: onFail,onSucc: onSucc);
  }

  // 远程关主阀门
  static void remoteMainValveOff(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F2',password: password,param: {'远程主阀开关':false},onFail: onFail,onSucc: onSucc);
  }

  // 远程设定目标有功功率
  static void remoteSettingActivePower(BuildContext context ,String power,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F3',password: password,param: {'目标有功功率':power},onFail: onFail,onSucc: onSucc);
  }
  // 远程设定目标功率因数
  static void remoteSettingPowerFactor(BuildContext context ,String factor,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F4',password: password,param: {'目标功率因数':factor},onFail: onFail,onSucc: onSucc);
  }

  // 远程开旁通阀
  static void remoteSideValveOn(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F16',password: password,param: {'开关旁通阀':1},onFail: onFail,onSucc: onSucc);
  }
  // 远程关旁通阀
  static void remoteSideValveOff(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F16',password: password,param: {'开关旁通阀':0},onFail: onFail,onSucc: onSucc);
  }
  // 远程切换智能控制方案 - 打开远程控制
  static void remoteSwitchRemoteModeOn(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F13',password: password,param: {'智能控制方案标识':1},onFail: onFail,onSucc: onSucc);
  }
  // 远程切换智能控制方案 - 关闭远程控制
  static void remoteSwitchRemoteModeOff(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F13',password: password,param: {'智能控制方案标识':0},onFail: onFail,onSucc: onSucc);
  }

  // 远程控制垃圾清扫 - 开
  static void remoteClearRubbishOn(BuildContext context,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F21',password: password,param: {'清理垃圾开启或关停':1},onFail: onFail,onSucc: onSucc);
  }
  // 远程控制垃圾清扫 - 关
  static void remoteClearRubbishOff(BuildContext context ,{String address,String password,HttpSuccMsgCallback onSucc,HttpFailCallback onFail}) {
    AgentTask().sendCommandTask(context, address: address, afn: '05', func: 'F21',password: password,param: {'清理垃圾开启或关停':0},onFail: onFail,onSucc: onSucc);
  }
  

  // 开启新任务
  static void startTask(BuildContext context,String param,TaskName task,String address,String password,
    HttpSuccMsgCallback onSucc,
    HttpFailCallback onFail,
    HttpSuccMsgCallback onLoading,){

      switch (task) {

        // 远程开机
        case TaskName.remotePowerOn:{
          remotePowerOn(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程关机
        case TaskName.remotePowerOff:{
          remotePowerOff(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程开主阀门
        case TaskName.remoteMainValveOn:{
          remoteMainValveOn(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程关主阀门
        case TaskName.remoteMainValveOff:{
          remoteMainValveOff(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程设定目标有功功率
        case TaskName.remoteSettingActivePower:{
          remoteSettingActivePower(context,param,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程设定目标功率因数
        case TaskName.remoteSettingPowerFactor:{
          remoteSettingPowerFactor(context,param,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程开旁通阀
        case TaskName.remoteSideValveOn:{
          remoteSideValveOn(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程关旁通阀
        case TaskName.remoteSideValveOff:{
          remoteSideValveOff(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程切换智能控制方案 - 打开远程控制
        case TaskName.remoteSwitchRemoteModeOn:{
          remoteSwitchRemoteModeOn(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程切换智能控制方案 - 关闭远程控制
        case TaskName.remoteSwitchRemoteModeOff:{
          remoteSwitchRemoteModeOff(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程控制垃圾清扫 - 开
        case TaskName.remoteClearRubbishOn:{
          remoteClearRubbishOn(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;

        //远程控制垃圾清扫 - 关
        case TaskName.remoteClearRubbishOff:{
          remoteClearRubbishOff(context,address:address,password: password,
          onSucc: (msg){
            onSucc(msg);
          },
          onFail: (msg){
            onFail(msg);
          }
          );
        }
        break;
      }
  }
}