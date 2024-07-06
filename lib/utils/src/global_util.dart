import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/utils/src/device_info_util.dart';
import 'package:flutter_easy/utils/src/package_info_util.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

bool get isIPad {
  final deviceInfo = DeviceInfoUtil.deviceInfo;
  if (deviceInfo is IosDeviceInfo) {
    return deviceInfo.utsname.machine.toLowerCase().contains("ipad");
  }
  return false;
}

bool isDesktop = (kIsWeb || isPhone) ? false : true;

bool isWeb = kIsWeb;

String get operatingSystem => isWeb ? "web" : Platform.operatingSystem;

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

/// 应用程序可以存储持久文件的目录的路径 iOS and macOS
Future<Directory> getAppLibraryDirectory() => getLibraryDirectory();

/// 应用程序可以放置应用程序支持的目录的路径
Future<Directory> getAppSupportDirectory() => getApplicationSupportDirectory();

/// 应用程序可以访问顶级存储的目录的路径 Android
Future<Directory?> getAppExternalStorageDirectory() =>
    getExternalStorageDirectory();

/// Gets the part of [path] after the last separator.
///
///     p.basename('path/to/foo.dart'); // -> 'foo.dart'
///     p.basename('path/to');          // -> 'to'
///
/// Trailing separators are ignored.
///
///     p.basename('path/to/'); // -> 'to'
String getBasename(String path) => basename(path);

/// Gets the part of [path] after the last separator, and without any trailing
/// file extension.
///
///     p.basenameWithoutExtension('path/to/foo.dart'); // -> 'foo'
///
/// Trailing separators are ignored.
///
///     p.basenameWithoutExtension('path/to/foo.dart/'); // -> 'foo'
String getBasenameWithoutExtension(String path) =>
    basenameWithoutExtension(path);

/// Gets the file extension of [path]: the portion of [basename] from the last
/// `.` to the end (including the `.` itself).
///
///     p.extension('path/to/foo.dart');    // -> '.dart'
///     p.extension('path/to/foo');         // -> ''
///     p.extension('path.to/foo');         // -> ''
///     p.extension('path/to/foo.dart.js'); // -> '.js'
///
/// If the file name starts with a `.`, then that is not considered the
/// extension:
///
///     p.extension('~/.bashrc');    // -> ''
///     p.extension('~/.notes.txt'); // -> '.txt'
///
/// Takes an optional parameter `level` which makes possible to return
/// multiple extensions having `level` number of dots. If `level` exceeds the
/// number of dots, the full extension is returned. The value of `level` must
/// be greater than 0, else `RangeError` is thrown.
///
///     p.extension('foo.bar.dart.js', 2);   // -> '.dart.js
///     p.extension('foo.bar.dart.js', 3);   // -> '.bar.dart.js'
///     p.extension('foo.bar.dart.js', 10);  // -> '.bar.dart.js'
///     p.extension('path/to/foo.bar.dart.js', 2);  // -> '.dart.js'
String getExtension(String path, [int level = 1]) => extension(path, level);

/// Gets the part of [path] before the last separator.
///
///     p.dirname('path/to/foo.dart'); // -> 'path/to'
///     p.dirname('path/to');          // -> 'path'
///
/// Trailing separators are ignored.
///
///     p.dirname('path/to/'); // -> 'path'
///
/// If an absolute path contains no directories, only a root, then the root
/// is returned.
///
///     p.dirname('/');  // -> '/' (posix)
///     p.dirname('c:\');  // -> 'c:\' (windows)
///
/// If a relative path has no directories, then '.' is returned.
///
///     p.dirname('foo');  // -> '.'
///     p.dirname('');  // -> '.'
String getDirname(String path) => dirname(path);

/// Joins the given path parts into a single path using the current platform's
/// [separator]. Example:
///
///     p.join('path', 'to', 'foo'); // -> 'path/to/foo'
///
/// If any part ends in a path separator, then a redundant separator will not
/// be added:
///
///     p.join('path/', 'to', 'foo'); // -> 'path/to/foo'
///
/// If a part is an absolute path, then anything before that will be ignored:
///
///     p.join('path', '/to', 'foo'); // -> '/to/foo'
String getJoin(String part1,
        [String? part2,
        String? part3,
        String? part4,
        String? part5,
        String? part6,
        String? part7,
        String? part8,
        String? part9,
        String? part10,
        String? part11,
        String? part12,
        String? part13,
        String? part14,
        String? part15,
        String? part16]) =>
    join(part1, part2, part3, part4, part5, part6, part7, part8, part9, part10,
        part11, part12, part13, part14, part15, part16);

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
  HapticFeedback.vibrate();
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

String appStoreUserReviewsUrl(String appId) => isIOS
    ? "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&id=$appId"
    : appStoreUrl(appId);

String appStoreWriteReview(String appId) => isIOS
    ? "itms-apps://itunes.apple.com/app/id$appId?mt=8&action=write-review"
    : appStoreUrl(appId);

Future<bool> canLaunch(String urlString) =>
    urlLauncher.canLaunchUrl(Uri.parse(urlString));

typedef BaseLaunchMode = urlLauncher.LaunchMode;

Future<bool> onLaunch(
  String urlString, {
  BaseLaunchMode mode = BaseLaunchMode.platformDefault,
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
