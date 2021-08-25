[![flutter_easy](https://socialify.git.ci/OctMon/flutter_easy/image?description=1&descriptionEditable=A%20common%20Flutter%20package.&font=Inter&forks=1&issues=1&logo=https%3A%2F%2Fraw.githubusercontent.com%2Fflutter%2Fwebsite%2Fmaster%2Fsrc%2F_assets%2Fimage%2Fflutter-lockup.png&owner=1&pattern=Floating%20Cogs&pulls=1&stargazers=1&theme=Dark)](https://octmon.github.io/)

# flutter_easy

[![pub](https://img.shields.io/pub/v/flutter_easy.svg)](https://pub.dev/packages/flutter_easy)
[![flutter](https://img.shields.io/badge/flutter-Android%7CiOS%7CWeb%7CWindows%7CMac-blue.svg)](https://flutter.dev)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/OctMon/flutter_easy/blob/main/LICENSE)
[![build](https://github.com/OctMon/flutter_easy/workflows/build/badge.svg)](https://github.com/OctMon/flutter_easy/actions)

A common Flutter package.

## Getting Started

Additional arguments:
```
--dart-define=app-debug-flag=true
```

Run:
```bash
flutter run --release --dart-define=app-debug-flag=true
```

[Example:](https://github.com/OctMon/flutter_easy/releases)

main.dart

```dart
createEasyApp(
    initCallback: initApp,
    initView: initView,
    appBaseURLChangedCallback: () {
      // Reload API
      configAPI(null);
    },
    completionCallback: () {
      runApp(App());
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
```

app.dart

```dart
Future<void> initApp() async {
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  await Get.putAsync(() => UserService().load());
  configApi(null);
  colorWithBrightness = Brightness.dark;
}

Widget get initView {
  return BaseLaunchLocal(
    child: Image.asset(assetsImagesPath("launch/flutter_logo_color")),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      initialRoute: Routes.splash,
      getPages: Routes.routes,
      localizationsDelegates: [
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
```

routes.dart

```dart
class Routes {
  static final String root = '/';
  static final String splash = '/splash';

  Routes._();

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.root,
      page: () => RootPage(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => SplashPage(),
    ),
    GetPage(
      name: routesLoginNamed,
      page: () => LoginPage(),
    ),
}
```



# Installing

Add flutter_easy to your pubspec.yaml file:

```yaml
dependencies:
  flutter_easy:
```

Import flutter_easy in files that it will be used:

```dart
import 'package:flutter_easy/flutter_easy.dart';
```

