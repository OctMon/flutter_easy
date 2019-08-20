import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
export 'package:fluro/fluro.dart' show TransitionType;

abstract class RouterProvider {
  void initRouter(Router router);
}

class RouterUtils {
  /// 指定登录方法
  static Future<dynamic> Function(BuildContext context) setPushToLogin;

  /// 指定登录状态
  static bool Function() setIsLogin;
}

///
/// 路由跳转封装
///
/// path: 跳到指定路由
/// name: 将name到path之间的页面全部pop
/// parameter: Map参数
/// needLogin: 是否检测用户登录状态 需要[setPushToLogin]指定登录方法 [setIsLogin]指定登录状态
/// replace: true->替换页面 当新的页面进入后，之前的页面将执行dispose方法
/// clearStack: true->指定页面加入到路由中，然后将其他所有的页面全部pop
///
Future pushNamed(BuildContext context, String path,
    {Map<String, String> parameter,
    dynamic Function(bool) needLogin,
    bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.native,
    Duration transitionDuration = const Duration(
      milliseconds: 250,
    ),
    RouteTransitionsBuilder transitionBuilder}) {
  if (needLogin != null && !RouterUtils.setIsLogin()) {
    return RouterUtils.setPushToLogin(context).then((success) {
      needLogin(success);
    });
  }
  return Router.appRouter.navigateTo(
    context,
    path + _encodeQueryComponent(parameter),
    replace: replace,
    clearStack: clearStack,
    transition: transition,
    transitionDuration: transitionDuration,
  );
}

///
/// 指定页面加入到路由中，然后将将name到path之间的页面全部pop
///
/// path: 跳到指定路由
/// name: 将name到path之间的页面全部pop
/// parameter: Map参数
///
pushNamedAndRemoveUntil(BuildContext context, String path, String name,
    {Map<String, String> parameter}) {
  Navigator.pushNamedAndRemoveUntil(context,
      path + _encodeQueryComponent(parameter), ModalRoute.withName(name));
}

///
/// 将参数值url编码
///
/// parameter: Map参数
///
String _encodeQueryComponent(Map<String, String> parameter) {
  if (parameter == null || parameter.isEmpty) {
    return '';
  }
  String query = '?';
  parameter.forEach((key, value) {
    if (value != null && value.isNotEmpty) {
      query += '$key=${Uri.encodeQueryComponent(value)}';
      query += '&';
    }
  });
  if (query.endsWith('&')) {
    query.substring(0, query.length - 1);
  }
  return query;
}
