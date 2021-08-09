import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 指定登录路由
String routesLoginNamed = 'login';

/// 指定登录状态
bool Function()? routesIsLogin;

///
/// 路由跳转封装pushNamed
///
/// routeName: 跳到指定路由
/// arguments: 路由参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
///
@deprecated
Future pushNamed(BuildContext context, String routeName,
    {Object? arguments, dynamic Function(bool)? needLogin}) {
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
@deprecated
Future pushReplacementNamed(BuildContext context, String routeName,
    {Object? arguments, dynamic Function(bool)? needLogin}) {
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
@deprecated
Future pushNamedAndRemoveUntil(BuildContext context, String routeName,
    {required RoutePredicate predicate,
    Object? arguments,
    dynamic Function(bool)? needLogin}) {
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
@deprecated
Future popAndPushNamed(BuildContext context, String routeName,
    {Object? arguments, dynamic Function(bool)? needLogin}) {
  return _pushNamed('popAndPushNamed', context, routeName,
      arguments: arguments, needLogin: needLogin);
}

///
/// 路由跳转封装pop
///
@deprecated
pop<T extends Object?>(BuildContext context, [T? result]) {
  return Navigator.of(context).pop(result);
}

@deprecated
Future<T?> _pushNamed<T extends Object?>(
    String type, BuildContext context, String routeName,
    {RoutePredicate? predicate,
    Object? arguments,
    dynamic Function(bool)? needLogin}) async {
  if (needLogin != null && routesIsLogin != null && !routesIsLogin!()) {
    return pushNamedToLogin(context).then((success) => needLogin(success));
  }
  switch (type) {
    case 'pushReplacementNamed':
      return Navigator.of(context)
          .pushReplacementNamed(routeName, arguments: arguments);
    case 'pushNamedAndRemoveUntil':
      if (predicate != null) {
        return Navigator.of(context).pushNamedAndRemoveUntil(
            routeName, predicate,
            arguments: arguments);
      }
      break;
    case 'popAndPushNamed':
      return Navigator.of(context)
          .popAndPushNamed(routeName, arguments: arguments);
    default:
      return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}

@deprecated
Future<bool> pushNamedToLogin(BuildContext context) async {
  bool success = await pushNamed(context, routesLoginNamed) ?? false;
  return success;
}

Future<T?>? toNamed<T>(
  String page, {
  dynamic arguments,
  int? id,
  bool preventDuplicates = true,
  Map<String, String>? parameters,
}) {
  return Get.toNamed<T>(page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters);
}

Future<T?>? offNamed<T>(
  String page, {
  dynamic arguments,
  int? id,
  bool preventDuplicates = true,
  Map<String, String>? parameters,
}) {
  return Get.offNamed(page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters);
}

Future<T?>? offNamedUntil<T>(
  String page,
  RoutePredicate predicate, {
  int? id,
  dynamic arguments,
  Map<String, String>? parameters,
}) {
  return Get.offNamedUntil(page, predicate,
      id: id, arguments: arguments, parameters: parameters);
}

Future<T?>? offAndToNamed<T>(
  String page, {
  dynamic arguments,
  int? id,
  dynamic result,
  Map<String, String>? parameters,
}) {
  return Get.offAndToNamed(page,
      arguments: arguments, id: id, result: result, parameters: parameters);
}

Future<T?>? offAllNamed<T>(
  String newRouteName, {
  RoutePredicate? predicate,
  dynamic arguments,
  int? id,
  Map<String, String>? parameters,
}) {
  return Get.offAllNamed<T>(newRouteName,
      predicate: predicate,
      arguments: arguments,
      id: id,
      parameters: parameters);
}
