import 'package:flutter_easy/flutter_easy.dart';

class PhotoController extends BaseStateController<int?> {
  @override
  void onInit() {
    onRequestData();
    super.onInit();
  }

  @override
  Future<void> onRequestData() async {
    final random = randomInt(3);
    logDebug(random);
    change(random, status: RxStatus.loading());
    Future.delayed(random.seconds).then((value) {
      change(0,
          status:
              randomInt(2) == 1 ? RxStatus.error("error") : RxStatus.success());
    });
  }
}
