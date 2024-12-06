import 'dart:developer' as developer;
import 'dart:io';

import 'package:dart_art/dart_art.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';

LogFile? logFile;

String _costumeSplitter = " ";

String _addCostumeSplitter(String? message) =>
    message == null || message == '' ? '' : "[$message]";

String _colorize(String message, LoggerLevel logLevel) {
  if (logLevel.ansiColor == null) return message;
  return logLevel.ansiColorTemplate.replaceFirst("@message", message);
}

void _log(LoggerLevel level, dynamic message) {
  final dateTime = DateTime.now();
  var timestamp = _addCostumeSplitter(
      '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}');
  var logLevel = _addCostumeSplitter(level.name);
  var formattedMessage = timestamp + _costumeSplitter + logLevel;
  formattedMessage += _costumeSplitter + "$message";

  logFile?.log(formattedMessage);

  if (isDebug || isAppDebugFlag) {
    if (isIOS) {
      developer.log(formattedMessage, name: appName);
    } else {
      var colorMessage =
          _addCostumeSplitter(appName) + _costumeSplitter + formattedMessage;
      colorMessage = _colorize(formattedMessage, level);

      for (var line in colorMessage.split('\n')) {
        print(line);
        if (line.length >= 966) {
          developer.log("\n" + line, name: appName);
        }
      }
    }
  }
}

class LogFile {
  final buffer = <String>[];

  late String fileNamePattern = '@id.log';

  final String location;

  late BinarySize singleFileSizeLimit = BinarySize.parse('500 MB')!;

  late String _fileId = "";

  late bool enable;

  DateFormat _format = DateFormat("yyyy-MM-dd HH:mm:ss");

  late int _hours = 6;

  LogFile(this.location,
      {required bool enable,
      String? singleFileSizeLimit,
      int? singleFileHourLimit}) {
    if (singleFileSizeLimit != null) {
      final size = BinarySize.parse(singleFileSizeLimit);
      if (size != null) {
        this.singleFileSizeLimit = size;
      }
    }
    if (singleFileHourLimit != null) {
      _hours = singleFileHourLimit;
    }
    getFileId();
    this.enable = enable;
  }

  void getFileId() {
    var maxFileName = "";
    for (var pathStr in files()) {
      var name = Path.basename(pathStr);
      name = name.replaceAll(".log", "");
      maxFileName = maxFileName.compareTo(name) < 0 ? name : maxFileName;
    }
    if (DateTime.tryParse(maxFileName) != null &&
        DateTime.now()
            .subtract(Duration(hours: _hours))
            .isBefore(DateTime.parse(maxFileName))) {
      _fileId = maxFileName;
    } else {
      _fileId = _format.format(DateTime.now());
    }
  }

  String getFileName() {
    var file = File('$location/$_fileId.log');
    if (file.existsSync()) {
      var size = BinarySize()..bytesCount = file.lengthSync();
      if (DateTime.tryParse(_fileId) != null &&
          DateTime.parse(_fileId)
              .add(Duration(hours: _hours))
              .isAfter(DateTime.now()) &&
          size < singleFileSizeLimit) {
        return "$_fileId.log";
      }
    }
    clearCache();
    _fileId = _format.format(DateTime.now());
    return "$_fileId.log";
  }

  void log(String message) {
    if (enable) {
      _pushLine(message);
    }
  }

  void _pushLine(String line) {
    buffer.add(line);

    // if (options.useBuffer == false || buffer.length >= options.bufferLineLength) {
    flush();

    buffer.clear();
    // }
  }

  void flush() {
    var file = File('$location/${getFileName()}');
    if (file.existsSync() == false) {
      file.createSync(recursive: true);
    }

    var content = '${buffer.join('\n')}\n';
    file.writeAsStringSync(content, mode: FileMode.writeOnlyAppend);
  }

  Future<String> read() {
    var file = File('$location/${getFileName()}');
    if (file.existsSync() == false) {
      file.createSync(recursive: true);
    }

    return file.readAsString();
  }

  Future<File?> getCurrentFile() async {
    var file = File('$location/${getFileName()}');
    if (file.existsSync() == false) {
      return null;
    }
    return file;
  }

  Future<int> filesCount() async {
    var dir = Directory(location);
    if (dir.existsSync()) {
      return await dir.list().length;
    }
    return 0;
  }

  Future<BinarySize?> filesSize() async {
    var dir = Directory(location);
    if (dir.existsSync()) {
      int totalSize = 0;
      try {
        // 列出目录下的所有文件和子目录
        await for (var entity
            in dir.list(recursive: true, followLinks: false)) {
          // 如果是文件，则获取其大小并累加
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      } catch (e) {
        logError("Error calculating size: $e");
        return null;
      }
      var size = BinarySize()..bytesCount = totalSize;
      return size;
    }
    return null;
  }

  List<String> files() {
    var dir = Directory(location);
    var list = <String>[];
    if (dir.existsSync()) {
      for (var value in dir.listSync()) {
        FileSystemEntityType type = FileSystemEntity.typeSync(value.path);
        if (type == FileSystemEntityType.file) {
          list.add(value.path);
        }
      }
    }
    return list;
  }

  Directory getDir() {
    return Directory(location);
  }

  Future<void> clear() async {
    for (var path in files()) {
      await File(path).delete();
    }
  }

  Future<void> clearCache() async {
    for (var pathStr in files()) {
      var name = Path.basename(pathStr);
      name = name.replaceAll(".log", "");
      if (DateTime.tryParse(name) != null &&
          DateTime.parse(name)
              .isBefore(DateTime.now().subtract(Duration(hours: _hours * 2)))) {
        await File(pathStr).delete();
      } else if ((int.tryParse(name) ?? 0) > 0) {
        int time = int.tryParse(name) ?? 0;
        if (DateTime.fromMillisecondsSinceEpoch(time)
            .isBefore(DateTime.now().subtract(Duration(hours: _hours * 2)))) {
          await File(pathStr).delete();
        }
      }
    }
  }
}

class LogFileClearMode {
  static const oldFiles = 1;

  static const outSizedFiles = 2;
}

class LoggerLevel {
  static LoggerLevel fatal = LoggerLevel('Fatal', ansiColor: '35m');

  static LoggerLevel error = LoggerLevel('Error', ansiColor: '31m');

  static LoggerLevel warning = LoggerLevel('Warning', ansiColor: '33m');

  static LoggerLevel info = LoggerLevel('Info', ansiColor: '32m');

  static LoggerLevel debug = LoggerLevel('Debug', ansiColor: '34m');

  final String name;

  late String? ansiColor;

  String get ansiColorTemplate => "\x1B[$ansiColor@message\x1B[0m";

  LoggerLevel(this.name, {this.ansiColor});
}

void logDebug(dynamic message) {
  _log(LoggerLevel.debug, message);
}

void logInfo(dynamic message) {
  _log(LoggerLevel.info, message);
}

void logWarning(dynamic message) {
  _log(LoggerLevel.warning, message);
}

void logError(dynamic message) {
  _log(LoggerLevel.error, message);
}

void logFatal(dynamic message) {
  _log(LoggerLevel.fatal, message);
}

void logRequest(RequestOptions options) {
  var string = """
\n->->->->->->->->->->Request->->->->->->->->->
[URL] ${options.uri}
[Method]		 ${options.method}
[ConnectTimeout] ${options.connectTimeout}
[ReceiveTimeout] ${options.receiveTimeout}
[FollowRedirects] ${options.followRedirects}
""";
  if (!options.headers.isEmptyOrNull) {
    string += """
[Header]
${jsonEncode(options.headers)}
""";
  }
  if (!options.extra.isEmptyOrNull) {
    string += """
[Extra]
${jsonEncode(options.extra)}
""";
  }
  if (options.data != null) {
    string += """
[Body]
${options.data is Map ? jsonEncode(options.data) : options.data}
""";
  }
  string += "->->->->->->->->->->Request->->->->->->->->->";
  logInfo(string);
}

void logResponse(Result result) {
  if (result.error != null) {
    logWarning("""
\n->->->->->->->->->->Response->->->->->->->->->
[URL] ${result.requestOptions?.uri}
----------------------${result.response?.statusCode}------------------->
[Error] ${result.error}: ${result.message}
->->->->->->->->->->Response->->->->->->->->->
""");
    return;
  }
  var string = """
\n->->->->->->->->->->Response->->->->->->->->->
[URL] ${result.response?.requestOptions.uri}
[Method]		 ${result.response?.requestOptions.method}
[ConnectTimeout] ${result.response?.requestOptions.connectTimeout}
[ReceiveTimeout] ${result.response?.requestOptions.receiveTimeout}
[FollowRedirects] ${result.response?.requestOptions.followRedirects}
""";
  if (result.response?.requestOptions.headers != null &&
      !result.response!.requestOptions.headers.isEmptyOrNull) {
    string += """
[Header]
${jsonEncode(result.response?.requestOptions.headers)}
""";
  }
  if (result.response?.requestOptions.extra != null &&
      !result.response!.requestOptions.extra.isEmptyOrNull) {
    string += """
[Extra]
${jsonEncode(result.response?.requestOptions.extra)}
""";
  }
  if (result.response?.requestOptions.data != null) {
    string += """
[Body]
${result.response?.requestOptions.data is Map ? jsonEncode(result.response?.requestOptions.data) : result.response?.requestOptions.data}
""";
  }
  string +=
      "----------------------${result.response?.statusCode}------------------->";
  if (result.response?.headers != null &&
      !result.response!.headers.isEmptyOrNull) {
    string += """
\n[Header]
${result.response?.headers}
""";
  }
  if (result.response?.extra != null && !result.response!.extra.isEmptyOrNull) {
    string += """
[Extra]
${jsonEncode(result.response?.extra)}
""";
  }
  if (result.response?.data != null) {
    string += """
[Data]
${result.response?.data is Map ? jsonEncode(result.response?.data) : result.response?.data}
""";
  }
  string += "->->->->->->->->->->Response->->->->->->->->->";
  logInfo(string);
}

class EasyLogController extends GetxController {
  final scrollController = ScrollController();

  /// 所有的日志
  var logs = <String>[].obs;

  /// 在最下面标志
  var followBottom = false.obs;

  @override
  void onInit() {
    logFile?.read().then((value) => logs.value = value.split("\n"));
    scrollController.addListener(() {
      updateFollowBottom();
    });
    super.onInit();
  }

  @override
  void onReady() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void updateFollowBottom() {
    if (scrollController.hasClients) {
      var scrolledToBottom =
          scrollController.offset >= scrollController.position.maxScrollExtent;
      followBottom.value = scrolledToBottom;
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      followBottom.value = true;

      var scrollPosition = scrollController.position;
      // scrollController.jumpTo(scrollPosition.maxScrollExtent);
      scrollController.animateTo(
        scrollPosition.maxScrollExtent,
        duration: new Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }
  }

  Future<void> shareText(String text) async {
    await Share.share(text);
  }
}

class EasyLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EasyLogController controller = Get.put(EasyLogController());
    return BaseScaffold(
      appBar: BaseAppBar(
        leading: BaseButton(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Icon(
            Icons.developer_mode,
          ),
          onPressed: () {
            if (!isAppDebugFlag) {
              return;
            }
            showSelectBaseURLTypeAlert().then((success) {
              if (success != null && success) {
                if (baseURLChangedCallback != null) {
                  baseURLChangedCallback!();
                }
              }
            });
          },
        ),
        actions: [
          BaseButton(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              CupertinoIcons.share,
            ),
            onPressed: () {
              controller.shareText(controller.logs.join("\n"));
            },
          ),
          BaseButton(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              CupertinoIcons.bin_xmark,
            ),
            onPressed: () {
              logFile?.clear();
              controller.logs.clear();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final debugColor = LoggerLevel.debug.ansiColor ?? "";
          final infoColor = LoggerLevel.info.ansiColor ?? "";
          final warningColor = LoggerLevel.warning.ansiColor ?? "";
          final errorColor = LoggerLevel.error.ansiColor ?? "";
          final fatalColor = LoggerLevel.fatal.ansiColor ?? "";
          return ListView.separated(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(vertical: 15),
            itemBuilder: (context, index) {
              var log = controller.logs[index];
              Color? color;
              if (log.startsWith("[$debugColor")) {
                color = Colors.blue;
              } else if (log.startsWith("[$infoColor")) {
                color = Colors.green;
              } else if (log.startsWith("[$warningColor")) {
                color = Colors.yellow;
              } else if (log.startsWith("[$errorColor")) {
                color = Colors.red;
              } else if (log.startsWith("[$fatalColor")) {
                color = Colors.deepPurple;
              }
              return Container(
                alignment: Alignment.centerLeft,
                child: BaseButton(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    log,
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                  onPressed: () {
                    setClipboard(log);
                  },
                ),
              );
            },
            itemCount: controller.logs.length,
            separatorBuilder: (BuildContext context, int index) {
              return BaseDivider(
                  thickness: 1, margin: EdgeInsets.symmetric(vertical: 5));
            },
          );
        }),
      ),
      floatingActionButton: Obx(() {
        return AnimatedOpacity(
          opacity: controller.followBottom.value ? 0 : 1,
          duration: Duration(milliseconds: 150),
          child: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              child: Icon(Icons.arrow_downward),
              backgroundColor: appTheme(context).primaryColor,
              onPressed: controller.scrollToBottom,
            ),
          ),
        );
      }),
    );
  }
}
