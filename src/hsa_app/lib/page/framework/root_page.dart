import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/page/home/home_page.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/page/mine/mine_page.dart';
import 'package:hsa_app/util/public_tool.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> pages = new List();

  void addEventListener() {
    var bus = EventTaxiImpl.singleton();
    bus.registerTo<TokenExpireEvent>().listen((_){
      // showErrorHud(context,'会话过期,请重新登录');
      showToast('会话过期,请重新登录');
      Future.delayed(Duration(seconds:1),(){
        pushToPageAndKill(context, LoginPage());
      });
    });
  }

  @override
  void initState() {
    super.initState();
        pages
      ..add(HomePage())
      ..add(MinePage());
    addEventListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 13,
        selectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(57,  117, 175, 1),
        items: [
          BottomNavigationBarItem(
              icon: SizedBox(
                height: 24,
                width: 24,
                child: _currentIndex == 0 ? 
                Image.asset('images/home/Home_on_btn.png') :
                Image.asset('images/home/Home_off_btn.png'),
              ),
              title: Text('首页',style: TextStyle(color: Colors.white))),
          BottomNavigationBarItem(
              icon: SizedBox(
                height: 24,
                width: 24,
                child: _currentIndex == 1 ?  
                Image.asset('images/home/Home_my_on_btn.png') :
                Image.asset('images/home/Home_my_off_btn.png'),
              ),
              title: Text('我的',style: TextStyle(color: Colors.white))),
        ],
        currentIndex: _currentIndex,
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}
