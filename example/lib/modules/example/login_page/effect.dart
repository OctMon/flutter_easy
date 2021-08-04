import 'dart:async';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/api.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/store/user_store/store.dart';

import 'action.dart';
import 'state.dart';

Effect<LoginState> buildEffect() {
  return combineEffects(<Object, Effect<LoginState>>{
    LoginAction.onLoginPressed: _onLoginPressed,
  });
}

Future<void> _onLoginPressed(Action action, Context<LoginState> ctx) async {
  String phone = ctx.state.phoneNumberController.text.trim();
  String password = ctx.state.passwordController.text.trim();
  if (phone.isEmpty) {
    showToast(S.of(ctx.context).example_InputPhoneNumber);
    return;
  }

  if (!phone.isCNPhoneNumber) {
    showToast(S.of(ctx.context).example_ValidPhoneNumberTip);
    return;
  }

  if (password.isEmpty) {
    showToast(S.of(ctx.context).example_InputPassword);
    return;
  }

  if (!ctx.state.isChecked) {
    showToast(S.of(ctx.context).example_AgreeToContinueTip);
    return;
  }
  Result result = await post(
      path: kApiLogin,
      data: {"phone": phone, "password": password},
      context: ctx.context,
      autoLoading: true);
  // if (result.valid) {
  result.fill(
      UserModel.fromJson({"userId": "1", "nickname": "flutter", "avatar": ""}));
  await UserStore.save(result.model);
  pop(ctx.context, true);
  // } else {
  //   showToast(result.message);
  // }
}
