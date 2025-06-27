import 'dart:developer' as developer;
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dart_art/dart_art.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/extension/src/dynamic_extensions.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;

import '../../components/src/base.dart';
import '../../components/src/base_state.dart';
import '../../extension/src/font_extensions.dart';
import '../../routes/routes.dart';
import 'color_util.dart';
import 'date_util.dart';
import 'global_util.dart';
import 'json_util.dart';
import 'network_util.dart';
import 'package_info_util.dart';
import 'share_util.dart';
import 'toast_util.dart';
import 'vendor_util.dart';

LogFile? logFile;

String _costumeSplitter = " ";

String _addCostumeSplitter(String? message) =>
    message == null || message == '' ? '' : "[$message]";

String _colorize(String message, LoggerLevel LoggerLevel) {
  if (LoggerLevel.ansiColor == null) return message;
  return LoggerLevel.ansiColorTemplate.replaceFirst("@message", message);
}

void _log(LoggerLevel level, dynamic message) {
  final dateTime = DateTime.now();
  var timestamp = _addCostumeSplitter(
      '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}');
  var LoggerLevel = _addCostumeSplitter(level.name);
  var formattedMessage = timestamp + _costumeSplitter + LoggerLevel;
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

Future<String> _zipLog(Map<String, dynamic> params) async {
  try {
    String path = params["path"];
    Directory directory = params["dir"];
    File file = File("$path/log.zip");
    if (file.existsSync()) {
      file.deleteSync();
    }
    final encoder = ZipFileEncoder();
    encoder.create("$path/log.zip", level: 9);
    await encoder.addDirectory(directory, level: 9);
    encoder.closeSync();
    return file.path;
  } catch (e) {
    return "";
  }
}

Future<String?> appLogZipFile() async {
  final dir = logFile?.getDir();
  if (dir?.existsSync() ?? false) {
    String path = (await getAppDocumentsDirectory()).path;
    String result = await compute(_zipLog, {
      "path": path,
      "dir": dir,
    });
    if (result.isNotEmpty) {
      return result;
    }
  }
  return null;
}

class LogFile {
  final buffer = <String>[];

  final String? wrapSplitter;

  late String fileNamePattern = '@id.log';

  final String location;

  late BinarySize singleFileSizeLimit = BinarySize.parse('500 MB')!;

  late String _fileId = "";

  late bool enable;

  BaseDateFormat _format = BaseDateFormat("yyyy_MM_dd_HH_mm_ss");

  late int _hours = 24;

  LogFile(this.location,
      {required bool enable,
      this.wrapSplitter,
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
    if (_format.tryParse(maxFileName) != null &&
        DateTime.now()
            .subtract(Duration(hours: _hours))
            .isBefore(_format.parse(maxFileName))) {
      _fileId = maxFileName;
    } else {
      _fileId = _format.format(DateTime.now());
    }
  }

  String getFileName() {
    var file = File('$location/$_fileId.log');
    if (file.existsSync()) {
      var size = BinarySize()..bytesCount = BigInt.from(file.lengthSync());
      if (_format.tryParse(_fileId) != null &&
          _format.parse(_fileId)
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
      _pushLine(wrapSplitter != null
          ? message.replaceAll("\n", wrapSplitter!)
          : message);
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
      var size = BinarySize()..bytesCount = BigInt.from(totalSize);
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
      if (_format.tryParse(name) != null &&
          _format.parse(name)
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

class EasyLogController extends BaseStateController<List<int>> {
  final scrollController = ScrollController();

  var logs = <String>[];
  var searchKeyword = '';
  LoggerLevel? selectedLevel;

  final RxSet<int> expandedIndexes = <int>{}.obs;

  /// 在最下面标志
  var followBottom = true.obs;

  @override
  void onInit() {
    scrollController.addListener(() {
      followBottom.value = scrollController.offset == 0;
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  Future<void> onRequestData() async {
    await 0.25.delay();
    logs = (await logFile?.read())?.split("\n") ?? [];
    logs = logs.reversed.toList();
    filteredIndexes();
  }

  void scrollerToTop() {
    if (scrollController.hasClients) {
      followBottom.value = true;
      scrollController.animateTo(0,
          duration: 0.25.seconds, curve: Curves.bounceIn);
    }
  }

  LoggerLevel? getLevel(String log) {
    final match =
        RegExp(r'\[(Debug|Info|Warning|Error|Fatal)\]').firstMatch(log);
    switch (match?.group(1)?.toLowerCase()) {
      case 'debug':
        return LoggerLevel.debug;
      case 'info':
        return LoggerLevel.info;
      case 'warning':
        return LoggerLevel.warning;
      case 'error':
        return LoggerLevel.error;
      case 'fatal':
        return LoggerLevel.fatal;
      default:
        return null;
    }
  }

  String getLogTime(String log) {
    final match =
        RegExp(r'\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\]').firstMatch(log);
    return match?.group(1) ?? '';
  }

  String getMessage(String log) {
    final match =
        RegExp(r'\[\d{4}-\d{2}-\d{2}.*?\]\s*\[(.*?)\]\s*(.*)').firstMatch(log);
    return match != null ? match.group(2) ?? log : log;
  }

  void filteredIndexes() {
    cleanState();
    expandedIndexes.clear();
    final keyword = searchKeyword.toLowerCase();
    final levelFilter = selectedLevel;
    final indexes = <int>[];

    for (var i = 0; i < logs.length; i++) {
      final log = logs[i];
      final level = getLevel(log);
      final matchLevel = levelFilter == null || level == levelFilter;
      final matchKeyword =
          keyword.isEmpty || log.toLowerCase().contains(keyword);
      if (matchLevel && matchKeyword) indexes.add(i);
    }
    if (indexes.isNotEmpty) {
      change(indexes, status: RxStatus.success());
      scrollerToTop();
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  void toggleExpand(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
  }

  bool isExpanded(int index) => expandedIndexes.contains(index);
}

class EasyLogPage extends StatelessWidget {
  final tabs = [
    const Tab(text: "All"),
    const Tab(text: "Debug"),
    const Tab(text: "Info"),
    const Tab(text: "Warning"),
    const Tab(text: "Error"),
    const Tab(text: "Fatal"),
  ];

  final levels = <LoggerLevel?>[
    null,
    LoggerLevel.debug,
    LoggerLevel.info,
    LoggerLevel.warning,
    LoggerLevel.error,
    LoggerLevel.fatal
  ];

  @override
  Widget build(BuildContext context) {
    final EasyLogController controller = Get.put(EasyLogController());
    return PopScope(
      canPop: false,
      child: BaseScaffold(
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
          centerTitle: true,
          title: BaseTextField(
            backgroundColor:
                Get.isDarkMode ? Colors.grey[900] : Colors.grey[200],
            prefix: Icon(Icons.search).marginOnly(left: 10),
            placeholder: "Search",
            textInputAction: TextInputAction.search,
            onChanged: (val) => controller
              ..searchKeyword = val
              ..filteredIndexes(),
          ),
          actions: [
            BaseButton(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.app_registration,
              ),
              onPressed: () {
                if (!isAppDebugFlag) {
                  return;
                }
                toNamed(routesExampleNamed);
              },
            ),
            BaseButton(
              padding: EdgeInsets.only(left: 15),
              child: Icon(
                CupertinoIcons.share,
              ),
              onPressed: () {
                shareLogZiPFile();
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
        body: DefaultTabController(
          length: levels.length,
          child: Column(
            children: [
              Container(
                height: 30,
                color: context.theme.scaffoldBackgroundColor,
                child: TabBar(
                  tabs: tabs,
                  padding: EdgeInsets.zero,
                  onTap: (index) => controller
                    ..selectedLevel = levels[index]
                    ..filteredIndexes(),
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.bodySmall?.color,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: fontWeightSemiBold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: fontWeightSemiBold,
                  ),
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerHeight: 0,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: controller.baseState((state) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    controller: controller.scrollController,
                    reverse: true,
                    itemCount: state?.length ?? 0,
                    itemBuilder: (_, idx) {
                      if (state == null) return SizedBox.shrink();
                      final index = state[idx];
                      final log = controller.logs[index];
                      final level =
                          controller.getLevel(log) ?? LoggerLevel.info;
                      final message = controller.getMessage(log);

                      return Obx(() {
                        final expanded =
                            controller.isExpanded(index); // ✅ 每次都响应式获取
                        return InkWell(
                          onTap: () => controller.toggleExpand(index),
                          onLongPress: () {
                            setClipboard(log);
                            showToast("Log copied", duration: 1.seconds);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300)),
                              color: _getLevelColor(level).withOpacity(0.05),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(_getLevelIcon(level),
                                        size: 18, color: _getLevelColor(level)),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        "${controller.getLogTime(log)} ${message.split('\n').first}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _getLevelColor(level),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      expanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                if (expanded)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(message),
                                  ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              )
            ],
          ),
        ),
        floatingActionButton: Obx(() {
          final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
          if (keyboardVisible) return const SizedBox.shrink();
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
                onPressed: controller.scrollerToTop,
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _getLevelColor(LoggerLevel level) {
    if (level == LoggerLevel.debug) return Colors.blue;
    if (level == LoggerLevel.info) return Colors.green;
    if (level == LoggerLevel.warning) return Colors.orange;
    if (level == LoggerLevel.error) return Colors.red;
    if (level == LoggerLevel.fatal) return Colors.deepPurple;
    return Colors.black;
  }

  IconData _getLevelIcon(LoggerLevel level) {
    if (level == LoggerLevel.debug) return Icons.bug_report;
    if (level == LoggerLevel.info) return Icons.info;
    if (level == LoggerLevel.warning) return Icons.warning;
    if (level == LoggerLevel.error) return Icons.error;
    if (level == LoggerLevel.fatal) return Icons.dangerous;
    return Icons.help_outline;
  }
}
