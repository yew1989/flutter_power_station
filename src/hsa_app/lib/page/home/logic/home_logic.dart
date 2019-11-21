import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/file/cloud_file.dart';
import 'package:hsa_app/model/station.dart';

class HomeLogic {
  // 数据组包
  static List<StationSection> packGroups(List<Station> rawStations) {
    var sections = buildListSection(rawStations);
    var temp = buildListAll(rawStations, sections);
    temp = addColloctionsToFirst(temp);
    return temp;
  }

  static List<StationSection> addColloctionsToFirst(List<StationSection> sections) {
    var temp = sections;
    StationSection first = StationSection();
    first.sectionName = '特别关心';
    first.stations = [];
    temp.insert(0, first);
    return temp;
  }

  static List<StationSection> buildListSection(List<Station> originList) {
    List<StationSection> groups = [];
    for (var item in originList) {
      var areaName = item.areaName;
      var isExist = checkIsExist(areaName, groups);
      if (isExist == false) {
        StationSection group = StationSection();
        group.sectionName = areaName;
        group.stations = [];
        groups.add(group);
      }
    }
    return groups;
  }

  static List<StationSection> buildListAll(
      List<Station> originList, List<StationSection> sectionGroup) {
    List<StationSection> groups = sectionGroup;
    for (int i = 0; i < originList.length; i++) {
      var item = originList[i];
      var areaName = item.areaName;
      var groupIndx = findStationGroupIndex(areaName, sectionGroup);
      var group = sectionGroup[groupIndx];
      group.stations.add(item);
    }
    return groups;
  }

  // 查找地区名称在sections中的位置
  static int findStationGroupIndex(String sectionName, List<StationSection> groups) {
    var res = -1;
    for (int i = 0; i < groups.length; i++) {
      var item = groups[i];
      var areaName = item.sectionName;
      if (areaName.compareTo(sectionName) == 0) {
        res = i;
        break;
      }
    }
    return res;
  }

  // 检查地区是否存在
  static bool checkIsExist(String sectionName, List<StationSection> stations) {
    var res = false;
    for (var item in stations) {
      if (item.sectionName.compareTo(sectionName) == 0) {
        res = true;
        break;
      }
    }
    return res;
  }

  // 从 TreeNode中获取到所有电站列表
  static List<Station> buildStationsFromTreeNode(List<Station> devices) {
    List<Station> stations = [];
    for (var device in devices) {
      var name = device.stationName;
      // 若不存在就添加一个
      if (checkIsExistStationName(name, stations) == false) {
        stations.add(device);
      }
      // 存在就判断是否链接,如果有一个链接就设置成 isConnected
      else {
        if (device.isCollected == true) {
          var index = indexOfStation(name, stations);
          var station = stations[index];
          station.isConnected = true;
        }
      }
    }
    return stations;
  }

  // 检查是否存在重复的station
  static bool checkIsExistStationName(String stationName, List<Station> devices) {
    var res = false;
    for (var device in devices) {
      if (device.stationName.compareTo(stationName) == 0) {
        res = true;
        break;
      }
    }
    return res;
  }

  // 返回name对应的station下标
  static int indexOfStation(String stationName, List<Station> stations) {
    var res = -1;
    for (int i = 0; i < stations.length; i++) {
      var item = stations[i];
      var areaName = item.stationName;
      if (areaName.compareTo(stationName) == 0) {
        res = i;
        break;
      }
    }
    return res;
  }

  // 已分组的电站 根据是否被收藏加入到特别关心
  static List<StationSection> syncStationSection(List<StationSection> sections) {
    List<StationSection> res = sections;
    StationSection first = res.first;
    List<Station> temp = []; 
    for (int i = 1; i < res.length; i++) {
      var sec = res[i];
      for (int j = 0; j < sec.stations.length; j++) {
        var station = sec.stations[j];
        var isCollected = station.isCollected;
        if (isCollected == true) {
          temp.add(station);
        }
      }
    }
    first.stations = temp;
    return res;
  }

   static CloudFile makeCloudFile(List<StationSection> sections) {
    CloudFile file = CloudFile();
    file.collection = CloudCollection();
    List<String> temp = [];

    for (int i = 1; i < sections.length; i++) {
      var sec = sections[i];
      for (int j = 0; j < sec.stations.length; j++) {
        var station = sec.stations[j];
        var isCollected = station.isCollected;
        if (isCollected == true) {
          var id = station.hydropowerStationCodeID;
          temp.add(id);
        }
      }
    }
    file.collection.stations = temp;
    return file;
  }

    // 上传至服务器配置文件
  static void writeToServer(CloudFile file) async {
    var jsonMap = file.toJson();
    var jsonStr = json.encode(jsonMap);
    bool isOK  = await API.uploadFileJson(jsonStr);
    debugPrint('上传' + (isOK ? '成功' : '失败') );
    debugPrint(jsonStr);
   }

  // 从服务器上下载配置文件
  static Future<CloudFile> readFromServer() async {
      var jsonStr = await API.downloadFileJson();
      Map<String, dynamic> jsonMap = json.decode(jsonStr);
      var file = CloudFile.fromJson(jsonMap);
      return file;
  }


  // 从服务器上下载最新的收藏文件
  static Future<List<StationSection>> downloadCollectRecordFileFromServerAndAddToUI(List<StationSection> sections) async {
    var file = await HomeLogic.readFromServer();
    if (file == null) return null;
    var idList = file.collection.stations;
    for (int k = 0; k < idList.length; k++) {
      var id = idList[k];
      for (int i = 1; i < sections.length; i++) {
        var sec = sections[i];
        for (int j = 0; j < sec.stations.length; j++) {
          var station = sec.stations[j];
          if (id.compareTo(station.hydropowerStationCodeID) == 0) {
            station.isCollected = true;
          }
        }
      }
    }
    return HomeLogic.syncStationSection(sections);
  }

}