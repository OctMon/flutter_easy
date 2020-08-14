import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

void main() {
  createEasyApp(
    isSelectBaseURLTypeFlag: true,
    initCallback: initApp,
    completionCallback: () {
      runApp(createApp());
      if (isAndroid) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        // Set overlay style status bar. It must run after MyApp(), because MaterialApp may override it.
        SystemUiOverlayStyle systemUiOverlayStyle =
            SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    },
  );
}

Future<void> initApp() async {
  // 存储混合中的密钥
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // 加载用户信息
//  await UserStore.load();
  // 获取登录状态
//  routesIsLogin = () => UserStore.store.getState().isLogin;

  colorWithBrightness = Brightness.dark;
}

Widget createApp() {
  return BaseApp(
    home: HomePage(),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('flutter_easy example'),
      ),
      body: Center(
        child: Text('Running'),
      ),
    );
  }
}
