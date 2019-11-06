import 'dart:core';

import 'package:flutter/material.dart';
import '../utils/global_util.dart';

String routesLoginNamed = 'login';

///
/// 路由跳转封装
///
/// path: 跳到指定路由
/// arguments: 路由参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
///
Future pushNamed(
  BuildContext context,
  String routeName, {
  Object arguments,
  dynamic Function(bool) needLogin,
}) {
  if (needLogin != null && !GlobalUtil.isLogin()) {
    return GlobalUtil.pushToLogin(context)
        .then((success) => needLogin(success ?? false));
  }
  return Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

Future<bool> pushNamedToLogin(BuildContext context) async {
  bool success = await pushNamed(context, routesLoginNamed) ?? false;
  return success;
}
