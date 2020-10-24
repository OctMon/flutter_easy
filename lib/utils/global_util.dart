import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import 'hw/hw_mp.dart' as mp;

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

final bool isDebug = _isDebug();

bool _debugFlag = false;

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

bool isAndroid = kIsWeb ? false : Platform.isAndroid;

bool isWeb = kIsWeb;

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

/// 将文本内容复制到剪贴板
Future<void> setClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// 获取剪贴板内容
Future<String> getClipboard() =>
    Clipboard.getData(Clipboard.kTextPlain).then((data) => data?.text);

const kPathIcons = "icons/";
const kPathOthers = "others/";

/// 获取图片路径
String assetsImagesPathWebP(String name) =>
    assetsImagesPath(name, format: 'webp');

/// 获取图片路径
String assetsImagesPath(String name, {String format = "png"}) =>
    "assets/images/$name.$format";

/// 随机数(0-max)小于max
int randomInt(int max) => Random().nextInt(max);

String appStoreUrl(String appId) => "https://apps.apple.com/cn/app/id" + appId;

String appStoreUserReviewsUrl(String appId) =>
    "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&id=" +
    appId;

String appStoreWriteReview(String name, String appId) =>
    "itms-apps://itunes.apple.com/us/app/$name/id$appId?mt=8&action=write-review";

Future<bool> canLaunch(String urlString) => urlLauncher.canLaunch(urlString);

Future<bool> onLaunch(
  String urlString, {
  bool forceSafariVC,
  bool forceWebView,
  bool enableJavaScript,
  bool enableDomStorage,
  bool universalLinksOnly,
  Map<String, String> headers,
  Brightness statusBarBrightness,
}) =>
    urlLauncher.launch(urlString,
        forceSafariVC: forceSafariVC,
        forceWebView: forceWebView,
        enableJavaScript: enableJavaScript,
        enableDomStorage: enableDomStorage,
        universalLinksOnly: universalLinksOnly,
        headers: headers,
        statusBarBrightness: statusBarBrightness);
