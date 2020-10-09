import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class LoginState implements Cloneable<LoginState> {
  TextEditingController phoneNumberController;
  TextEditingController passwordController;
  bool isChecked;

  @override
  LoginState clone() {
    return LoginState()
      ..phoneNumberController = phoneNumberController
      ..passwordController = passwordController
      ..isChecked = isChecked;
  }
}

LoginState initState(Map<String, dynamic> args) {
  return LoginState()
    ..phoneNumberController = TextEditingController()
    ..passwordController = TextEditingController()
    ..isChecked = true;
}
