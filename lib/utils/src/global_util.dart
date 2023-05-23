import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/utils/src/package_info_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import 'hw/hw_mp.dart' as mp;

const bool isProduction = bool.fromEnvironment("dart.vm.product");

final bool isDebug = _isDebug();

bool _debugFlag = false;

/// 打开app调试模式
bool isAppDebugFlag = false;

/// is app run a debug mode.
bool _isDebug() {
  /// Assert statements have no effect in production code;
  /// they’re for development only. Flutter enables asserts in debug mode.
  assert(() {
    _debugFlag = true;
    return _debugFlag;
  }());
  return _debugFlag;
}

bool isIOS = kIsWeb ? false : Platform.isIOS;

bool isMacOS = kIsWeb ? false : Platform.isMacOS;

bool isWindows = kIsWeb ? false : Platform.isWindows;

bool isLinux = kIsWeb ? false : Platform.isLinux;

bool isAndroid = kIsWeb ? false : Platform.isAndroid;

bool isDesktop = (kIsWeb || isPhone) ? false : true;

bool isWeb = kIsWeb;

String get operatingSystem => Platform.operatingSystem;

String get operatingSystemVersion => Platform.operatingSystemVersion;

String get userAgent => webUserAgent.toLowerCase();

/// https://www.jianshu.com/p/40430596e3ab
String get webUserAgent => mp.webUserAgent;

String get webOrigin => mp.webOrigin;

bool get isWebInIPhone =>
    userAgent.contains("iphone") || userAgent.contains("ipod");

bool get isWebInIPad => userAgent.contains("ipad");

bool get isWebInIos => isWebInIPhone || isWebInIPad;

bool get isWebInAndroid => userAgent.contains("android");

bool get isWebInWeChat => userAgent.contains("Micro" + "Messenger");

bool isPhone = isIOS || isAndroid;

/// flutter run --dart-define=app-channel=official
/// 多渠道打包
/// Android Studio可以配置运行Flutter参数 --dart-define=app-channel=official
const appChannel = String.fromEnvironment('app-channel', defaultValue: '');

/// 将文本内容复制到剪贴板
Future<void> setClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// 获取剪贴板内容
Future<String?> getClipboard() =>
    Clipboard.getData(Clipboard.kTextPlain).then((data) => data?.text);

/// 设备上临时目录的路径，该临时目录未备份且。适用于存储下载文件的缓存
Future<Directory> getAppTemporaryDirectory() => getTemporaryDirectory();

/// 放置数据的目录的路径
Future<Directory> getAppDocumentsDirectory() =>
    getApplicationDocumentsDirectory();

/// 应用程序可以存储持久文件的目录的路径
Future<Directory> getAppLibraryDirectory() => getLibraryDirectory();

/// 应用程序可以放置应用程序支持的目录的路径
Future<Directory> getAppSupportDirectory() => getApplicationSupportDirectory();

const kPathIcons = "icons/";
const kPathOthers = "others/";

/// 获取图片路径后缀wep
String assetsImagesPathWebP(String name) =>
    assetsImagesPath(name, format: 'webp');

/// 获取图片路径后缀svg
String assetsImagesPathSvg(String name) =>
    assetsImagesPath(name, format: 'svg');

/// 获取图片路径
String assetsImagesPath(String name, {String format = "png"}) =>
    "assets/images/$name.$format";

/// 随机数(0-max)小于max
int randomInt(int max) => Random().nextInt(max);

/// 长振动
void hapticFeedbackVibrate() {
  HapticFeedback.vibrate;
}

/// 较轻碰撞振动
void hapticFeedbackLightImpact() {
  HapticFeedback.lightImpact();
}

/// 中等碰撞振动
void hapticFeedbackMediumImpact() {
  HapticFeedback.mediumImpact();
}

/// 较重碰撞振动
void hapticFeedbackHeavyImpact() {
  HapticFeedback.heavyImpact();
}

String appStoreUrl(String appId) => isIOS
    ? "https://apps.apple.com/app/id$appId"
    : "https://play.google.com/store/apps/details?id=$appPackageName";

String appStoreUserReviewsUrl(String appId) =>
    "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&id=$appId";

String appStoreWriteReview(String name, String appId) =>
    "itms-apps://itunes.apple.com/us/app/$name/id$appId?mt=8&action=write-review";

Future<bool> canLaunch(String urlString) =>
    urlLauncher.canLaunchUrl(Uri.parse(urlString));

Future<bool> onLaunch(
  String urlString, {
  urlLauncher.LaunchMode mode = urlLauncher.LaunchMode.platformDefault,
  urlLauncher.WebViewConfiguration webViewConfiguration =
      const urlLauncher.WebViewConfiguration(),
  String? webOnlyWindowName,
}) =>
    urlLauncher.launchUrl(Uri.parse(urlString),
        mode: mode,
        webViewConfiguration: webViewConfiguration,
        webOnlyWindowName: webOnlyWindowName);

/// 全局隐藏键盘
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
