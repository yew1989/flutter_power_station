import 'package:hsa_app/model/model/all_model.dart';

//分页层
class Data {
  int total;
  //电站
  List<StationInfo> stationInfo;
  //水位功率状态组合
  double reservoirAlarmWaterStage;
  double reservoirBasicWaterStage;
  List<Turbine> turbine;
  List<BannerModel> banners;
  String reservoirCurrentWaterStage;
  double totalActivePower;
  List<StatisticalPower> statisticalPowerList;

  Data({this.total, this.stationInfo});

  Data.fromJson(Map<String, dynamic> json,String state) {
    total = json['total'];
    if (json['rows'] != null && state == 'station') {
      stationInfo = new List<StationInfo>();
      json['rows'].forEach((v) {
        stationInfo.add(new StationInfo.fromJson(v));
      });
    }
    if (json['rows'] != null && state == 'turbine') {
      turbine = new List<Turbine>();
      json['rows'].forEach((v) {
        turbine.add(new Turbine.fromJson(v));
      });
    }
    if (json['rows'] != null && state == 'statisticalPower') {
      statisticalPowerList = new List<StatisticalPower>();
      json['rows'].forEach((v) {
        statisticalPowerList.add(new StatisticalPower.fromJson(v));
      });
    }

    reservoirAlarmWaterStage = json['reservoirAlarmWaterStage'] != null ? 
        (json['reservoirAlarmWaterStage'] is double ? json['reservoirAlarmWaterStage']: json['reservoirAlarmWaterStage'].cast<double>()): 0.0 ;
    reservoirBasicWaterStage = json['reservoirBasicWaterStage'] != null ? 
        (json['reservoirBasicWaterStage'] is double ? json['reservoirBasicWaterStage'] : json['reservoirBasicWaterStage'].cast<double>() ): 0.0 ;

    if (json['banner'] != null && state == 'banner') {
      banners = new List<BannerModel>();
      json['banner'].forEach((v) {
        banners.add(new BannerModel.fromJson(v));
      });
    }

    totalActivePower = json['totalActivePower'] != null ? 
        (json['totalActivePower'] is double ? json['totalActivePower']: json['totalActivePower'].cast<double>()): 0.0 ;
    reservoirCurrentWaterStage = json['reservoirCurrentWaterStage'] ?? '' ;

    if(state == 'current'){
      stationInfo = new List<StationInfo>();

      if(json['stations'] != null ){
        json['stations'].forEach((v) {
          stationInfo.add(new StationInfo.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.stationInfo != null) {
      data['rows'] = this.stationInfo.map((v) => v.toJson()).toList();
    }
    if (this.turbine != null) {
      data['rows'] = this.turbine.map((v) => v.toJson()).toList();
    }

    data['reservoirAlarmWaterStage'] = this.reservoirAlarmWaterStage;
    data['reservoirBasicWaterStage'] = this.reservoirBasicWaterStage;
    
    if (this.banners != null) {
      data['banner'] = this.banners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}