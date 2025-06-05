import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

typedef BaseComputeResult<T> = void Function(T state, RxStatus status);

typedef BaseStateMixin<T> = StateMixin<T>;

/// 判断应用程序处于前台
bool appIsForeground = true;

AppLifecycleState appLifecycleState = AppLifecycleState.resumed;

abstract class BaseStateLifeCycleController extends FullLifeCycleController
    with FullLifeCycleMixin {
  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    logDebug("生命周期更新: $state");
    appLifecycleState = state;
    switch (state) {
      case AppLifecycleState.resumed:
        appIsForeground = true;
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        appIsForeground = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void onResumed();

  void onPaused();

  void onInactive();

  void onDetached();

  void onHidden();
}

class BaseStateController<T> extends GetxController with BaseStateMixin<T> {
  /// 在onInit自动调用onRequestPage(page)
  bool implementationOnInit = true;

  @override
  void onInit() {
    if (implementationOnInit) {
      onRequestData();
    }
    super.onInit();
  }

  String? getPlaceholderTitle(String? placeholderEmptyTitle) {
    return status.isLoading
        ? null
        : (status.isEmpty
            ? (placeholderEmptyTitle ?? kEmptyList)
            : status.errorMessage);
  }

  String? getPlaceholderMessage(String? placeholderEmptyMessage) {
    if (status.isLoading) {
      return null;
    }
    if (placeholderEmptyMessage != null) {
      return placeholderEmptyMessage;
    }
    if (status.isEmpty) {
      return kEmptyList;
    } else {
      if (status.errorMessage == kPlaceholderTitleBadResponse) {
        return kPlaceholderMessageBadResponse;
      } else if (status.errorMessage == kPlaceholderTitleConnection) {
        return kPlaceholderMessageConnection;
      }
    }
    return null;
  }

  Widget baseState(
    NotifierBuilder<T?> widget, {
    bool validNullable = true,
    Widget Function()? onPlaceholderWidget,
    String? placeholderEmptyImagePath,
    String? placeholderEmptyTitle,
    String? placeholderEmptyMessage,
    void Function()? onReloadTap,
  }) {
    return SimpleBuilder(
      builder: (_) {
        if (status.isLoading ||
            status.isEmpty ||
            status.isError ||
            (validNullable && state.isEmptyOrNull)) {
          return onPlaceholderWidget != null
              ? onPlaceholderWidget()
              : BasePlaceholderView(
                  title: getPlaceholderTitle(placeholderEmptyTitle),
                  message: getPlaceholderMessage(placeholderEmptyMessage),
                  image: placeholderEmptyImagePath,
                  onTap: onReloadTap ??
                      () {
                        change(null, status: RxStatus.loading());
                        onRequestData();
                      },
                );
        }
        return widget(state);
      },
    );
  }

  Widget baseShimmerState(
    NotifierBuilder<T?> widget, {
    bool validNullable = true,
    Color? baseColor,
    Color? highlightColor,
    Widget Function()? onPlaceholderWidget,
    String? placeholderEmptyImagePath,
    String? placeholderEmptyTitle,
    String? placeholderEmptyMessage,
    EdgeInsetsGeometry? placeholderPadding,
    void Function()? onReloadTap,
  }) {
    return SimpleBuilder(
      builder: (_) {
        if (status.isLoading ||
            status.isEmpty ||
            status.isError ||
            (validNullable && state.isEmptyOrNull)) {
          if (status.isLoading) {
            return BaseShimmer(
              visible: status.isLoading,
              child: widget(state),
              baseColor: baseColor,
              highlightColor: highlightColor,
            );
          }
          return Padding(
            padding: placeholderPadding ?? EdgeInsets.zero,
            child: onPlaceholderWidget != null
                ? onPlaceholderWidget()
                : BasePlaceholderView(
                    title: getPlaceholderTitle(placeholderEmptyTitle),
                    message: getPlaceholderMessage(placeholderEmptyMessage),
                    image: placeholderEmptyImagePath,
                    onTap: onReloadTap ??
                        () {
                          change(null, status: RxStatus.loading());
                          onRequestData();
                        },
                  ),
          );
        }
        return widget(state);
      },
    );
  }

  Future<void> onRequestData() async {}

  void updateResult<T>({required Result result, BaseComputeResult? compute}) {
    if (result.valid) {
      dynamic data = result.model ?? result.models.toList();
      if (data == null || (data is List && data.isEmpty)) {
        compute != null
            ? compute(null, RxStatus.empty())
            : change(null, status: RxStatus.empty());
      } else {
        compute != null
            ? compute(data, RxStatus.success())
            : change(data, status: RxStatus.success());
      }
    } else {
      compute != null
          ? compute(null, RxStatus.error(result.message))
          : change(null, status: RxStatus.error(result.message));
    }
  }

  void cleanState() {
    change(null);
  }

  Future<void> loopRequest({
    bool Function()? validTest,
    void Function()? onRequest,
    int count = 3,
    Duration delay = const Duration(seconds: 10),
    bool immediately = false,
  }) async {
    logDebug("$runtimeType loop start");
    var index = 0;
    while (index < count) {
      index++;
      logDebug("$runtimeType loop isClosed:$isClosed");
      if (validTest?.call() ?? !isClosed) {
        if (index == 1 && !immediately) {
          logDebug("$runtimeType loop no immediately");
        } else {
          logDebug("$runtimeType loop ing");
          if (onRequest != null) {
            onRequest.call();
          } else {
            onRequestData();
          }
        }
        await delay.delay();
      } else {
        logDebug("$runtimeType loop break");
        break;
      }
    }
  }
}

extension CountResult on Result {
  /// 分页总页数
  int get count {
    dynamic value;
    if (body.containsKey(kPageCountKey)) {
      value = body[kPageCountKey];
    } else if (data.containsKey(kPageCountKey)) {
      value = data[kPageCountKey];
    }
    if (value == null) {
      return kFirstPage;
    }
    if (!(value is int)) {
      value = int.tryParse("$value") ?? 0;
    }
    if (kFirstPage == 0) {
      --value;
    }
    return value;
  }
}

class BaseRefreshStateController<T> extends BaseStateController<T> {
  /// 刷新控制器
  final refreshController = BaseRefreshController();

  /// 当前页码
  int page = kFirstPage;

  /// 需要下拉刷新
  bool implementationOnRefresh = true;

  /// 需要上拉加载更多
  bool implementationOnLoad = true;

  /// 指定当前页面无数据时的占位标题
  String? _placeholderEmptyTitle;

  @override
  void onInit() {
    if (implementationOnInit) {
      onRequestPage(page);
    }
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Widget baseRefreshState(
    NotifierBuilder<T?> widget, {
    ScrollController? scrollController,
    bool validNullable = true,
    bool? shimmer,
    Color? baseColor,
    Color? highlightColor,
    Widget Function()? onPlaceholderWidget,
    String? placeholderEmptyImagePath,
    String? placeholderEmptyTitle,
    String? placeholderEmptyMessage,
    bool firstRefresh = false,
    VoidCallback? onRefresh,
    VoidCallback? onLoading,
    void Function()? onReloadTap,
  }) {
    _placeholderEmptyTitle = placeholderEmptyTitle;
    return SimpleBuilder(builder: (_) {
      Widget? emptyWidget() {
        if (status.isLoading && shimmer == true) {
          return BaseShimmer(
            visible: true,
            child: widget(state),
            baseColor: baseColor,
            highlightColor: highlightColor,
          );
        }
        return onPlaceholderWidget != null
            ? onPlaceholderWidget()
            : BasePlaceholderView(
                title: getPlaceholderTitle(placeholderEmptyTitle),
                message: getPlaceholderMessage(placeholderEmptyMessage),
                // 指定当前页面的占位图路径（网络默认placeholder_remote错误除外, 默认placeholder_empty）
                image: placeholderEmptyImagePath,
                onTap: onReloadTap ??
                    () {
                      change(state, status: RxStatus.loading());
                      onRequestPage(page);
                    },
              );
      }

      return BaseRefresh(
        controller: refreshController,
        scrollController: scrollController,
        emptyWidget:
            (validNullable && state.isEmptyOrNull) ? emptyWidget() : null,
        firstRefresh: firstRefresh,
        onRefresh: implementationOnRefresh && !status.isLoading
            ? (onRefresh ?? () async => onRequestPage(kFirstPage))
            : null,
        onLoading: implementationOnLoad && state != null && !status.isLoading
            ? (onLoading ?? () async => onRequestPage(page + 1))
            : null,
        child: (state == null && !status.isSuccess ||
                (validNullable && state.isEmptyOrNull))
            ? emptyWidget() ?? SizedBox()
            : widget(state),
      );
    });
  }

  Widget baseRefreshMessageState(
    NotifierBuilder<T?> widget, {
    VoidCallback? onLoading,
    ScrollController? scrollController,
    Widget? footer,
  }) {
    return SimpleBuilder(builder: (_) {
      return BaseRefresh.message(
        controller: refreshController,
        scrollController: scrollController,
        footer: footer,
        onLoading: onLoading,
        sliver: widget(state),
      );
    });
  }

  Future<void> onRequestPage(int page) async {}

  /// 完成下拉刷新
  void finishRefresh({
    required bool success,
    required bool noMore,
  }) {
    if (success) {
      if (noMore) {
        refreshController.loadNoData();
      }
      refreshController.refreshCompleted(resetFooterState: !noMore);
    } else {
      refreshController.refreshFailed();
    }
  }

  /// 完成上拉加载
  void finishLoad({
    required bool success,
    required bool noMore,
  }) {
    if (success) {
      if (noMore) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } else {
      refreshController.loadFailed();
    }
  }

  /// [noMore] - 没有更多? 没有更多数据: true, 有更多数据: false
  void updateRefreshResult<T>(Result result,
      {required int page,
      bool force = false,
      int? limitPage,
      int? pageCount,
      bool? noMore,
      BaseComputeResult? compute}) {
    dynamic models = result.models.toList();
    if (result.valid) {
      if (models.isNotEmpty) {
        bool noMoreJudge = noMore ?? true;
        if (noMore == null) {
          if (pageCount != null) {
            noMoreJudge = page >= pageCount;
          } else if (kPageCountKey.isNotEmpty) {
            noMoreJudge = page >= result.count;
          } else {
            noMoreJudge = models.length < (limitPage ?? kLimitPage);
          }
        }
        logDebug("$noMore, $noMoreJudge");

        this.page = page;
        if (page > kFirstPage) {
          // 上拉加载第2页数据
          dynamic _tmp = state;
          _tmp.addAll(models);
          compute != null
              ? compute(_tmp, RxStatus.success())
              : change(_tmp, status: RxStatus.success());
          finishLoad(success: result.valid, noMore: noMoreJudge);
        } else {
          // 下拉刷新第1页数据
          compute != null
              ? compute(models, RxStatus.success())
              : change(models, status: RxStatus.success());
          finishRefresh(success: result.valid, noMore: noMoreJudge);
        }
      } else if (page == kFirstPage && state != null) {
        // 下野刷新时已有数据
        if (force) {
          // 强制下拉刷新时,无数时会清除数据
          compute != null
              ? compute(
                  null, RxStatus.error(_placeholderEmptyTitle ?? kEmptyList))
              : change(null,
                  status: RxStatus.error(_placeholderEmptyTitle ?? kEmptyList));
        }
        finishRefresh(success: result.valid, noMore: false);
      } else if (state == null) {
        // 未约定的无数据
        compute != null
            ? compute(
                null, RxStatus.error(_placeholderEmptyTitle ?? kEmptyList))
            : change(null,
                status: RxStatus.error(_placeholderEmptyTitle ?? kEmptyList));
        finishRefresh(success: true, noMore: true);
      } else {
        // 已经有1页数据再次上拉加载 无更多数据
        finishLoad(success: result.valid, noMore: true);
      }
    } else {
      if (page > kFirstPage) {
        finishLoad(success: result.valid, noMore: true);
      } else {
        finishRefresh(success: result.valid, noMore: false);
      }
      dynamic tmp = state;
      compute != null
          ? compute(tmp, RxStatus.error(result.message))
          : change(tmp, status: RxStatus.error(result.message));
      showToast(result.message);
    }
  }
}
