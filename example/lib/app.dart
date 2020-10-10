import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'api/api.dart';
import 'routes.dart';
import 'store/user_store/store.dart';

Future<void> initApp() async {
  // 存储沙盒中的密钥
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // 加载用户信息
  await UserStore.load();
  // 获取登录状态
  routesIsLogin = () => UserStore.store.getState().isLogin;

  configApi(null);

  colorWithBrightness = Brightness.dark;
}

/// 创建应用的根 Widget
/// 1. 创建一个简单的路由，并注册页面
/// 2. 对所需的页面进行和 AppStore 的连接
/// 3. 对所需的页面进行 AOP 的增强
Widget createApp() {
  return BaseApp(
    // home: Routes.routes.buildPage(Routes.root, null),
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        return Routes.routes.buildPage(settings.name, settings.arguments);
      });
    },
  );
}
