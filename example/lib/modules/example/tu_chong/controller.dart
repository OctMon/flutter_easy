import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tu_chong/model/tu_chong_model.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_api.dart';
import 'package:get/get.dart';

class TuChongController extends GetxController
    with StateMixin<List<TuChongModel>?> {
  final refreshController = EasyRefreshController();

  int page = kFirstPage;

  int? postId;

  @override
  void onReady() {
    onRequestData(page);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRequestData(int page) async {
    Result result = await getAPI(
        path: kApiFeedApp,
        queryParameters: {"page": page, "pose_id": this.postId ?? 0})
      ..fillMap((json) => TuChongModel.fromJson(json));
    dynamic _list = result.models.toList();
    if (result.valid) {
      if (_list.isNotEmpty) {
        if (page > kFirstPage) {
          change(state!..addAll(_list), status: RxStatus.success());
          refreshController.finishLoad(
              success: result.valid, noMore: _list.length < kLimitPage);
        } else {
          refreshController.finishRefresh(
              success: result.valid, noMore: false);
          refreshController.resetLoadState();
          change(_list, status: RxStatus.success());
        }
        this.page = page;
        postId = state?.last.postId;
      }
    } else {
      refreshController.resetLoadState();
      if (page > kFirstPage) {
        refreshController.finishLoad(
            success: result.valid);
      } else {
        refreshController.finishRefresh(
            success: result.valid);
      }
      change(state, status: RxStatus.error(result.message));
      showErrorToast(result.message);
    }
  }
}
