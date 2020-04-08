import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../utils/color_util.dart';

export 'package:flutter_easyrefresh/easy_refresh.dart'
    show EasyRefreshController;

/// 统一下拉刷新
Header baseDefaultRefreshHeader = ClassicalHeader(
  enableInfiniteRefresh: false,
  refreshText: '下拉刷新',
  refreshReadyText: '释放刷新',
  refreshingText: '正在刷新',
  refreshedText: '刷新完成',
  refreshFailedText: '刷新失败',
  noMoreText: '没有更多',
  infoText: '更新于 %T',
  textColor: colorWithHex3,
  infoColor: colorWithHex6,
);

/// 统一上拉加载
Footer baseDefaultRefreshFooter = ClassicalFooter(
  enableInfiniteLoad: true,
  loadText: '上拉加载更多',
  loadReadyText: '释放加载',
  loadingText: '正在加载',
  loadedText: '加载完成',
  loadFailedText: '加载失败',
  noMoreText: '没有更多',
  infoText: '更新于 %T',
  textColor: colorWithHex3,
  infoColor: colorWithHex6,
);

class BaseRefresh extends StatelessWidget {
  final EasyRefreshController controller;
  final Header header;
  final bool firstRefresh;
  final Widget firstRefreshWidget;
  final OnRefreshCallback onRefresh;
  final Footer footer;
  final OnLoadCallback onLoad;
  final Widget emptyWidget;
  final List<Widget> slivers;
  final Widget child;

  const BaseRefresh(
      {Key key,
      this.controller,
      this.header,
      this.firstRefresh,
      this.firstRefreshWidget,
      this.onRefresh,
      this.footer,
      this.onLoad,
      this.emptyWidget,
      this.child})
      : this.slivers = null,
        super(key: key);

  const BaseRefresh.custom(
      {Key key,
      this.controller,
      this.header,
      this.firstRefresh,
      this.firstRefreshWidget,
      this.onRefresh,
      this.footer,
      this.onLoad,
      this.emptyWidget,
      this.slivers})
      : this.child = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return MediaQuery(
        data: MediaQueryData(textScaleFactor: 1),
        child: EasyRefresh(
          controller: controller,
          header:
              header ?? (onRefresh != null ? baseDefaultRefreshHeader : null),
          footer: footer ?? (onLoad != null ? baseDefaultRefreshFooter : null),
          firstRefresh: firstRefresh,
          firstRefreshWidget: firstRefreshWidget,
          emptyWidget: emptyWidget,
          onRefresh: onRefresh,
          onLoad: onLoad,
          child: child,
        ),
      );
    }
    return MediaQuery(
      data: MediaQueryData(textScaleFactor: 1),
      child: EasyRefresh.custom(
        controller: controller,
        header: header ?? (onRefresh != null ? baseDefaultRefreshHeader : null),
        footer: footer ?? (onLoad != null ? baseDefaultRefreshFooter : null),
        firstRefresh: firstRefresh,
        firstRefreshWidget: firstRefreshWidget,
        emptyWidget: emptyWidget,
        onRefresh: onRefresh,
        onLoad: onLoad,
        slivers: slivers,
      ),
    );
  }
}
