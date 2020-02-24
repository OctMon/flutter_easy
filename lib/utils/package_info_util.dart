import 'package:package_info/package_info.dart';
import 'package:flutter_easy/utils/global_util.dart';

class PackageInfoUtil {
  PackageInfoUtil._();

  static PackageInfo packageInfo;

  /// 初始化应用信息
  static Future<PackageInfo> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}

/// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
final String appName = isWeb ? webAppName : PackageInfoUtil.packageInfo.appName;

/// The app package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
final String appPackageName =
    isWeb ? webAppPackageName : PackageInfoUtil.packageInfo.packageName;

/// The app package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
final String appVersion =
    isWeb ? webAppVersion : PackageInfoUtil.packageInfo.version;

/// The app build number. `CFBundleVersion` on iOS, `versionCode` on Android.
final String appBuildNumber =
    isWeb ? webAppBuildNumber : PackageInfoUtil.packageInfo.buildNumber;
