import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hsa_app/model/station.dart';
import 'package:hsa_app/page/home/view/home_station_tile_nostar.dart';

class SearchPage extends StatefulWidget {
  final List<Station> rawStations;

  SearchPage({Key key, this.rawStations}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchCtrl = TextEditingController();
  List<Station> currentStations = [];

  @override
  void initState() {
    currentStations = widget.rawStations;
    super.initState();
  }

  void onChangedSearchField(String word) {
    currentStations = filtPinYinWordOrChinese(word, widget.rawStations);
    setState(() {
      
    });
  }

  // 筛选中文
  List<Station> filtChineseWord(String chinese,List<Station> rawStations) {
    chinese = chinese ?? '';
    List<Station> temp = [];
    for(int i = 0 ; i < rawStations.length ; i ++) {
      var everyStaion = rawStations[i];
      var name = everyStaion.stationName;
      if(name.contains(chinese)) {
        temp.add(everyStaion);
      }
    }
    return temp;
  }

  // 筛选拼音
  List<Station> filtPinYinWord(String pinyin,List<Station> rawStations) {
    pinyin = pinyin ?? '';
    List<Station> temp = [];
    for(int i = 0 ; i < rawStations.length ; i ++) {
      var everyStaion = rawStations[i];
      var name = everyStaion.stationNamePinYin;
      if(name.contains(pinyin)) {
        temp.add(everyStaion);
      }
    }
    return temp;
  }

  // 同时筛选拼音和中文
    List<Station> filtPinYinWordOrChinese(String word,List<Station> rawStations) {
    word = word ?? '';
    List<Station> temp = [];
    for(int i = 0 ; i < rawStations.length ; i ++) {
      var everyStaion = rawStations[i];
      var pinyin = everyStaion.stationNamePinYin;
      var name = everyStaion.stationName;
      if(name.contains(word)) {
        temp.add(everyStaion);
      }
      else if(pinyin.contains(word)) {
        temp.add(everyStaion);
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 12),
                    //搜索框
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CupertinoTextField(
                                    decoration: BoxDecoration(
                                      border: null,
                                    ),
                                    controller: searchCtrl,
                                    autofocus: true,
                                    prefix: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    placeholder: '请输入电站名或拼音',
                                    clearButtonMode: OverlayVisibilityMode.editing,
                                    keyboardType: TextInputType.text,
                                    onChanged: (changeText){
                                      onChangedSearchField(changeText);
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      onChangedSearchField(searchCtrl.text);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Text('取消',style: TextStyle(fontSize: 16, color: Colors.greenAccent[700]),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),


              Expanded(
                child: ListView.builder(
                  itemCount: currentStations?.length ?? 0,
                  itemBuilder: (ctx,i) => HomeStationTileNoStar(data:currentStations[i]),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

}
