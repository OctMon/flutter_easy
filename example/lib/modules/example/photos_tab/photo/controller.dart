import 'package:flutter_easy/flutter_easy.dart';

class PhotoController extends GetxController with BaseStateMixin<int?> {
  @override
  void onReady() {
    final random = randomInt(3);
    logDebug(random);
    change(random, status: RxStatus.loading());
    Future.delayed(random.seconds).then((value) {
      change(0,
          status:
              randomInt(2) == 1 ? RxStatus.error("error") : RxStatus.success());
    });
    super.onReady();
  }
}
