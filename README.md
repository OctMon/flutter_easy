[![flutter_easy](https://socialify.git.ci/OctMon/flutter_easy/image?description=1&descriptionEditable=A%20common%20Flutter%20package.&font=Inter&forks=1&issues=1&logo=https%3A%2F%2Fraw.githubusercontent.com%2Fflutter%2Fwebsite%2Fmaster%2Fsrc%2F_assets%2Fimage%2Fflutter-lockup.png&owner=1&pattern=Floating%20Cogs&pulls=1&stargazers=1&theme=Dark)](https://octmon.github.io/)

# flutter_easy

[![pub](https://img.shields.io/pub/v/flutter_easy.svg)](https://pub.dev/packages/flutter_easy)
[![flutter](https://img.shields.io/badge/flutter-Android%7CiOS%7CWeb%7CWindows%7CMac-blue.svg)](https://flutter.dev)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/OctMon/flutter_easy/blob/main/LICENSE)
[![build](https://github.com/OctMon/flutter_easy/workflows/build/badge.svg)](https://github.com/OctMon/flutter_easy/actions)

A common Flutter package.
[Example](https://octmon.github.io/flutter_easy/)

## HarmonyOS（鸿蒙基础功能已支持）

example 已通过 HarmonyOS 5.1.0 / API 18 ARM64 模拟器的构建、安装、启动和主页跳转验证，
尚未完成真机及全部功能验收。实际验证使用 Flutter OH `3.41.10-ohos-1.0.1`（Dart 3.11.5）。

鸿蒙应用需要在**自己的 `pubspec.yaml`** 中额外添加以下平台实现，保留原有的
`flutter_easy` 依赖。主包尚未自动引入这些实现，example 的依赖也不会传递给使用者的应用。

```yaml
dependencies:
  # 鸿蒙存储、目录、应用信息和设备信息实现
  shared_preferences_ohos: 2.2.0
  path_provider_ohos: 2.2.1
  package_info_plus_harmonyos: 0.0.1
  device_info_plus_harmonyos: 0.0.5

  # 使用 URL 打开/检测功能时添加；完整 example 需要此项
  url_launcher_ohos: ^6.3.0
```

这些版本与当前 `flutter_easy` 的依赖组合一起通过验证；升级任一相关包后需重新验证兼容性。
其中应用信息和设备信息适配包要求 Flutter ≥3.27、Dart ≥3.6.2，Flutter 3.24.5 无法解析此依赖组合。
鸿蒙构建和运行必须使用 Flutter OH；上游标准 Flutter SDK 不能代替 Flutter OH 构建 `ohos/` 工程。

添加依赖后，使用 Flutter OH 执行 `flutter pub get` 和鸿蒙构建命令，由工具生成平台插件注册文件。
业务代码继续使用原有插件 API，无需手动修改生成的注册文件。这些适配包只声明 `ohos` 平台，
Android/iOS 继续使用原有平台实现；但新增依赖的 SDK 版本约束对整个应用都生效。

目前网络状态、分享，以及 example 的图片和文件选择仍需接入相应鸿蒙实现，
不能据此宣称全部功能已支持鸿蒙。工具链、宿主工程及 DevEco 运行步骤见
[example 鸿蒙运行说明](example/README.md)。

## Getting Started

Additional arguments:
```
--dart-define=app-debug-flag=true
```

Run:
```bash
flutter run --release --dart-define=app-debug-flag=true
```

[Example:](https://www.octmon.com/example)

main.dart

```dart
void main() async {
  await initEasyApp(
    appBaseURLChangedCallback: () {
      // Reload API
      configAPI(null);
    },
  );
  await initApp();
  runApp(const MyApp());
  if (isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Set overlay style status bar. It must run after MyApp(), because MaterialApp may override it.
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
```

app.dart

```dart
Future<void> initApp() async {
  // Encrypt password
  StorageUtil.setEncrypt("XxXxXxXxXxXxXxXxX");
  // Load user info
  await Get.putAsync(() => UserService().load());
  // Load API
  configAPI(null);
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

