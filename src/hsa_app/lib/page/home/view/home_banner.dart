import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hsa_app/debug/model/banner.dart';
import 'package:hsa_app/page/framework/webview_page.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/cache_manager.dart';

class HomeBanner extends StatefulWidget {
  final List<BannerModel> items;
  HomeBanner(this.items);
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {

  //加载缓存设置
  BaseCacheManager _baseCacheManager = LEADCacheManager();

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
        final link = item?.linkUrl?? '';
        return GestureDetector(
          child: CachedNetworkImage(
            cacheManager: _baseCacheManager,
            imageUrl: img,
            //placeholder: (context, url) => CircularProgressIndicator(),//动画效果
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          
          
          
          //Image.network(img,fit: BoxFit.fill),
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