import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'api/api.dart';
import 'generated/l10n.dart';
import 'routes.dart';
import 'store/user_store/store.dart';

const _localeKey = "locale";

Future<void> initApp() async {
  // 存储沙盒中的密钥
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // 加载用户信息
  await UserStore.load();
  // 获取登录状态
  routesIsLogin = () => UserStore.store.getState().isLogin;

  // 初始化Api
  configAPI(null);

  EasyLoading.instance..maskType = EasyLoadingMaskType.black;

  // 加载手动配置的locale
  lastStorageLocale = await getStorageString(_localeKey);

  colorWithBrightness = Brightness.dark;
}

Widget get initView {
  return BaseLaunchLocal(
    child: Image.asset(assetsImagesPath("launch/flutter_logo_color")),
  );
}

/// 创建应用的根 Widget
/// 1. 创建一个简单的路由，并注册页面
/// 2. 对所需的页面进行和 AppStore 的连接
/// 3. 对所需的页面进行 AOP 的增强
Widget createApp() {
  return App();
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    onLocaleChange = (locale) async {
      logWTF("$locale");
      if (locale != null) {
        lastStorageLocale = "$locale";
        await setStorageString(_localeKey, lastStorageLocale);
      } else {
        lastStorageLocale = null;
        removeStorage(_localeKey);
      }
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
          return Routes.fRoutes.buildPage(settings.name, settings.arguments);
        });
      },
      getPages: Routes.routes,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocaleNamesLocalizationsDelegate(),
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: lastLocale,
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        logWTF("localeResolutionCallback: $locale");
        if (lastLocale == null ||
            locale == null ||
            !S.delegate.isSupported(locale)) {
          return null;
        }
        return locale;
      },
    );
  }
}
