import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

typedef BaseComputeResult<T> = void Function(T state, RxStatus status);

typedef BaseStateMixin<T> = StateMixin<T>;

class BaseStateController<T> extends GetxController with BaseStateMixin<T> {
  /// 指定当前页面的占位图路径（网络默认placeholder_remote错误除外, 默认placeholder_empty）
  String? placeholderImagePath;

  @override
  void onInit() {
    onRequestData();
    super.onInit();
  }

  Widget baseState(
    NotifierBuilder<T?> widget, {
    Widget Function(String? errorMessage)? onEmptyWidget,
    void Function()? onLoadTap,
  }) {
    return SimpleBuilder(builder: (_) {
      if (status.isLoading || status.isError || state.isEmptyOrNull) {
        return onEmptyWidget != null
            ? onEmptyWidget(status.errorMessage)
            : BasePlaceholderView(
                title: status.isLoading ? null : status.errorMessage,
                image: placeholderImagePath,
                onTap: onLoadTap ?? () => onRequestData(),
              );
      }
      return widget(state);
    });
  }

  Future<void> onRequestData() async {}
}

extension BaseStateControllerUpdate<T> on BaseStateController<T> {
  void updateResult<T>(
      {required Result result, required BaseComputeResult compute}) {
    if (result.valid) {
      dynamic models = result.models.toList();
      compute(models, RxStatus.success());
    } else {
      compute(null, RxStatus.error(result.message));
    }
  }
}

class BaseRefreshStateController<T> extends BaseStateController<T> {
  /// 刷新控制器
  final refreshController = EasyRefreshController();

  /// 当前页码
  int page = kFirstPage;

  /// 需要下拉刷新
  bool implementationOnRefresh = true;

  /// 需要上拉加载更多
  bool implementationOnLoad = true;

  @override
  void onInit() {
    onRequestPage(page);
    super.onInit();
  }

  Widget baseRefreshState(
    NotifierBuilder<T?> widget, {
    Widget Function(String? status)? onEmptyWidget,
    bool firstRefresh = false,
    OnRefreshCallback? onRefresh,
    OnLoadCallback? onLoad,
    void Function()? onLoadTap,
  }) {
    return SimpleBuilder(builder: (_) {
      return BaseRefresh(
        controller: refreshController,
        emptyWidget: state.isEmptyOrNull
            ? (onEmptyWidget != null
                ? onEmptyWidget(status.errorMessage)
                : BasePlaceholderView(
                    title: status.errorMessage,
                    image: placeholderImagePath,
                    onTap: onLoadTap ?? () => onRequestPage(page),
                  ))
            : null,
        firstRefresh: firstRefresh,
        onRefresh: implementationOnRefresh
            ? (onRefresh ?? () async => onRequestPage(kFirstPage))
            : null,
        onLoad: implementationOnLoad && state != null
            ? (onLoad ?? () async => onRequestPage(page + 1))
            : null,
        child: widget(state),
      );
    });
  }

  Future<void> onRequestPage(int page) async {}
}

extension BaseStateRefreshControllerUpdate<T> on BaseRefreshStateController<T> {
  void updateRefreshResult<T>(Result result,
      {required int page,
      int? limitPage,
      int? pageCount,
      required BaseComputeResult compute}) {
    dynamic models = result.models.toList();
    if (result.valid) {
      if (models.isNotEmpty) {
        /// 有无加载更多 true: 无更多 false: 有更多
        var noMore = true;
        if (pageCount != null) {
          noMore = page < pageCount;
        } else {
          noMore = models.length < (limitPage ?? kLimitPage);
        }
        this.page = page;
        if (page > kFirstPage) {
          // 上拉加载第2页数据
          dynamic _tmp = state;
          compute(_tmp..addAll(models), RxStatus.success());
          refreshController.finishLoad(success: result.valid, noMore: noMore);
        } else {
          // 下拉刷新第1页数据
          compute(models, RxStatus.success());
          refreshController.finishRefresh(success: result.valid);
          refreshController.resetLoadState();
        }
      } else if (state == null) {
        // 未约定的无数据
        compute(null, RxStatus.error(kEmptyList));
      } else {
        // 已经有1页数据再次上拉加载 无更多数据
        refreshController.finishLoad(success: result.valid, noMore: true);
      }
    } else {
      refreshController.resetLoadState();
      if (page > kFirstPage) {
        refreshController.finishLoad(success: result.valid);
      } else {
        refreshController.finishRefresh(success: result.valid);
      }
      dynamic tmp = state;
      compute(tmp, RxStatus.error(result.message));
    }
  }
}
