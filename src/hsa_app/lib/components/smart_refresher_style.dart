import 'package:pull_to_refresh/pull_to_refresh.dart';


ClassicHeader appRefreshHeader() {
  return ClassicHeader(
    idleText: '下拉获取最新数据',
    failedText: '数据更新失败',
    refreshingText: '正在获取数据',
    releaseText: '松手加载最新数据',
    completeText: '数据更新成功',
  );
}

ClassicFooter appRefreshFooter() {
  return ClassicFooter(
    noDataText: '我是有底线的',
    failedText: '数据获取失败',
    idleText: '上拉获取更多数据',
    loadingText: '正在获取数据',
    canLoadingText: '取消上拉获取更多数据',
  );
}
