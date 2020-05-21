import 'package:hsa_app/model/model/all_model.dart';

class UpdateTaskResp {
  int code;
  int httpCode;
  Data data;
  UpdateTask updateTask;

  UpdateTaskResp({this.code, this.httpCode, this.data, this.updateTask});

  UpdateTaskResp.fromJson(Map<String, dynamic> json,String str) {
    //String str = 'updateTask';
    code = json['code'];
    httpCode = json['httpCode'];
    if('updateTaskList' == str){
      data = json['data'] != null ? new Data.fromJson(json['data'],str) : null;
    }
    if('upgradeLog' == str){
      data = json['data'] != null ? new Data.fromJson(json['data'],str) : null;
    }
    if('updateTask' == str){
      updateTask = json['data'] != null ? new UpdateTask.fromJson(json['data']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['httpCode'] = this.httpCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}