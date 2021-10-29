import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/utils/user/service.dart';

/// 检查是否登录
class LoginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (UserService.find.isLogin) {
      return null;
    } else {
      return RouteSettings(name: routesLoginNamed);
    }
  }
}
