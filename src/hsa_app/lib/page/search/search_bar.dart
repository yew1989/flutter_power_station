import 'package:flutter/material.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';

class SearchBar extends StatefulWidget {

  final bool isEditEnable;

  const SearchBar({Key key, this.isEditEnable}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  @override
  Widget build(BuildContext context) {

    final isEditEnable = widget?.isEditEnable ?? true;

    return SizedBox(height: 70,width: double.infinity,
     child: Container(
       margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
       decoration: BoxDecoration(
         border: Border.all(color: Colors.white38),
         borderRadius: BorderRadius.all(Radius.circular(35)),
       ),
       child: TextFormField(
         enabled: isEditEnable,
         maxLength: 20,
         autofocus: false,
         cursorColor: Colors.white,
         style: TextStyle(color: Colors.white,fontSize: 16),
         decoration: InputDecoration(
           icon: SizedBox(width: 12),
           counterText: "",
           border:InputBorder.none,
           hintText: '请输入电站中文名或拼音首字母',
           labelStyle: TextStyle(color: Colors.white,fontSize: 16),
           hintStyle: TextStyle(color: Colors.white30,fontSize: 16),
         ),
         onChanged:(String text){
          EventBird().emit(AppEvent.searchKeyWord,text);
         },
       ),
     )
    );;
  }
}