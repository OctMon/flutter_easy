import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// 指定登录路由
final routesLoginNamed = '/login';

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
