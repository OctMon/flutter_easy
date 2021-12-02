import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

typedef BaseComputeResult<T> = void Function(T state, RxStatus status);

typedef BaseStateMixin<T> = StateMixin<T>;

abstract class BaseLifeCycleController extends FullLifeCycleController
    with FullLifeCycle {}

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

class BaseRefreshStateController<T> extends BaseStateController<T> {
  /// 刷新控制器
  final refreshController = EasyRefreshController();

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

  Widget baseRefreshState(
    NotifierBuilder<T?> widget, {
    Widget Function(String? status)? onEmptyWidget,
    String? placeholderImagePath,
    String? placeholderEmptyTitle,
    bool firstRefresh = false,
    OnRefreshCallback? onRefresh,
    OnLoadCallback? onLoad,
    void Function()? onReloadTap,
  }) {
    _placeholderEmptyTitle = placeholderEmptyTitle;
    return SimpleBuilder(builder: (_) {
      return BaseRefresh(
        controller: refreshController,
        emptyWidget: state.isEmptyOrNull
            ? (onEmptyWidget != null
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

  /// 完成加载
  void _finishLoad({
    required bool success,
    required bool noMore,
  }) {
    Future.delayed(Duration(milliseconds: 100), () {
      // TODO: 延迟100ms执行，首次自动刷新，数据只有一页，finishLoad(noMore: true)不生效，但是下拉刷新却生效. #197
      // https://github.com/xuelongqy/flutter_easyrefresh/issues/197
      refreshController.finishLoad(success: success, noMore: noMore);
    });
  }

  void updateRefreshResult<T>(Result result,
      {required int page,
      bool force = false,
      int? limitPage,
      int? pageCount,
      BaseComputeResult? compute}) {
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
          _tmp.addAll(models);
          compute != null
              ? compute(_tmp, RxStatus.success())
              : change(_tmp, status: RxStatus.success());
          _finishLoad(success: result.valid, noMore: noMore);
        } else {
          // 下拉刷新第1页数据
          compute != null
              ? compute(models, RxStatus.success())
              : change(models, status: RxStatus.success());
          refreshController.finishRefresh(success: result.valid);
          if (noMore) {
            _finishLoad(success: result.valid, noMore: noMore);
          } else {
            refreshController.resetLoadState();
          }
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
        refreshController.finishRefresh(success: result.valid);
      } else if (state == null) {
        // 未约定的无数据
        compute != null
            ? compute(
                null, RxStatus.error(_placeholderEmptyTitle ?? kEmptyList))
            : change(null,
                status: RxStatus.error(_placeholderEmptyTitle ?? kEmptyList));
      } else {
        // 已经有1页数据再次上拉加载 无更多数据
        _finishLoad(success: result.valid, noMore: true);
      }
    } else {
      refreshController.resetLoadState();
      if (page > kFirstPage) {
        _finishLoad(success: result.valid, noMore: true);
      } else {
        refreshController.finishRefresh(success: result.valid);
      }
      dynamic tmp = state;
      compute != null
          ? compute(tmp, RxStatus.error(result.message))
          : change(tmp, status: RxStatus.error(result.message));
    }
  }
}
