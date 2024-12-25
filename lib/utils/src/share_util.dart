import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../../components/src/base.dart';
import '../../components/src/base_web_image.dart';
import 'global_util.dart';
import 'loading_util.dart';
import 'logger_util.dart';
import 'package_info_util.dart';

String shareDirectoryName = "share";

String shareAppStoreDownloadURL = "";

extension StringPathExtension on String {
  /// 生成一个临时图片路径
  Future<String> get crateNewSharePath async {
    if (!(await getShareDirectory()).existsSync()) {
      (await getShareDirectory()).createSync();
    }

    String removeQueryParams(String url) {
      return url.split('?').first;
    }

    /// 文件后缀名
    final urlFileNameExtend = getExtension(removeQueryParams(this));

    final date = DateTime.now();
    final timeStamp =
        '${date.year.toString()}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}${date.millisecond.toString().padLeft(3, '0')}';

    final path = getJoin(
        await getShareDirectoryPath(), "$appName$timeStamp$urlFileNameExtend");
    logDebug("share path: $path");
    return path;
  }
}

Future<Directory> getShareDirectory() async => Directory(
    getJoin((await getAppTemporaryDirectory()).path, shareDirectoryName));

Future<String> getShareDirectoryPath() async =>
    (await getShareDirectory()).path;

Future<void> clearShareDirectory() async {
  final dir = await getShareDirectory();
  if (dir.existsSync()) {
    final List<FileSystemEntity> children = dir.listSync();
    for (final FileSystemEntity child in children) {
      child.deleteSync(recursive: true);
      logDebug("delete: $child");
    }
  }
}

Future<ShareResult> shareURL(String url) {
  return Share.shareUri(Uri.parse(url));
}

Future<ShareResult> shareApp() {
  return shareURL(shareAppStoreDownloadURL);
}

Future<ShareResult> shareText(String text, {String? subject}) {
  return Share.share(text, subject: subject);
}

Future<void> shareFile({required String url, String? savePath}) async {
  final path = await downloadFile(url: url, savePath: savePath);

  if (path != null) {
    Share.shareXFiles([XFile(path)]);
  }
}

Future<String?> downloadFile(
    {required String url, String? savePath, bool loading = true}) async {
  if (!BaseEasyLoading.isShow) {
    if (loading) {
      showLoading();
    }
  }

  var file = await _downloadFile(url: url);

  if (file == null) {
    if (loading) {
      dismissLoading();
    }
    return null;
  }
  final path = savePath ?? await url.crateNewSharePath;
  logDebug("download url: $url path: $path");

  await file.copy(path);
  if (loading) {
    dismissLoading();
  }
  return path;
}

Future<File?> _downloadFile({required String url}) async {
  var file = await BaseWebImage.cacheGetFile(url);
  file ??= await BaseWebImage.downloadFile(url);
  return file;
}
