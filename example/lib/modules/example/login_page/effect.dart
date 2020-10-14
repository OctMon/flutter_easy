import 'dart:async';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/api.dart';
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
    showToast("请输入手机号");
    return;
  }

  if (!validIsPhone(phone)) {
    showToast("请输入正确的手机号");
    return;
  }

  if (password.isEmpty) {
    showToast("请输入密码");
    return;
  }

  if (!ctx.state.isChecked) {
    showToast("需同意《隐私协议》才能继续使用");
    return;
  }
  Result result = await postAPI(
      path: kApiLogin,
      data: {"phone": phone, "password": password},
      context: ctx.context,
      autoLoading: true);
  // if (result.valid) {
  result.fill(
      UserModel.fromMap({"userId": "1", "nickname": "flutter", "avatar": ""}));
  await UserStore.save(result.model);
  pop(ctx.context, true);
  showToast("登录成功");
  // } else {
  //   showToast(result.message);
  // }
}
