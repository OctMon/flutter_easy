import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_api.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';
import 'package:get/get.dart';

class TuChongController extends GetxController
    with BaseRefreshState<EasyRefreshController, TuChongModel> {
  int postId;

  @override
  Rx<TuChongModel> data;

  @override
  RxList<TuChongModel> list = <TuChongModel>[].obs;

  @override
  Rx<String> message = "".obs;

  @override
  int page = kFirstPage;

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
    this.page = page;
    Result result = await getAPI(
        path: kApiFeedApp,
        queryParameters: {"page": this.page, "pose_id": this.postId ?? 0})
      ..fillMap((json) => TuChongModel.fromJson(json));
    updateResult(result, hasMore: result.valid);
    postId = list.last.postId;
  }

  @override
  EasyRefreshController refreshController = EasyRefreshController();
}
