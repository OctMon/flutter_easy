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
void main() {
  createEasyApp(
    initCallback: initApp,
    initView: initView,
    appBaseURLChangedCallback: () {
      showToast("current: $kBaseURLType");
      1.delay(() {
        main();
      });
    },
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
```

app.dart

```dart
const _localeKey = "locale";

Future<void> initApp() async {
  StorageUtil.setEncrypt("963K3REfb30szs1n");
  await UserStore.load();
  routesIsLogin = () => UserStore.store.getState().isLogin;
  configApi(null);
  lastStorageLocale = await getStorageString(_localeKey);
  colorWithBrightness = Brightness.dark;
}

Widget get initView {
  return BaseLaunchLocal(
    child: Image.asset(assetsImagesPath("launch/flutter_logo_color")),
  );
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
      locale: lastLocale,
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        logWTF("localeResolutionCallback: $locale");
        if (lastLocale == null || !S.delegate.isSupported(locale)) {
          return null;
        }
        return locale;
      },
    );
  }
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

