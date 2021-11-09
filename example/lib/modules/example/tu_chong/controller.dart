import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/modules/example/tu_chong/model.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_api.dart';

class TuChongController extends BaseRefreshStateController<List<TCModel>?> {
  int? postId;

  @override
  void onReady() {
    placeholderImagePath = assetsImagesPath("placeholder_appstore");
    onRequestData(page);
    super.onReady();
  }

  Future<void> onRequestData(int page) async {
    Result result = await getAPI(
        path: kApiFeedApp,
        queryParameters: {"page": page, "pose_id": postId ?? 0})
      ..fillMap((json) => TCModel.fromJson(json));
    updateResult(result, refreshController: refreshController, page: page,
        compute: (state, RxStatus status) {
      change(state, status: status);
      if (status.isSuccess) {
        this.page = page;
        postId = state?.last.postId;
      } else {
        showErrorToast(result.message);
      }
    });
  }
}
