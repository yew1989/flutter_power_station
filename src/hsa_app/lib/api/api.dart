import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/api/http_helper.dart';
import 'package:hsa_app/model/caiyun.dart';
import 'package:hsa_app/model/more_data.dart';
import 'package:hsa_app/model/pageConfig.dart';
import 'package:hsa_app/model/province.dart';
import 'package:hsa_app/model/runtime_data.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/model/station_info.dart';
import 'package:hsa_app/model/version.dart';
import 'package:hsa_app/util/encrypt.dart';
import 'package:hsa_app/util/share.dart';
import 'package:ovprogresshud/progresshud.dart';
import 'package:hsa_app/model/banner_item.dart';


typedef HttpSuccMsgCallback = void Function(String msg);

// 获取广告栏列表
typedef BannerResponseCallBack = void Function(List<BannerItem> banners);
// 获取省份列表
typedef ProvinceResponseCallBack = void Function(List<String> provinces);
// 获取电站数量
typedef StationCountResponseCallBack = void Function(int count);
// 获取电站列表
typedef StationsListResponseCallBack = void Function(List<Stations> stations,int total);
// 获取电站详情
typedef StationInfoResponeseCallBack = void Function(StationInfo stationInfo);
// 获取天气类型 0 晴 1 阴 2 雨
typedef WeatherTypeResponseCallBack = void Function(int type);
// 获取实时参数
typedef RuntimeDataResponseCallBack = void Function(RuntimeDataResponse data);
// 获取更多参数
typedef MoreDataResponseCallBack = void Function(List<MoreItem> items);

class API {
  // 内网主机地址
  static final host = 'http://192.168.16.120:18081/';
  // 穿透内网主机地址
  // static final host = 'http://18046053193.qicp.vip:20187/';

  // 文件路径 与 地址
  static final filePath = 'HsaApp2.0/Native/';
  static final fileVersionInfo = 'appVersion.json';
  static final fileWebRoute = 'pageConfig.json';

  // API 接口地址
  static final loginPath = 'Account/Login';
  static final pswdPath = 'api/Account/ChangePassword';
  static final customStationInfoPath = 'api/General/CustomerStationInfo';
  static final terminalInfoPath = '/api/General/TerminalInfo';
  static final treeNodePath = 'CustomerHydropowerStation/TreeNodeJSON';

  // 上传文件
  static final uploadFilePath = 'Api/Account/UploadMobileAccountCfg';
  // 下载文件
  static final downloadFilePath = 'Api/Account/DownloadMobileAccountCfg';

  // 广告栏
  static final bannerListPath = 'app/GetBannerList';
  // 省份列表
  static final provinceListPath = 'app/GetProvinceList';
  // 电站列表
  static final stationListPath = 'app/GetStationList';
  
  // 关注,取消关注电站
  static final focusStationPath = 'app/FocusStation';

  // 电站详情
  static final stationInfoPath  = 'app/GetStationInfo';

  // 彩云天气 url
  static final caiyunWeatherPath = 'https://api.caiyunapp.com/v2/iAKlQ99dfiDclxut/';

  // 实时运行参数
  static final runtimeDataPath = API.host + 'api/General/RuntimeData';

  // 更多数据
  static final moreDataPath = API.host + 'api/General/TerminalOverViewData';

  // 操作密码检查
  static final operationCheckPath = API.host + 'api/Account/CheckOperationTicket';


  // 操作密码检查
  static void checkOperationPswd(BuildContext context,String pswd,HttpSuccMsgCallback onSucc,HttpFailCallback onFail) async {

    if(pswd == null) return;
    if(pswd.length == 0) return;
    var rsaPswd = await LDEncrypt.encryptedRSAWithOldAppKey(context, pswd);
    
    HttpHelper.postHttpCommonString(operationCheckPath, rsaPswd, (dynamic data,String msg){
       var map  = data as Map<String,dynamic>;
       var isSuccess = map['Success'] ?? false;
       if(isSuccess == true){
         if(onSucc != null) onSucc('操作密码正确');
       }
       else {
         var msg = map['Msg']?? '操作密码错误';
         if(onFail != null) onFail(msg);
       }
    }, onFail);
  }

  // 获取实时运行参数
  static void runtimeData(String address,RuntimeDataResponseCallBack onSucc,HttpFailCallback onFail) {

    var addressId = address??'';
    var totalPath = runtimeDataPath + '/' + addressId;

    HttpHelper.postHttpCommon(totalPath, null, (dynamic data,String msg){
        var map  = data as Map<String,dynamic>;
        var resp = RuntimeDataResponse.fromJson(map);
        if(onSucc != null) onSucc(resp);
    }, onFail);

  }

  // 获取更多参数
  static void moreData(String address,MoreDataResponseCallBack onSucc,HttpFailCallback onFail) {
    
    var addressId = address??'';
    var totalPath = moreDataPath + '/' + addressId;

    HttpHelper.getHttpCommonRespList(totalPath, null, (dynamic data,String msg){
        var list  = data as List;
        var items = List<MoreItem>();
        for(var str in list) {
          items.add(MoreItem.fromJson(str));
        }
        if(onSucc != null) onSucc(items);
    }, onFail);

  }

  // 彩云天气
  static void weatherCaiyun(Geo geo,WeatherTypeResponseCallBack onSucc,HttpFailCallback onFail) {

    var longitude = geo?.longitude ?? 0.0;
    var latitude  = geo?.latitude ?? 0.0;
    if(longitude == 0){
      onSucc(0);
      return;
    } 
    if(latitude == 0) {
      onSucc(0);
      return;
    }

    var totalPath = caiyunWeatherPath + longitude.toString() + ',' + latitude.toString() + '/realtime.json';
    
    HttpHelper.getHttpCommon(totalPath, null, (dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var resp = CaiyuWeatherResponse.fromJson(map);
        if(onSucc != null){
          var status = resp.status;
          if(status != 'ok') {
            onSucc(0);
            return;
          }
          // 获取天气情况
          var sky = resp?.result?.skycon ?? '';
          // 晴天
          if(sky == 'CLEAR_DAY' || sky == 'CLEAR_NIGHT' || sky == '') {
            onSucc(0);
            return;
          }
          // 多云或阴
          else if (sky == 'PARTLY_CLOUDY_DAY' || sky == 'PARTLY_CLOUDY_NIGHT' || sky == 'CLOUDY') {
            onSucc(1);
            return;
          }
          // 雨天
          else if (sky == 'WIND' || sky == 'HAZE' || sky == 'RAIN' || sky == 'SNOW') {
            onSucc(2);
            return;
          }
        }
    },
    onFail);

  }

  // 电站详情
  static void stationInfo(String statinId,StationInfoResponeseCallBack onSucc,HttpFailCallback onFail) {
   
    HttpHelper.getHttp(
      stationInfoPath, {
        'id': statinId ?? '',
      }, 
      (dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var resp = StationInfoResponse.fromJson(map);
        if(onSucc != null) onSucc(resp.data.station);
      }, 
      onFail);
  }

  // 关注电站 / 取消关注电站
  static void focusStation(String stationId,bool isFocus,HttpSuccMsgCallback onSucc,HttpFailCallback onFail) {
    
    // 参数
    Map<String,String> param = {};
    if(stationId != null && stationId.length > 0 ) {
      param['id'] = stationId;
    }
    if(isFocus != null) {
      param['isfocus'] = isFocus.toString();
    }
    HttpHelper.postHttp(focusStationPath, param,(dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var msg = map['msg'] ?? '';
        if(onSucc != null) onSucc(msg);
      }, 
      onFail);
  }

  // 广告栏
  static void banners(BannerResponseCallBack onSucc,HttpFailCallback onFail) {

    HttpHelper.getHttp(
      bannerListPath, null, 
      (dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var resp = BannerResponse.fromJson(map);
        if(onSucc != null) onSucc(resp.data.banner);
      }, 
      onFail);
  }

  // 省份列表
  static void provinces(ProvinceResponseCallBack onSucc,HttpFailCallback onFail) {

    HttpHelper.getHttp(
      provinceListPath, null, 
      (dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var resp = ProviceResponse.fromJson(map);
        if(onSucc != null) onSucc(resp.data.province);
      }, 
      onFail);
  }

  // 获取电站数量
  static void stationsCount(
    StationCountResponseCallBack onSucc,
    HttpFailCallback onFail) {

    HttpHelper.getHttp(
      stationListPath, {
      'page':'1',
      'rows':'1',
    },
    (dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var resp = StationsResponse.fromJson(map);
        if(onSucc != null) onSucc(resp.data?.total ?? 0);
      }, 
      onFail);
  }

  // 获取电站列表
  static void stationsList(
    StationsListResponseCallBack onSucc,
    HttpFailCallback onFail,
    {int page,int rows,String province,String keyword,bool isfocus}) {

    // 参数
    Map<String,String> param = {};
    // 页码
    if( page != null ) {
      if(page == 0) {
        param['page'] = '1';
      } else {
        param['page'] = page.toString();
      }
    }
    // 行数
    if( rows != null ) {
      if(rows == 0) {
        param['rows'] = '1';
      } else {
        param['rows'] = rows.toString();
      }
    }
    // 省份
    if( province != null ) {
      if(province.length > 0) {
        param['provincename'] = province;
      }
    }
    // 关键词
    if( keyword != null ) {
      if(keyword.length > 0) {
        param['keyword'] = keyword;
      }
    }
    // 关注
    if ( isfocus == true ) {
      param['isfocus'] = 'true';
    }

    HttpHelper.getHttp(stationListPath, param,(dynamic data,String msg) {
        var map  = data as Map<String,dynamic>;
        var resp = StationsResponse.fromJson(map);
        if(onSucc != null) onSucc(resp.data.stations,resp.data.total ?? 0);
      }, onFail);
    
  }

  // 更改登录密码
  static Future<HttpResult> modifyPswd(String oldWord, String newWord) async {
    if (oldWord == null || newWord == null) return null;
    if (oldWord.length == 0 || newWord.length == 0) return null;

    var secOld = LDEncrypt.encryptedMd5Pwd(oldWord);
    var secNew = LDEncrypt.encryptedMd5Pwd(newWord);

    debugPrint('🔑旧密码:' + secOld);
    debugPrint('🔑新密码:' + secNew);

    HttpResult result = HttpResult();
    result.success = false;
    result.msg = '请求错误.';

    Progresshud.showWithStatus('密码修改中...');

    try {
      final path = host + pswdPath;
      Response response = await Dio().post(
        path,
        options: Options(
          headers: {
            'Authorization': ShareManager.instance.token,
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'oldPassword': secOld,
          'newPassword': secNew,
        },
      );
      if (response.statusCode != 200) {
        Progresshud.dismiss();
        Progresshud.showSuccessWithStatus('修改失败');
        return result;
      }
      if (response.data is! Map) {
        Progresshud.dismiss();
        Progresshud.showSuccessWithStatus('修改失败');
        return result;
      }
      var map = response.data as Map<String, dynamic>;
      var pass = map['Success'];
      if (pass) {
        result.success = true;
        result.msg = '';
        Progresshud.dismiss();
        Progresshud.showSuccessWithStatus('修改成功');
      } else {
        result.success = false;
        result.msg = map['Msg'] ?? '';
        Progresshud.dismiss();
        Progresshud.showErrorWithStatus(result.msg);
      }
      return result;
    } catch (e) {
      Progresshud.dismiss();
      Progresshud.showErrorWithStatus('网络错误');
      print(e);
      return result;
    }
  }

  // Touch 外部环境
  static Future<String> touchNetWork() async {
    try {
      final path = 'http://www.baidu.com';
      Response response = await Dio().get(path);
      if (response.statusCode != 200) {
        return null;
      }
      return '';
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  // 获取远端版本信息接口(文件)
  static Future<Version> getAppVersionRemote() async {
    try {
      final path = host + filePath + fileVersionInfo;
      Response response = await Dio().get(path);
      if (response.statusCode != 200) {
        return null;
      }
      var map = response.data;
      var version = Version.fromJson(map);
      return version;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // 获取web路由接口(文件)
  static Future<PageConfig> getWebRoute() async {
    try {
      final path = host + filePath + fileWebRoute;
      Response response = await Dio().get(path);
      if (response.statusCode != 200) {
        return null;
      }
      var map = response.data;
      var webRoute = PageConfig.fromJson(map);
      return webRoute;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // 机组信息列表根据客户Id和电站Id
  // static Future<List<Terminal>> getTerminalsWithCustomIdAndStationId(String customId,String stationId) async {
  //   Progresshud.showWithStatus('正在加载...');
  //   try {
  //     final path = host + terminalInfoPath + '/' + customId + '/' + stationId;
  //     Response response = await Dio().get(path,
  //       options: Options(
  //         headers: {
  //           'Authorization':ShareManager.instance.token
  //         }
  //       )
  //     );
  //     if(response.statusCode != 200) {
  //       Progresshud.dismiss();
  //       Progresshud.showErrorWithStatus('请求失败...');
  //       return null;
  //     }
  //     if(response.data is! List){
  //       Progresshud.dismiss();
  //       Progresshud.showErrorWithStatus('请求失败...');
  //       return null;
  //     }
  //     List<Terminal> terminals = [];
  //     var list = response.data as List;
  //     for (var item in list) {
  //       Terminal terminal = Terminal.fromJson(item);
  //       terminals.add(terminal);
  //     }
  //     Progresshud.dismiss();
  //     return terminals;
  //     } catch (e) {
  //       handleError(e);
  //     }
  //     return null;
  // }

  // 登录获取 Token
  static Future<String> getLoginToken(String name, String pwd) async {
    try {
      final path = host + loginPath;
      Response response = await Dio().post(
        path,
        queryParameters: {
          'accountName': name,
          'accountPwd': LDEncrypt.encryptedMd5Pwd(pwd)
        },
      );
      if (response.statusCode != 200) {
        return '';
      }
      var map = response.data;
      bool loginSucc = map['Success'];
      if (loginSucc) {
        var authorizationList = response.headers['set-authorization'];
        if (authorizationList is List<String>) {
          List<String> list = authorizationList;
          var token = list.first;
          return token;
        }
        return '';
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }
}
