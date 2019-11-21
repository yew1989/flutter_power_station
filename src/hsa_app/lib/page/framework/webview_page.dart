import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hsa_app/theme/theme_gradient_background.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final bool noNavBar;

  WebViewPage(this.title, this.url, {this.noNavBar});
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController webViewController;
  
  // 从js中解析数据
  void parseFromJS(String js,BuildContext context) {
    // H5 发送 点击导航栏返回按键事件
    // JSBridge.postMessage('navBack');
    if(js.compareTo('navBack') == 0) {
      // 返回页面
      Navigator.of(context).pop();
      return;
    }
    return;
  }

  // 主动调用 js桥
  void evaluateJavascript(Map<String, dynamic> map) {
    if (map == null) return;
    var js = json.encode(map);
    webViewController.evaluateJavascript('callJS(' + js + ')');
  }

  // 网页完全加载标识
  var isFinish = false;

  // 隐藏 loading
  void hideLoading() async{
    Future.delayed(Duration(milliseconds: 1000),(){
     setState(() {
     isFinish = true;
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 渐变色背景
        ThemeGradientBackground(),
        // 实际 webview位置
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: widget.noNavBar == true
                ? null
                : AppBar(
                    title: Text(widget.title ?? ''),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                  ),
            body: Center(
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: isFinish ? 1 : 0,
                      child: WebView(
                        onWebViewCreated: (wbc) {
                          webViewController = wbc;
                          webViewController.clearCache();
                        },
                        onPageFinished: (url) {
                          debugPrint('WEBVIEW:' + url);
                          hideLoading();
                        },
                        initialUrl: widget.url ?? '',
                        javascriptMode: JavascriptMode.unrestricted,
                        javascriptChannels: [
                          JavascriptChannel(
                            name: 'JSBridge',
                            onMessageReceived: (JavascriptMessage message) {
                              var msg = message.message;
                              parseFromJS(msg,context);
                            },
                          ),
                        ].toSet(),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: isFinish ? 0 : 1,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                            SizedBox(height: 20),
                            Text('加载中',style: TextStyle(color: Colors.white70,fontSize: 16)),
                            Text('请稍后',style: TextStyle(color: Colors.white38,fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ]
      );
  }
}
