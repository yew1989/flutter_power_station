import 'package:hsa_app/debug/debug_api.dart';
import 'package:hsa_app/debug/debug_api_helper.dart';
import 'package:hsa_app/debug/model/all_model.dart';
import 'package:hsa_app/debug/model/electricity_price.dart';
import 'package:hsa_app/debug/response/all_resp.dart';

class DebugAPIStation{

  // 获取电站列表信息
  static void getStationList({bool isIncludeCustomer,bool isIncludeWaterTurbine,bool isIncludeFMD,bool isIncludeLiveLink,
      String partStationName,String partStationNamePinYin,String proviceAreaCityNameOfDotSeparated,
      List<String> arrayOfCustomerNoOptAny, List<String> arrayOfStationNoOptAny,
      int page,int pageSize, StationListCallback onSucc,DebugHttpFailCallback onFail}) async {
       
    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否要包含生态下泄信息
    if(isIncludeFMD != null){
      param['isIncludeFMD'] = isIncludeFMD;
    }

    //结果中是否要包含监控地址
    if(isIncludeLiveLink != null){
      param['isIncludeLiveLink'] = isIncludeLiveLink;
    }

    //部分电站名 模糊匹配
    if(partStationName != null){
      param['partStationName'] = partStationName;
    }

    //部分电站拼音 模糊匹配
    if(partStationNamePinYin != null ){
      param['partStationNamePinYin'] = partStationNamePinYin;
    }

    //用.号分隔的电站所在地（省.地区.市）（三段模式匹配,*为通配符)
    if(proviceAreaCityNameOfDotSeparated != '' && proviceAreaCityNameOfDotSeparated != null){
      param['proviceAreaCityNameOfDotSeparated'] = proviceAreaCityNameOfDotSeparated;
    }

    //客户号数组 匹配数组中的任一值
    if(arrayOfCustomerNoOptAny != [] && arrayOfCustomerNoOptAny != null){
      param['arrayOfCustomerNoOptAny'] = arrayOfCustomerNoOptAny;
    }

    //电站号数组 匹配数组中的任一值
    if(arrayOfStationNoOptAny != [] && arrayOfStationNoOptAny != null){
      param['arrayOfStationNoOptAny'] = arrayOfStationNoOptAny;
    }

    param['page'] = (page != null ? page : 1 );
    param['pageSize'] = (pageSize != null ? pageSize : 20 );

    // 获取电站列表信息地址
    final path = DebugAPI.restHost + '/v1/HydropowerStation';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationListResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
    }, onFail);
  }


  //单条电站信息
  static void getStationInfo({String stationNo,
    bool isIncludeCustomer,bool isIncludeWaterTurbine,bool isIncludeFMD,bool isIncludeLiveLink,
    StationInfoCallback onSucc,DebugHttpFailCallback onFail})async {

    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否要包含生态下泄信息
    if(isIncludeFMD != null){
      param['isIncludeFMD'] = isIncludeFMD;
    }

    //结果中是否要包含监控地址
    if(isIncludeLiveLink != null){
      param['isIncludeLiveLink'] = isIncludeLiveLink;
    }


    // 获取电站列表信息地址
    final path = DebugAPI.restHost + '/v1/HydropowerStation/' + '$stationNo';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationInfoResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
    }, onFail);
  }


  // 获取水轮机组信息
  static void getWaterTurbineList({String stationNo,bool isIncludeCustomer,bool isIncludeWaterTurbine,
    bool isIncludeFMD,bool isIncludeLiveLink,StationInfoCallback onSucc,DebugHttpFailCallback onFail}) async {
        // 输入检查
    if(stationNo == null) {
      if(onFail != null) onFail('');
      return;
    }

    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否要包含生态下泄信息
    if(isIncludeFMD != null){
      param['isIncludeFMD'] = isIncludeFMD;
    }

    //结果中是否要包含监控地址
    if(isIncludeLiveLink != null){
      param['isIncludeLiveLink'] = isIncludeLiveLink;
    }

    
    // 获取帐号信息地址
    final path = DebugAPI.restHost + '/v1/HydropowerStation/' + '$stationNo';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp = StationInfoResp.fromJson(map);
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

  //取当前帐号关注的电站号列表
  static void currentAccountFavoriteStationNos({DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    final path = DebugAPI.restHost + '/v1/HydropowerStation/CurrentAccountFavoriteStationNos';
    
    DebugHttpHelper.httpPUT(path, null, (map,_){

      if(onSucc != null) onSucc('','');
      
    }, onFail);
  }


  //获取关注电站的电站编号数组
  static void getFavoriteStationNos({ListCallback onSucc,DebugHttpFailCallback onFail}) async {

    final path = DebugAPI.restHost + '/v1/HydropowerStation/CurrentAccountFavoriteStationNos';
    
    DebugHttpHelper.httpGET(path, null, (map,_){
      //List<String> list = [];
      var resp =  map['data'].cast<String>();
      if(onSucc != null) onSucc(resp);
      
    }, onFail);
  }


  //终端信息
  static void getDeviceTerminalInfo({String terminalAddress,
    bool isIncludeCustomer,bool isIncludeWaterTurbine,bool isIncludeHydropowerStation,
    DeviceTerminalCallback onSucc,DebugHttpFailCallback onFail})async {

    Map<String, dynamic> param = new Map<String, dynamic>();

    //结果中是否要包含客户信息
    if(isIncludeCustomer != null){
      param['isIncludeCustomer'] = isIncludeCustomer;
    }
    
    //结果中是否要包含机组信息
    if(isIncludeWaterTurbine != null){
      param['isIncludeWaterTurbine'] = isIncludeWaterTurbine;
    }

    //结果中是否含有电站信息
    if(isIncludeHydropowerStation != null){
      param['isIncludeHydropowerStation'] = isIncludeHydropowerStation;
    }


    // 获取电站列表信息地址
    final path = DebugAPI.restHost + '/v1/DeviceTerminal/' + '$terminalAddress';
    
    DebugHttpHelper.httpGET(path, param, (map,_){

      var resp =  DeviceTerminal.fromJson(map);
      if(onSucc != null) onSucc(resp);
    }, onFail);
  }


  //操作电站关注/取消关注
  static void setFavorite({String stationNo,bool isFavorite,DebugHttpSuccStrCallback onSucc,DebugHttpFailCallback onFail}) async {
        // 输入检查
    if(stationNo == null) {
      if(onFail != null) onFail('错误电站');
      return;
    }
    final path = DebugAPI.restHost + '/v1/HydropowerStation/' + '$stationNo'+'/SetFavorite/'+'$isFavorite';
    
    DebugHttpHelper.httpPUT(path, null, (map,_){

      if(onSucc != null) onSucc('',isFavorite ? '关注成功':'取消成功');
      
    }, onFail);
  }


  //取终端最近运行时通讯的数据(多)
  static void getMultipleAFNFnpn({String terminalAddress,List<String> paramList,NearestRunningDataCallback onSucc,DebugHttpFailCallback onFail}) async {
    
    final path = DebugAPI.liveDataHost + '/v1/NearestRunningData/'+'$terminalAddress'+'/MultipleAFNFnpn';
    
    var param = {'':paramList};

    DebugHttpHelper.httpPOST(path, param, (map,_){

      var resp = NearestRunningDataResp.fromJson(map,terminalAddress,isBase: true,price: ElectricityPrice(
        peakElectricityPrice:1.0,
        spikeElectricityPrice: 2.0,
        flatElectricityPrice: 3.0,
        valleyElectricityPrice: 4.0,
      ));
      if(onSucc != null) onSucc(resp.data);
      
    }, onFail);
  }

}