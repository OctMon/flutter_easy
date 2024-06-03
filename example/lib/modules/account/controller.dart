import 'package:flutter_easy/flutter_easy.dart';

class AccountController extends GetxController {
  final logEnable = isAppDebugFlag.obs;
  final logFilesCount = 0.obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    logFilesCount.value = await logFile.filesCount();
  }
}
