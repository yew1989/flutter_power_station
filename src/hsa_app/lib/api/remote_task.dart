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
        // 开机
        case TaskName.powerOn:
        {
            // 下发指令
            API.remotePowerOn(address, (String cmdId) {

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

            }, (String msg){
              timer?.cancel();
              if(onFail != null) onFail('操作失败');
            });
        }    
          break;
        default:
      }
    }

    void cancelTask() {
      timer?.cancel();
    }

}