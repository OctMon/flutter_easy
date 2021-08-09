import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 指定登录路由
final routesLoginNamed = '/login';

/// 指定登录状态
@deprecated
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

/// 导航到默认的登录页面
Future<bool> toLogin() async {
  final success = (await toNamed(routesLoginNamed)) ?? false;
  return success;
}

/// 导航到新的页面
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

/// 进入下一个页面，但没有返回上一个页面的选项（用于SplashScreens，登录页面等）
Future<T?>? offNamed<T>(
  String page, {
  dynamic arguments,
  int? id,
  bool preventDuplicates = true,
  Map<String, String>? parameters,
}) {
  return Get.offNamed<T>(page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters);
}

/// 进入下一个界面并取消之前的满足条件的路由
Future<T?>? offNamedUntil<T>(
  String page,
  RoutePredicate predicate, {
  int? id,
  dynamic arguments,
  Map<String, String>? parameters,
}) {
  return Get.offNamedUntil<T>(page, predicate,
      id: id, arguments: arguments, parameters: parameters);
}

/// 关闭当前页面并进入下一个界面
Future<T?>? offAndToNamed<T>(
  String page, {
  dynamic arguments,
  int? id,
  dynamic result,
  Map<String, String>? parameters,
}) {
  return Get.offAndToNamed<T>(page,
      arguments: arguments, id: id, result: result, parameters: parameters);
}

/// 进入下一个界面并取消之前的所有路由（在购物车、投票和测试中很有用）
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

/// 关闭SnackBars、Dialogs、BottomSheets或任何你通常会用Navigator.pop(context)关闭的东西
void back<T>([T? result]) {
  return Get.back<T>(result: result);
}
