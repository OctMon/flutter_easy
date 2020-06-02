import 'package:package_info/package_info.dart';
import 'package:flutter_easy/utils/global_util.dart';

class PackageInfoUtil {
  PackageInfoUtil._();

  static PackageInfo packageInfo;

  /// 初始化应用信息
  static Future<PackageInfo> init() async {
    if (isPhone) {
      packageInfo = await PackageInfo.fromPlatform();
      return packageInfo;
    }
  }
}

/// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
final String appName =
    isPhone ? PackageInfoUtil.packageInfo.appName : webAppName;

/// The app package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
final String appPackageName =
    isPhone ? PackageInfoUtil.packageInfo.packageName : webAppPackageName;

/// The app package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
final String appVersion =
    isPhone ? PackageInfoUtil.packageInfo.version : webAppVersion;

/// The app build number. `CFBundleVersion` on iOS, `versionCode` on Android.
final String appBuildNumber =
    isPhone ? PackageInfoUtil.packageInfo.buildNumber : webAppBuildNumber;
