import 'package:hsa_app/debug/model/electricity_price.dart';
import 'package:hsa_app/debug/model/nearest_running_data.dart';

class NearestRunningDataResp {

  // 是否是基础版
  bool isBase ;
  // 电价
  ElectricityPrice price;
  // 运行时数据
  NearestRunningData data;

  NearestRunningDataResp(this.isBase, {this.data,this.price});

  NearestRunningDataResp.fromJson(Map<String, dynamic> json,String terminalAddress,{this.isBase,this.price}) {
    data = json['data'] != null ? NearestRunningData.fromJson(json['data'],terminalAddress,isBase:this.isBase,price: this.price) : null;
  }

}
