import 'package:flutter/material.dart';
import 'package:hsa_app/api/api.dart';
import 'package:hsa_app/config/config.dart';
import 'package:hsa_app/model/station_old.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController webViewController;
  var isFinish = false;

  List<StationOld> originStations = [];
  List<StationOld> currentStations = [];

  // 分组电站
  List<StatinGroup> groups = [];

  String keyWord = '';
  TextEditingController searchEditController = TextEditingController();

  Widget stationTile(StationOld station) {
    return ListTile(
      onTap: () {
        // pushToPage(context, StationPage('${station.stationName}'));
      },
      title: Container(
        height: 60,
        child: Container(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10),
                      Icon(
                        Icons.device_hub,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 10),
                      Text('${station.stationName}',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.notifications_active,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 30, child: Center(child: Text('25'))),
                SizedBox(width: 28),
                SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    debugPrint('initHomePage');
    super.initState();
    loadStations();
    keyWord = '';
  }

  void loadStations() async {
    var datas = await API.getAllStations();
    if (datas == null) return;
    setState(() {
      originStations = datas;
      currentStations = originStations;
      packGroups();
    });
  }

  void packGroups() {
    var sections = buildListSection(currentStations);
    var groups = buildListAll(currentStations, sections);
    this.groups = groups;
  }

  @override
  Widget build(BuildContext context) {
    var host = AppConfig.getInstance().webHost;
    var pageItem = AppConfig.getInstance().pageBundle.banner;
    var url = host + pageItem.route ?? AppConfig.getInstance().deadLink;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 240,
              child: Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: url,
                    onPageFinished: (url) {
                      debugPrint('WEBVIEW:' + url);
                      isFinish = true;
                      setState(() {});
                    },
                    onWebViewCreated: (wbc) {
                      webViewController = wbc;
                      wbc.clearCache();
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                  Opacity(
                    opacity: isFinish ? 0 : 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('加载中',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16)),
                          Text('请稍后',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          controller: searchEditController,
                          decoration: InputDecoration(
                              hintText: '请输入电站名称',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child:
                            Text('搜索', style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          keyWord = searchEditController.text ?? '';
                          onTapSearch(keyWord);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),

            // 平铺电站
            /*
            Expanded(
              child: ListView.builder(
                itemCount: currentStations?.length ?? 0,
                itemBuilder: (_, idx) => stationTile(currentStations[idx]),
              ),
            ),
            */

            // 分组列表
            Expanded(
              child: ListView.builder(
                itemCount: groups?.length ?? 0,
                itemBuilder: (_, i) => expandTile(groups[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget expandTile(StatinGroup group) {
    var secName = group?.secionName ?? '';
    if (secName.length == 0) secName = '未分类';
    var cnt = group?.stations?.length ?? 0;
    secName += '  ($cnt)';
    return Container(
      child: ExpansionTile(
        leading: Icon(Icons.location_city,
            size: 30, color: Theme.of(context).primaryColor),
        title: Text('$secName'),
        children: group.stations.map((station) {
          return stationTile(station);
        }).toList(),
      ),
    );
  }

  void onTapSearch(String keyWord) {
    debugPrint('搜索:' + keyWord);
    setState(() {
      currentStations = search(keyWord, originStations);
      packGroups();
    });
  }

  List<StationOld> search(String keyWord, List<StationOld> originList) {
    List<StationOld> res = [];
    if (keyWord.length == 0) return originList;
    for (var item in originList) {
      var isFinded = item.stationName.contains(keyWord);
      if (isFinded) {
        res.add(item);
      }
    }
    return res;
  }

  List<StatinGroup> buildListSection(List<StationOld> originList) {
    List<StatinGroup> groups = [];
    for (var item in originList) {
      var areaName = item.areaName;
      var isExist = checkIsExist(areaName, groups);
      if (isExist == false) {
        StatinGroup group = StatinGroup();
        group.secionName = areaName;
        group.stations = [];
        groups.add(group);
      }
    }
    return groups;
  }

  List<StatinGroup> buildListAll(
      List<StationOld> originList, List<StatinGroup> sectionGroup) {
    List<StatinGroup> groups = sectionGroup;
    for (int i = 0; i < originList.length; i++) {
      var item = originList[i];
      var areaName = item.areaName;
      var groupIndx = findStationGroupIndex(areaName, sectionGroup);
      var group = sectionGroup[groupIndx];
      group.stations.add(item);
    }
    return groups;
  }

  int findStationGroupIndex(String sectionName, List<StatinGroup> groups) {
    var res = -1;
    for (int i = 0; i < groups.length; i++) {
      var item = groups[i];
      var areaName = item.secionName;
      if (areaName.compareTo(sectionName) == 0) {
        res = i;
        break;
      }
    }
    return res;
  }

  bool checkIsExist(String sectionName, List<StatinGroup> stations) {
    var res = false;
    for (var item in stations) {
      if (item.secionName.compareTo(sectionName) == 0) {
        res = true;
        break;
      }
    }
    return res;
  }
}
