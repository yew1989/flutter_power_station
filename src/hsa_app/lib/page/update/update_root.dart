import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/update/update_page.dart';
import 'package:hsa_app/page/update/update_task_list.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class UpdateRootPage extends StatefulWidget {

  @override
  _UpdateRootPageState createState() => _UpdateRootPageState();
}

class _UpdateRootPageState extends State<UpdateRootPage> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;
  List<Widget> pages = new List();
  PersistentTabController _controller;


  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
        pages
      ..add(UpdatePage(context))
      ..add(UpdateTaskPage(context));
    
    //确认升级后跳转到任务队列
    eventBird?.on('TaskReady', (arg) { 
      setState(() {
        _controller.jumpToTab(1);
      });
    });
  }

  @override
  void dispose() {
    eventBird?.off(AppEvent.tokenExpiration);
    eventBird?.off('TaskReady');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PersistentTabView(
          backgroundColor: Colors.transparent,
          controller: _controller,
          items: _navBarsItems(),
          screens: pages,
          iconSize: 26.0,
          navBarStyle: NavBarStyle.style1, 
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        )
      )
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SizedBox(
          height: 24,
          width: 24,
          child: _currentIndex == 0 ? 
          Image.asset('images/update/Update_DT_on.png') :
          Image.asset('images/update/Update_DT_off.png'),
        ),
        title: '终端',
        activeColor: Colors.white,
        inactiveColor: Colors.transparent,
      ),
      PersistentBottomNavBarItem(
        icon: SizedBox(
          height: 24,
          width: 24,
          child: _currentIndex == 1 ?  
          Image.asset('images/update/Update_Order_on.png') :
          Image.asset('images/update/Update_Order_off.png'),
        ),
        title: '任务队列',
          activeColor: Colors.white,
          inactiveColor: Colors.transparent,
      ),
    ];
  }
}
