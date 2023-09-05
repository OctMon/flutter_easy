import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import 'api/api.dart';
import 'generated/l10n.dart';
import 'routes.dart';
import 'store/user/store.dart';

Future<void> initApp() async {
  // Encrypt password
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // Load user info
  await Get.putAsync(() => UserStore().load());
  // Load API
  configAPI(null);

  BaseWebImage.logEnabled = true;
  baseWebImageHandleLoadingProgress = true;
  baseWebImageDefaultErrorPlaceholder = const Icon(Icons.wifi_tethering_error);
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
        if (locale.languageCode == "zh") {
          return const Locale("zh", "CN");
        }
        return locale;
      },
    );
  }
}
