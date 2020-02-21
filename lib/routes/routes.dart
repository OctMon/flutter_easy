import 'dart:core';

import 'package:flutter/material.dart';

/// 指定登录路由
String routesLoginNamed = 'login';

/// 指定登录状态
bool Function() routesIsLogin;

///
/// 路由跳转封装pushNamed
///
/// routeName: 跳到指定路由
/// arguments: 路由参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
///
Future pushNamed(BuildContext context, String routeName,
    {Object arguments, dynamic Function(bool) needLogin}) {
  return _pushNamed('pushNamed', context, routeName,
      arguments: arguments, needLogin: needLogin);
}

///
/// 路由跳转封装pushReplacementNamed
///
/// routeName: 跳到指定路由
/// arguments: 路由参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
///
Future pushReplacementNamed(BuildContext context, String routeName,
    {Object arguments, dynamic Function(bool) needLogin}) {
  return _pushNamed('pushReplacementNamed', context, routeName,
      arguments: arguments, needLogin: needLogin);
}

///
/// pushNamedAndRemoveUntil
///
/// routeName: 跳到指定路由
/// predicate: Signature for the [Navigator.popUntil] predicate argument.
/// arguments: 路由参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
///
Future pushNamedAndRemoveUntil(BuildContext context, String routeName,
    {RoutePredicate predicate,
    Object arguments,
    dynamic Function(bool) needLogin}) {
  return _pushNamed('pushNamedAndRemoveUntil', context, routeName,
      predicate: predicate, arguments: arguments, needLogin: needLogin);
}

///
/// 路由跳转封装popAndPushNamed
///
/// routeName: 跳到指定路由
/// arguments: 路由参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
///
Future popAndPushNamed(BuildContext context, String routeName,
    {Object arguments, dynamic Function(bool) needLogin}) {
  return _pushNamed('popAndPushNamed', context, routeName,
      arguments: arguments, needLogin: needLogin);
}

Future _pushNamed(String type, BuildContext context, String routeName,
    {RoutePredicate predicate,
    Object arguments,
    dynamic Function(bool) needLogin}) {
  if (needLogin != null && !routesIsLogin()) {
    return pushNamedToLogin(context)
        .then((success) => needLogin(success ?? false));
  }
  switch (type) {
    case 'pushReplacementNamed':
      return Navigator.of(context)
          .pushReplacementNamed(routeName, arguments: arguments);
      break;
    case 'pushNamedAndRemoveUntil':
      return Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
      break;
    case 'popAndPushNamed':
      return Navigator.of(context)
          .popAndPushNamed(routeName, arguments: arguments);
      break;
    default:
      return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}

Future<bool> pushNamedToLogin(BuildContext context) async {
  bool success = await pushNamed(context, routesLoginNamed) ?? false;
  return success;
}
