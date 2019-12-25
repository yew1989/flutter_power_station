import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:hsa_app/model/banner_item.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/components/public_tool.dart';

class HomeBanner extends StatefulWidget {
  final List<BannerItem> items;
  HomeBanner(this.items);
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {

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
      length: widget.items?.length ?? 0,
      getwidget: (index) {
        final item = widget.items[index % widget.items.length];
        final img = item?.img ?? '';
        final link = item?.link?? '';
        return GestureDetector(
          child: Image.network(img,fit: BoxFit.fill),
          onTap: () {
            if(link.length > 0) {
              pushToPage(context, WebViewPage('智能电站', link,description: '展位详情'));
            }
          },
        );
      },
    );
  }
}