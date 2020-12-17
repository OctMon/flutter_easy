import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easy/flutter_easy.dart';

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

String baseDefaultRefreshFooterNoMoreText = "-- 没有更多了 --";

/// 统一上拉加载
Footer baseRefreshFooter(
        {bool enableInfiniteLoad: true,
        bool enableHapticFeedback: true,
        String loadText: '上拉加载更多',
        String loadReadyText: '释放加载',
        String loadingText: '正在加载',
        String loadedText: '加载完成',
        String loadFailedText: '加载失败',
        String noMoreText,
        String infoText: '更新于 %T',
        Color textColor: colorWithHex3,
        Color infoColor: colorWithHex6}) =>
    CustomFooter(
      enableInfiniteLoad: enableInfiniteLoad,
      enableHapticFeedback: enableHapticFeedback,
      footerBuilder: (BuildContext context,
          LoadMode loadState,
          double pulledExtent,
          double loadTriggerPullDistance,
          double loadIndicatorExtent,
          AxisDirection axisDirection,
          bool float,
          Duration completeDuration,
          bool enableInfiniteLoad,
          bool success,
          bool noMore) {
        if (noMore) {
          return Container(
            alignment: Alignment.center,
            child: BaseText(
              noMoreText ?? baseDefaultRefreshFooterNoMoreText,
              style: TextStyle(color: colorWithHex9),
            ),
          );
        }
        return ClassicalFooter(
          enableInfiniteLoad: true,
          loadText: loadedText,
          loadReadyText: loadReadyText,
          loadingText: loadingText,
          loadedText: loadedText,
          loadFailedText: loadFailedText,
          infoText: infoText,
          textColor: textColor,
          infoColor: infoColor,
        ).contentBuilder(
            context,
            loadState,
            pulledExtent,
            loadTriggerPullDistance,
            loadIndicatorExtent,
            axisDirection,
            float,
            completeDuration,
            enableInfiniteLoad,
            success,
            noMore);
      },
    );

/// 统一上拉加载
Footer baseDefaultRefreshFooter = baseRefreshFooter();

class BaseRefresh extends StatelessWidget {
  final EasyRefreshController controller;
  final ScrollController scrollController;
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
      this.scrollController,
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
      this.scrollController,
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
          scrollController: scrollController,
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
        scrollController: scrollController,
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
