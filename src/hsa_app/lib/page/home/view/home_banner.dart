import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  
  // 广告栏
  List<String> bannerList = [
    // 'http://www.fjlead.com/temp/picFim1.jpg',
    // 'http://www.fjlead.com/temp/picFim3.jpg',
    // 'http://www.fjlead.com/temp/picFim1.jpg',
    // 'http://www.fjlead.com/temp/picFim3.jpg',
    // 'http://www.fjlead.com/temp/picFim2.jpg',
    '','','','','',
  ];

  @override
  Widget build(BuildContext context) {
      return BannerSwiper(
      selectorWidget: SizedBox(
        height: 12,
        width: 32,
        child: Image.asset('images/common/Common_list_control1_btn.png'),
      ),
      normalWidget: SizedBox(
        height: 12,
        width: 32,
        child: Image.asset('images/common/Common_list_control2_btn.png'),
      ),
      spaceMode: false,
      height: 108,
      width: 54,
      length: bannerList.length,
      getwidget: (index) {
        return GestureDetector(
          child: Image.network(bannerList[index % bannerList.length],fit: BoxFit.fill),onTap: () {},
        );
      },
    );
  }
}