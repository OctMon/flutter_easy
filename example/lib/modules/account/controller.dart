import 'package:flutter_easy/flutter_easy.dart';

class AccountController extends GetxController {
  final logEnable = logFile?.enable.obs;
  final logFilesCount = 0.obs;
  final logFilesSize = "0".obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    logDebug("getCurrentFile: ${await logFile?.getCurrentFile()}");
    final count = await logFile?.filesCount();
    final size = await logFile?.filesSize();
    if (count != null) {
      logFilesCount.value = count;
      logFilesSize.value = size?.displayText ?? "0";
    }
  }
}
