import 'package:flutter/material.dart';
import 'package:hsa_app/api/agent/agent_operation_ticket.dart';
import 'package:hsa_app/api/agent/agent_replay_unit.dart';
import 'package:hsa_app/debug/debug_api.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/util/encrypt.dart';

// 发送远程指令
typedef AgentReplyUnitCallback = void Function(AgentReplyUnitResp resp);

// 发送远程指令 - 基础API
class AgentAPI {
  
  // 获取操作票
  static void getCheckOperation(BuildContext context ,String password,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail) async {
    
    if(password == null || password.length == 0) {
      if(onFail != null) onFail('请输入操作密码');
      return;
    }

    final checkPath = DebugAPI.restHost + '/v1/Account/admin/Check/OperationPassword';
    final encryptedPswd = await LDEncrypt.encryptedRSA(context, password);

    if(encryptedPswd == null || encryptedPswd.length == 0) {
      if(onFail != null) onFail('密码生成失败');
      return;
    }
    
    DebugHttpHelper.httpPOST(checkPath, {'':encryptedPswd}, (map,_){

      var resp = AgentOperationTicketResp.fromJson(map);
      if(resp.code != 0 || resp.httpCode != 200) {
        if(onFail != null) onFail('操作票获取失败');
        return;
      }

      // 操作票获取
      final operationTicket = resp?.data?.operationTicket ?? '';
      if(operationTicket.length == 0) {
        if(onFail != null) onFail('操作票获取失败');
        return;
      }

      // 操作票获取成功
      if(onSucc != null) onSucc(operationTicket,'操作票获取成功');
      return;
    }, (msg){
      if(onFail != null) onFail('操作票获取失败');
      return;
    });

  }

  // 发送远程代理指令
  static void getCommandId({String address,String afn,String func,Map<String,dynamic> param,String operationTicket,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {

    Map<String,dynamic> header = Map<String,dynamic>();
    if(operationTicket != null) {
      if(operationTicket.length != 0) {
        header['OperationTicket'] = operationTicket;
      }
    }

    final sendCommandPath = DebugAPI.agentHost + '/v1/Cmd/Send/' + address + '/AFN' + afn + '_' + func + '/0';
    
      DebugHttpHelper.httpPOST(sendCommandPath, param, (map,_){
      
      var resp =  AgentReplyUnitResp.fromJson(map);
      
      final cmdId = resp.cmdId;

      if(cmdId == null) {
        if(onFail != null) onFail('发送命令失败');
        return ;
      }

      // 成功获取到 CmdId
      if(onSucc != null) onSucc(cmdId,'获取CmdId成功');
      
      }, onFail,header:header);
  
    }

    // 跟踪远程命令
    static void followCommandId(String cmdId,bool isControl,{DebugHttpSuccVoidCallback onSucc,DebugHttpFailCallback onFail,DebugHttpSuccVoidCallback onLoading}){

      final followCommandPath = DebugAPI.agentHost + '/v1/Cmd/' + cmdId;

      DebugHttpHelper.httpGET(followCommandPath, null, (map,msg){

      var resp =  AgentReplyUnitResp.fromJson(map);
      
      final cmdId = resp.cmdId ?? '';
      final state = resp.currentState ?? '';

      if(cmdId.length == 0) {
        if(onFail != null) onFail('发送命令异常');
        return ;
      }

      if(state.length == 0) {
        if(onLoading != null) onLoading('等待响应中');
        return ;
      }

      if(state == 'ReadyToSend' || state == 'WaitingForResponse') {
        if(onLoading != null) onLoading('等待响应中');
        return ;
      }

      if(state == 'ResponseOutTime') {
        if(onFail != null) onFail('响应超时');
        return ;
      }

      if(state == 'UnknownError') {
        if(onFail != null) onFail('未知错误');
        return ;
      }

      if(state == 'CannotCommunicate') {
        if(onFail != null) onFail('无法通讯');
        return ;
      }

      if(state != 'ResponseSuccess') {
        if(onLoading != null) onLoading('等待响应中');
        return ;
      }

      final replayList = resp.replyDataUnitList;

      if(replayList == null) {
        if(onLoading != null) onLoading('等待响应中');
        return ;
      }
      if(replayList.length == null) {
        if(onLoading != null) onLoading('等待响应中');
        return ;
      }
      
      final unit = replayList.first;
      
      final fn = unit.fn;

      // 控制类命令 1 全部确认 2 全部否认 3 部分确认
      if(isControl == true) {
        if(fn == 1) {
         if(onSucc != null) onSucc('操作成功(确认)');
         return ;
        }
        else {
          if(onFail != null) onFail('操作失败(否认)');
          return ;
        }
      }
      // 非控制类命令 不校验上行报文中的 fn
      else {
         if(onSucc != null) onSucc('操作成功');
         return ;
      }

      }, onFail);

    }

}