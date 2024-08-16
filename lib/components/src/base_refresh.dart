import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_sliver_expanded.dart';

typedef BaseSmartRefresher = SmartRefresher;
typedef BaseRefreshController = RefreshController;
typedef BaseRefreshLocalizations = RefreshLocalizations;
typedef BaseRefreshConfiguration = RefreshConfiguration;
typedef BaseCustomFooter = CustomFooter;

class BaseRefresh extends StatelessWidget {
  final BaseRefreshController controller;
  final ScrollController? scrollController;
  final Widget? header;
  final bool firstRefresh;
  final Widget? firstRefreshWidget;
  final VoidCallback? onRefresh;
  final Widget? footer;
  final VoidCallback? onLoading;
  final Widget? emptyWidget;
  final List<Widget>? slivers;
  final Widget? child;

  const BaseRefresh(
      {super.key,
      required this.controller,
      this.scrollController,
      this.header,
      this.firstRefresh = false,
      this.firstRefreshWidget,
      this.onRefresh,
      this.footer,
      this.onLoading,
      this.emptyWidget,
      this.child})
      : this.slivers = null;

  @override
  Widget build(BuildContext context) {
    final configuration = BaseRefreshConfiguration.of(context);
    return BaseSmartRefresher(
      controller: controller,
      scrollController: scrollController,
      header: header ??
          (configuration?.headerBuilder != null
              ? configuration?.headerBuilder!()
              : null) ??
          ClassicHeader(),
      footer: footer,
      enablePullDown: onRefresh != null,
      enablePullUp: onLoading != null,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }

  static message(
      {required BaseRefreshController controller,
      ScrollController? scrollController,
      VoidCallback? onLoading,
      Widget? footer,
      required Widget sliver}) {
    return BaseSmartRefresher(
      enablePullDown: false,
      onLoading: onLoading,
      footer: footer ?? ClassicFooter(),
      enablePullUp: true,
      controller: controller,
      child: Scrollable(
        controller: scrollController,
        axisDirection: AxisDirection.up,
        viewportBuilder: (context, offset) {
          return BaseExpandedViewport(
            offset: offset,
            axisDirection: AxisDirection.up,
            slivers: <Widget>[
              BaseSliverExpanded(),
              sliver,
            ],
          );
        },
      ),
    );
  }
}
