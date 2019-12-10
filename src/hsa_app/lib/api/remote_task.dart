import 'dart:async';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/api/http_helper.dart';
import 'package:hsa_app/model/follow_command.dart';

enum TaskName {
  powerOn,
  powerOff,
  mainValveOn,
  mainValveOff,
  sideValveOn,
  sideValveOff,
  switchRemoteOn,
  switchRemoteOff,
  clearRubbishOn,
  clearRubbishOff,
  setttingActivePower,
  settingPowerFactor,
}

class RemoteControlTask {

    static const int retryCountMax = 10;
    Timer timer;
    int retryCnt = 0;

    // 开启新任务
    void startTask(TaskName task,String address,String param,
    HttpSuccMsgCallback onSucc,
    HttpFailCallback onFail,
    HttpSuccMsgCallback onLoading,
    ) {
      
      retryCnt = 0;
      timer?.cancel();

      switch (task) {

        // 切换到远程模式
        case TaskName.switchRemoteOn:
        {
            API.remoteSwitchRemoteModeOn(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }    
        break;
        // 切换到自动模式
        case TaskName.switchRemoteOff:
        {
            API.remoteSwitchRemoteModeOff(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }    
        break;
        // 开机
        case TaskName.powerOn:
        {
            API.remotePowerOn(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }    
        break;
        // 关机
        case TaskName.powerOff: 
        {
            API.remotePowerOff(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 打开主阀门
        case TaskName.mainValveOn: 
        {
            API.remoteMainValveOn(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 关闭主阀门
        case TaskName.mainValveOff: 
        {
            API.remoteMainValveOff(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 打开旁通阀
        case TaskName.sideValveOn: 
        {
            API.remoteSideValveOn(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 关闭旁通阀
        case TaskName.sideValveOff: 
        {
            API.remoteSideValveOff(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 打开清理垃圾
        case TaskName.clearRubbishOn: 
        {
            API.remoteClearRubbishOn(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 关闭清理垃圾
        case TaskName.clearRubbishOff: 
        {
            API.remoteClearRubbishOff(address, (String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 设置有功功率
        case TaskName.setttingActivePower:
        {
            API.remoteSettingActivePower(address, param,(String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        // 设置功率因数
        case TaskName.settingPowerFactor:
        {
            API.remoteSettingPowerFactor(address,param,(String cmdId) {
              pollingTask(onFail, cmdId, onLoading, onSucc);
            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }
        break;
        default:
      }
    }

    // 轮询任务逻辑
    void pollingTask(HttpFailCallback onFail, String cmdId, HttpSuccMsgCallback onLoading, HttpSuccMsgCallback onSucc) {
        // 一秒一个周期查询
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
          retryCnt ++;
          if(retryCnt > RemoteControlTask.retryCountMax) {
            retryCnt = 0;
            timer?.cancel();
            if(onFail != null) onFail('操作超时');
            return;
          }
          // 跟踪指令
          API.followCommand(cmdId, (FollowCommandResp resp){
          
          // 响应标志
          if(resp.replyAFN != 0) {
            timer?.cancel();
            if(onFail != null) onFail('操作失败');
            return;
          }
      
          // 当前状态 = 响应中 
          if(resp.currentState == null || resp.currentState == 0 || 
          resp.currentState == 1 || resp.currentState == 255) {
            if(onLoading != null) onLoading('等待响应中');
          }
      
          // 响应成功
          if(resp.currentState == 2) {
            if(resp.replyDataUnitList != null) {
              var firstElement = resp.replyDataUnitList.first;
              if(firstElement != null) {
                var fn = firstElement?.fn ?? 0;
                // 确认
                if(fn == 1) {
                    timer?.cancel();
                    if(onSucc != null) onFail('操作成功');
                    return;
                }
                // 否认
                else {
                    timer?.cancel();
                    if(onFail != null) onFail('操作失败');
                    return;
                }
              }
            }
          }
      
      
        }, (String msg){
            timer?.cancel();
            if(onFail != null) onFail('操作失败');
            return;
        });
      
      });
    }

    void cancelTask() {
      timer?.cancel();
    }

}