import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsa_app/config/app_theme.dart';
import 'package:hsa_app/event/app_event.dart';
import 'package:hsa_app/event/event_bird.dart';
import 'package:hsa_app/page/login/login_page.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/page/update/update_page.dart';
import 'package:hsa_app/page/update/update_task.dart';
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

  void addEventListener() {
    eventBird?.on(AppEvent.tokenExpiration, (_){
      showToast('会话过期,请重新登录');
      Future.delayed(Duration(seconds:1),(){
        pushToPageAndKill(context, LoginPage());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
        pages
      ..add(UpdatePage(context))
      ..add(UpdateTaskPage(context));
    addEventListener();
  }

  @override
  void dispose() {
    eventBird?.off(AppEvent.tokenExpiration);
    super.dispose();
  }

  // List<Widget> _buildScreens() {
  //   return [
  //     UpdatePage(),
  //     UpdateTask()
  //   ];
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: IndexedStack(
  //       index: _currentIndex,
  //       children: pages
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       unselectedFontSize: 13,
  //       selectedFontSize: 13,
  //       type: BottomNavigationBarType.fixed,
  //       backgroundColor: Color.fromRGBO(57,  117, 175, 1),
  //       items: [
  //         BottomNavigationBarItem(
  //             icon: SizedBox(
  //               height: 24,
  //               width: 24,
  //               child: _currentIndex == 0 ? 
  //               Image.asset('images/update/Update_DT_on.png') :
  //               Image.asset('images/update/Update_DT_off.png'),
  //             ),
  //             title: Text('终端',style: TextStyle(color: Colors.white))),
  //         BottomNavigationBarItem(
  //             icon: SizedBox(
  //               height: 24,
  //               width: 24,
  //               child: _currentIndex == 1 ?  
  //               Image.asset('images/update/Update_Order_on.png') :
  //               Image.asset('images/update/Update_Order_off.png'),
  //             ),
  //             title: Text('任务队列',style: TextStyle(color: Colors.white))),
  //       ],
  //       currentIndex: _currentIndex,
  //       onTap: (int i) {
  //         setState(() {
  //           _currentIndex = i;
  //         });
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   title: Text(_currentIndex == 0 ? '电站列表' : '任务队列',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: AppTheme().navigationAppBarFontSize)),
        // ),
        backgroundColor: Colors.transparent,
        body: PersistentTabView(
          backgroundColor: Colors.transparent,
          controller: _controller,
          items: _navBarsItems(),
          screens: pages,
          //showElevation: true,
          //navBarCurve: NavBarCurve.upperCorners,
          //confineInSafeArea: true,
          //handleAndroidBackButtonPress: true,
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
