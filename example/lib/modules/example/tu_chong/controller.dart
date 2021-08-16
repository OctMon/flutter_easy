import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/modules/example/tu_chong/model.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_api.dart';

class TuChongController extends GetxController with StateMixin<List<TCModel>?> {
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
      ..fillMap((json) => TCModel.fromJson(json));
    updateResult(result, refreshController: refreshController, page: page,
        compute: (state, RxStatus status) {
      change(state, status: status);
      if (status.isSuccess) {
        this.page = page;
        this.postId = state?.last.postId;
      } else {
        showErrorToast(result.message);
      }
    });
  }
}
