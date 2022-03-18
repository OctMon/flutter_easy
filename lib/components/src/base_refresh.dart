import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef BaseRefreshController = RefreshController;
typedef BaseRefreshLocalizations = RefreshLocalizations;

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
      {Key? key,
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
      : this.slivers = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      scrollController: scrollController,
      header: header,
      footer: footer,
      enablePullDown: onRefresh != null,
      enablePullUp: onLoading != null,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
