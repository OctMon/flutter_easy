import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import 'api/api.dart';
import 'generated/l10n.dart';
import 'routes.dart';
import 'store/user_store/store.dart';

const _localeKey = "locale";
String lastLocale;

Future<void> initApp() async {
  // 存储沙盒中的密钥
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // 加载用户信息
  await UserStore.load();
  // 获取登录状态
  routesIsLogin = () => UserStore.store.getState().isLogin;

  configApi(null);

  lastLocale = await getStorageString(_localeKey);

  colorWithBrightness = Brightness.dark;
}

/// 创建应用的根 Widget
/// 1. 创建一个简单的路由，并注册页面
/// 2. 对所需的页面进行和 AppStore 的连接
/// 3. 对所需的页面进行 AOP 的增强
Widget createApp() {
  return App();
}

Future<void> Function(Locale) onLocaleChange;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Locale locale;

  @override
  void initState() {
    if (lastLocale != null) {
      Locale _locale = Locale(lastLocale);
      List<String> list = lastLocale.split("_");
      if (list.length > 1) {
        _locale = Locale(list.first, list.last);
      }
      if (S.delegate.isSupported(_locale)) {
        locale = _locale;
      }
    }
    onLocaleChange = (locale) async {
      logWTF("$locale");
      if (locale != null) {
        lastLocale = "$locale";
        await setStorageString(_localeKey, lastLocale);
      } else {
        lastLocale = null;
        removeStorage(_localeKey);
      }
      this.locale = locale;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 500));
      return;
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      // home: Routes.routes.buildPage(Routes.root, null),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<Object>(builder: (BuildContext context) {
          return Routes.routes.buildPage(settings.name, settings.arguments);
        });
      },
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocaleNamesLocalizationsDelegate(),
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: locale,
    );
  }
}
