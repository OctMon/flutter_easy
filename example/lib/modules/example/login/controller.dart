import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/constant.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/utils/user/model.dart';
import 'package:flutter_easy_example/utils/user/service.dart';

import 'state.dart';

class LoginController extends GetxController {
  final state = LoginState();

  @override
  void onInit() {
    state.phoneNumberController = TextEditingController();
    state.passwordController = TextEditingController();
    state.isChecked = false;
    super.onInit();
  }

  @override
  void onClose() {
    state.phoneNumberController.dispose();
    state.passwordController.dispose();
    super.onClose();
  }

  Future<void> onLoginPressed(BuildContext context) async {
    String phone = state.phoneNumberController.text.trim();
    String password = state.passwordController.text.trim();
    if (phone.isEmpty) {
      // Get.snackbar(S.of(Get.context).example_InputPhoneNumber, "");
      showToast(S.of(context).example_InputPhoneNumber);
      return;
    }

    if (!phone.isCNPhoneNumber) {
      showToast(S.of(context).example_ValidPhoneNumberTip);
      return;
    }

    if (password.isEmpty) {
      showToast(S.of(context).example_InputPassword);
      return;
    }

    if (!state.isChecked) {
      showToast(S.of(context).example_AgreeToContinueTip);
      return;
    }
    Result result = await post(
        path: kApiLogin,
        data: {"phone": phone, "password": password.md5},
        autoLoading: true);
    // if (result.valid) {
    result.fill(UserModel.fromJson({
      "userId": "1",
      "nickname": "flutter${colorWithRandom()}",
      "avatar": ""
    }));

    final service = Get.find<UserService>();
    await service.save(result.model);
    offBack(true);
    // } else {
    //   showToast(result.message);
    // }
  }
}
