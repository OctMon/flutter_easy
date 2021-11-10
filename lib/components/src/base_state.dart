import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

typedef BaseComputeResult<T> = void Function(T state, RxStatus status);

typedef BaseStateMixin<T> = StateMixin<T>;

void updateState<T>(dynamic state,
    {required Result result,
    required EasyRefreshController refreshController,
    required int page,
    int? limitPage,
    int? pageCount,
    required BaseComputeResult compute}) {
  dynamic models = result.models.toList();
  if (result.valid) {
    if (models.isNotEmpty) {
      /// 有无加载更多
      var noMore = false;
      if (pageCount != null) {
        noMore = page < pageCount;
      } else {
        noMore = models.length < (limitPage ?? kLimitPage);
      }
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
      // 已经有1页数据再次卡拉加载 无更多数据
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

class BaseStateController<T> extends GetxController with BaseStateMixin<T> {
  /// 指定当前页面的占位图路径（网络默认placeholder_remote错误除外, 默认placeholder_empty）
  String? placeholderImagePath;

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
                onTap: onLoadTap,
              );
      }
      return widget(state);
    });
  }
}

extension BaseStateControllerUpdate<T> on BaseStateController<T> {
  void updateResult<T>(Result result,
      {required EasyRefreshController refreshController,
      required int page,
      int? limitPage,
      int? pageCount,
      required BaseComputeResult compute}) {
    updateState<T>(state,
        result: result,
        refreshController: refreshController,
        page: page,
        limitPage: limitPage,
        pageCount: pageCount,
        compute: compute);
  }
}

class BaseRefreshStateController<T> extends BaseStateController<T> {
  /// 刷新控制器
  final refreshController = EasyRefreshController();

  /// 当前页码
  int page = kFirstPage;

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
                    onTap: onLoadTap ?? () => refreshController.callRefresh(),
                  ))
            : null,
        firstRefresh: firstRefresh,
        onRefresh: onRefresh,
        onLoad: state != null ? onLoad : null,
        child: widget(state),
      );
    });
  }
}