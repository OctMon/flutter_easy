import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'api/api.dart';
import 'generated/l10n.dart';
import 'routes.dart';
import 'utils/user/service.dart';

Future<void> initApp() async {
  // 存储沙盒中的密钥
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // 加载用户信息
  await Get.putAsync(() => UserService().load());

  // 初始化Api
  configAPI(null);

  EasyLoading.instance.maskType = EasyLoadingMaskType.black;

  colorWithBrightness = Brightness.dark;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      initialRoute: Routes.splash,
      getPages: Routes.routes,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocaleNamesLocalizationsDelegate(),
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Get.deviceLocale,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        logDebug("localeResolutionCallback: $locale");
        if (locale == null || !S.delegate.isSupported(locale)) {
          return null;
        }
        return locale;
      },
    );
  }
}
