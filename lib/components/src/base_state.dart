import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

typedef BaseComputeResult<T> = void Function(T state, RxStatus status);

typedef BaseStateMixin<T> = StateMixin<T>;

abstract class BaseLifeCycleController extends FullLifeCycleController
    with FullLifeCycleMixin {}

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

  Widget baseState(
    NotifierBuilder<T?> widget, {
    Widget Function(String? errorMessage)? onEmptyWidget,
    String? placeholderImagePath,
    String? placeholderEmptyTitle,
    void Function()? onReloadTap,
  }) {
    return SimpleBuilder(
      builder: (_) {
        if (status.isLoading ||
            status.isEmpty ||
            status.isError ||
            state.isEmptyOrNull) {
          return onEmptyWidget != null
              ? onEmptyWidget(status.isEmpty
                  ? (placeholderEmptyTitle ?? kEmptyList)
                  : status.errorMessage)
              : BasePlaceholderView(
                  title: status.isLoading
                      ? null
                      : (status.isEmpty
                          ? (placeholderEmptyTitle ?? kEmptyList)
                          : status.errorMessage),
                  image: placeholderImagePath,
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

  Future<void> onRequestData() async {}

  void updateResult<T>({required Result result, BaseComputeResult? compute}) {
    if (result.valid) {
      dynamic data = result.model ?? result.models.toList();
      compute != null
          ? compute(data, RxStatus.success())
          : change(data, status: RxStatus.success());
    } else {
      compute != null
          ? compute(null, RxStatus.error(result.message))
          : change(null, status: RxStatus.error(result.message));
    }
  }

  void cleanState() {
    change(null);
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
    Widget Function(String? status)? onEmptyWidget,
    String? placeholderImagePath,
    String? placeholderEmptyTitle,
    bool firstRefresh = false,
    VoidCallback? onRefresh,
    VoidCallback? onLoading,
    void Function()? onReloadTap,
  }) {
    _placeholderEmptyTitle = placeholderEmptyTitle;
    return SimpleBuilder(builder: (_) {
      Widget? emptyWidget() {
        return onEmptyWidget != null
            ? onEmptyWidget(status.errorMessage)
            : BasePlaceholderView(
                title: status.errorMessage,
                // 指定当前页面的占位图路径（网络默认placeholder_remote错误除外, 默认placeholder_empty）
                image: placeholderImagePath,
                onTap: onReloadTap ??
                    () {
                      change(state, status: RxStatus.loading());
                      onRequestPage(page);
                    },
              );
      }

      return BaseRefresh(
        controller: refreshController,
        emptyWidget: state.isEmptyOrNull ? emptyWidget() : null,
        firstRefresh: firstRefresh,
        onRefresh: implementationOnRefresh
            ? (onRefresh ?? () async => onRequestPage(kFirstPage))
            : null,
        onLoading: implementationOnLoad && state != null
            ? (onLoading ?? () async => onRequestPage(page + 1))
            : null,
        child: (state == null && !status.isSuccess || state.isEmptyOrNull)
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
