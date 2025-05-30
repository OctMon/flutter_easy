import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import 'api/api.dart';
import 'generated/l10n.dart';
import 'routes.dart';
import 'store/user/store.dart';
import 'style.dart';

/// 非首次使用 app
final kNonFirstUseAppKey = "first_open_key".md5;

Future<void> initApp() async {
  // Encrypt password
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  // Load user info
  await Get.putAsync(() => UserStore().load());

  configStyle();

  if (isDebug || isAppDebugFlag) {
    BaseWebImage.logEnabled = true;
    baseWebImageHandleLoadingProgress = true;
  }
  baseWebImageDefaultErrorPlaceholder = const Icon(Icons.wifi_tethering_error);

  // 首次使用 app
  final noFirstOpen = await getStorageBool(kNonFirstUseAppKey);
  if (isAndroid && !noFirstOpen) {
    // 需要在 RootController中 同意隐私弹窗
  } else {
    await initAfterPrivate();
  }
}

Future<void> initAfterPrivate() async {
  final deviceInfo = await DeviceInfoUtil.init();
  logDebug("deviceInfo:\n${deviceInfo.data}");
  // Load API
  await configAPI(null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      useMaterial3: false,
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
