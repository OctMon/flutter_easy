import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginState {
  TextEditingController phoneNumberController;
  TextEditingController passwordController;

  final _isChecked = false.obs;

  get isChecked => _isChecked.value;

  set isChecked(value) => _isChecked.value = value;

  LoginState() {
    ///Initialize variables
  }

  update(bool isChecked) {
    _isChecked.toggle();
  }
}
