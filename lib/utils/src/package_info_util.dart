import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoUtil {
  PackageInfoUtil._();

  static late PackageInfo packageInfo;

  /// 初始化应用信息
  static Future<PackageInfo> init() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (e) {
      packageInfo = PackageInfo(
          appName: '', packageName: '', version: '', buildNumber: '');
    }
    return packageInfo;
  }
}

/// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
final String appName = PackageInfoUtil.packageInfo.appName;

/// The app package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
final String appPackageName = PackageInfoUtil.packageInfo.packageName;

/// The app package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
final String appVersion = PackageInfoUtil.packageInfo.version;

/// The app build number. `CFBundleVersion` on iOS, `versionCode` on Android.
final String appBuildNumber = PackageInfoUtil.packageInfo.buildNumber;

final String? appInstallerStore = PackageInfoUtil.packageInfo.installerStore;

final DateTime? appInstallTime = PackageInfoUtil.packageInfo.installTime;

final DateTime? appUpdateTime = PackageInfoUtil.packageInfo.updateTime;
