import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

// TODO:运行非web报错的时候注掉即可
// import 'package:shared_preferences_web/shared_preferences_web.dart';
// import 'dart:html' as html;

void main() {
  createEasyApp(
    // TODO:运行非web报错的时候注掉即可
    // sharedPreferencesWebInstance: SharedPreferencesPlugin(),
    // webUserAgent: html.window.navigator.userAgent.toLowerCase(),
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
        title: BaseText(appName),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FixedColumnWidth(adaptDp(130)),
          },
          border: TableBorder.all(
            color: colorWithTint,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          children: [
            TableRow(
              //第一行样式 添加背景色
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              children: [
                Center(child: Text('code')),
                Center(child: Text('value')),
              ],
            ),
            TableRow(
              children: [
                Center(child: Text('appName')),
                Center(child: Text('$appName')),
              ],
            ),
            TableRow(
              children: [
                Center(child: Text('appPackageName')),
                Center(child: Text('$appPackageName')),
              ],
            ),
            TableRow(children: [
              Center(child: Text('appBuildNumber')),
              Center(child: Text('$appBuildNumber')),
            ]),
            TableRow(
              children: [
                Center(child: Text('appVersion')),
                Center(child: Text('$appVersion')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
