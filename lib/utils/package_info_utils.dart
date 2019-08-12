import 'package:package_info/package_info.dart';

class PackageInfoUtils {
  PackageInfoUtils._();

  /// 初始化设备信息
  static void init() {
    _packageInfo.then((info) {
      appName = info.appName;
      appVersion = info.version;
    });
  }
}

Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

/// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
String appName;

/// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
String appVersion;
