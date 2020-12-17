import 'package:package_info/package_info.dart';

import 'global_util.dart';

String _appName;
String _appPackageName;
String _appVersion;
String _appBuildNumber;
bool _usePackage;

class PackageInfoUtil {
  PackageInfoUtil._();

  static PackageInfo packageInfo;

  /// 初始化应用信息
  static Future<PackageInfo> init(
      {String appName,
      String appPackageName,
      String appVersion,
      String appBuildNumber,
      bool usePackage = true}) async {
    _appName = appName;
    _appPackageName = appPackageName;
    _appVersion = appVersion;
    _appBuildNumber = appBuildNumber;
    _usePackage = usePackage;
    if (isMacOS || isPhone) {
      packageInfo = await PackageInfo.fromPlatform();
      return packageInfo;
    }
    return null;
  }
}

/// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
final String appName = ((isMacOS || isPhone) && _usePackage)
    ? PackageInfoUtil.packageInfo.appName
    : _appName;

/// The app package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
final String appPackageName = ((isMacOS || isPhone) && _usePackage)
    ? PackageInfoUtil.packageInfo.packageName
    : _appPackageName;

/// The app package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
final String appVersion = ((isMacOS || isPhone) && _usePackage)
    ? PackageInfoUtil.packageInfo.version
    : _appVersion;

/// The app build number. `CFBundleVersion` on iOS, `versionCode` on Android.
final String appBuildNumber = ((isMacOS || isPhone) && _usePackage)
    ? PackageInfoUtil.packageInfo.buildNumber
    : _appBuildNumber;
