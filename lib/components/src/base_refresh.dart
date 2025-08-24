import 'package:flutter/material.dart';

import '../../utils/src/vendor_util.dart';
import 'base_sliver_expanded.dart';

String? baseDefaultHeaderDragText;
String? baseDefaultHeaderArmedText;
String? baseDefaultHeaderReadyText;
String? baseDefaultHeaderProcessingText;
String? baseDefaultHeaderProcessedText;
String? baseDefaultHeaderNoMoreText;
String? baseDefaultHeaderFailedText;
String? baseDefaultHeaderMessageText;

String? baseDefaultFooterDragText;
String? baseDefaultFooterArmedText;
String? baseDefaultFooterReadyText;
String? baseDefaultFooterProcessingText;
String? baseDefaultFooterProcessedText;
String? baseDefaultFooterNoMoreText;
String? baseDefaultFooterFailedText;
String? baseDefaultFooterMessageText;

bool baseDefaultHeaderShowText = true;
bool baseDefaultHeaderShowMessage = false;
bool baseDefaultFooterShowText = true;
bool baseDefaultFooterShowMessage = false;

Widget? baseDefaultSucceededIcon;
Widget? baseDefaultFailedIcon;
Widget? baseDefaultNoMoreIcon;

class BaseRefresh extends StatelessWidget {
  final BaseRefreshController? controller;
  final ScrollController? scrollController;
  final BaseHeader? header;
  final VoidCallback? onRefresh;
  final BaseFooter? footer;
  final VoidCallback? onLoad;
  final List<Widget>? slivers;
  final Widget? child;

  const BaseRefresh(
      {super.key,
      this.controller,
      this.scrollController,
      this.header,
      this.onRefresh,
      this.footer,
      this.onLoad,
      this.child})
      : this.slivers = null;

  static BaseHeader defaultHeader({
    bool safeArea = true,
    bool hapticFeedback = false,
    BaseIndicatorPosition position = BaseIndicatorPosition.above,
    bool clamping = false,
    String? dragText,
    String? armedText,
    String? readyText,
    String? processingText,
    String? processedText,
    String? noMoreText,
    String? failedText,
    String? messageText,
    bool? showText,
    bool? showMessage,
    TextStyle? textStyle,
    TextStyle? messageStyle,
    Widget? succeededIcon,
    Widget? failedIcon,
    Widget? noMoreIcon,
  }) {
    return BaseClassicHeader(
      safeArea: safeArea,
      hapticFeedback: hapticFeedback,
      position: position,
      clamping: clamping,
      dragText: dragText ?? baseDefaultHeaderDragText,
      armedText: armedText ?? baseDefaultHeaderDragText,
      readyText: readyText ?? baseDefaultHeaderDragText,
      processingText: processingText ?? baseDefaultHeaderProcessingText,
      processedText: processedText ?? baseDefaultHeaderProcessedText,
      noMoreText: noMoreText ?? baseDefaultHeaderNoMoreText,
      failedText: failedText ?? baseDefaultHeaderFailedText,
      messageText: messageText ?? baseDefaultHeaderMessageText,
      showText: showText ?? baseDefaultHeaderShowText,
      showMessage: showMessage ?? baseDefaultHeaderShowMessage,
      textStyle: textStyle,
      messageStyle: messageStyle,
      succeededIcon: succeededIcon ?? baseDefaultSucceededIcon,
      failedIcon: failedIcon ?? baseDefaultFailedIcon,
      noMoreIcon: noMoreIcon ?? baseDefaultNoMoreIcon,
    );
  }

  static BaseFooter defaultFooter({
    bool safeArea = true,
    bool hapticFeedback = false,
    BaseIndicatorPosition position = BaseIndicatorPosition.above,
    bool clamping = false,
    String? dragText,
    String? armedText,
    String? readyText,
    String? processingText,
    String? processedText,
    String? noMoreText,
    String? failedText,
    String? messageText,
    bool? showText,
    bool? showMessage,
    TextStyle? textStyle,
    TextStyle? messageStyle,
    Widget? succeededIcon,
    Widget? failedIcon,
    Widget? noMoreIcon,
  }) {
    return BaseClassicFooter(
      safeArea: safeArea,
      hapticFeedback: hapticFeedback,
      position: position,
      clamping: clamping,
      dragText: dragText ?? baseDefaultFooterDragText,
      armedText: armedText ?? baseDefaultFooterArmedText,
      readyText: readyText ?? baseDefaultFooterReadyText,
      processingText: processingText ?? baseDefaultFooterProcessingText,
      processedText: processedText ?? baseDefaultFooterProcessedText,
      noMoreText: noMoreText ?? baseDefaultFooterNoMoreText,
      failedText: failedText ?? baseDefaultFooterFailedText,
      messageText: messageText ?? baseDefaultFooterMessageText,
      showText: showText ?? baseDefaultFooterShowText,
      showMessage: showMessage ?? baseDefaultFooterShowMessage,
      textStyle: textStyle,
      messageStyle: messageStyle,
      succeededIcon: succeededIcon ?? baseDefaultSucceededIcon,
      failedIcon: failedIcon ?? baseDefaultFailedIcon,
      noMoreIcon: noMoreIcon ?? baseDefaultNoMoreIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseEasyRefresher(
      controller: controller,
      scrollController: scrollController,
      header: header ?? BaseRefresh.defaultHeader(),
      footer: footer ?? BaseRefresh.defaultFooter(),
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }

  static BaseEasyRefresher builder({
    BaseChildBuilder? childBuilder,
    BaseRefreshController? controller,
    ScrollController? scrollController,
    BaseHeader? header,
    VoidCallback? onRefresh,
    BaseFooter? footer,
    VoidCallback? onLoad,
  }) {
    return BaseEasyRefresher.builder(
      childBuilder: childBuilder,
      controller: controller,
      scrollController: scrollController,
      header: header ?? BaseRefresh.defaultHeader(),
      footer: footer ?? BaseRefresh.defaultFooter(),
      onRefresh: onRefresh,
      onLoad: onLoad,
    );
  }

  static BaseRefresh message(
      {required BaseRefreshController controller,
      ScrollController? scrollController,
      VoidCallback? onLoad,
      BaseFooter? footer,
      required Widget sliver}) {
    return BaseRefresh(
      onLoad: onLoad,
      footer: footer,
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
