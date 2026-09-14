import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dart_art/dart_art.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/extension/src/dynamic_extensions.dart';
import 'package:get/get.dart';

import '../../components/src/base.dart';
import '../../components/src/base_state.dart';
import '../../extension/src/font_extensions.dart';
import '../../routes/routes.dart';
import 'color_util.dart';
import 'date_util.dart';
import 'global_util.dart';
import 'json_util.dart';
import 'logger/log_backend.dart';
import 'logger/log_backend_factory.dart';
import 'network_util.dart';
import 'package_info_util.dart';
import 'share_util.dart';
import 'toast_util.dart';

LogFile? logFile;

String _costumeSplitter = " ";

String _addCostumeSplitter(String? message) =>
    message == null || message == '' ? '' : "[$message]";

String _colorize(String message, LoggerLevel LoggerLevel) {
  if (LoggerLevel.ansiColor == null) return message;
  return LoggerLevel.ansiColorTemplate.replaceFirst("@message", message);
}

void _log(
  LoggerLevel level,
  dynamic message, {
  String? name,
  String? tag,
  Object? error,
  StackTrace? stackTrace,
}) {
  final dateTime = DateTime.now();
  final rawMessage = '$message';
  final messageBuffer = StringBuffer(rawMessage);
  if (error != null) {
    messageBuffer.write(' error=$error');
  }
  if (stackTrace != null) {
    messageBuffer
      ..write('\n')
      ..write(stackTrace);
  }
  final messageText = messageBuffer.toString();
  var timestamp = _addCostumeSplitter(
      '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}');
  var loggerLevel = _addCostumeSplitter(level.name);
  var formattedMessage = timestamp + _costumeSplitter + loggerLevel;
  formattedMessage += _costumeSplitter + messageText;

  logFile?._write(
    level,
    rawMessage,
    formattedMessage,
    timestamp: dateTime,
    name: name,
    tag: tag,
    error: error?.toString(),
    stackTrace: stackTrace?.toString(),
  );

  if (isDebug || isAppDebugFlag) {
    if (isIOS) {
      developer.log(formattedMessage, name: appName);
    } else {
      var colorMessage = _colorize(formattedMessage, level);

      for (var line in colorMessage.split('\n')) {
        print(line);
        if (line.length >= 966) {
          developer.log("\n" + line, name: appName);
        }
      }
    }
  }
}

void _reportLogBackendFailure(Object error, StackTrace stackTrace) {
  var loggerName = 'flutter_easy';
  try {
    if (appName.isNotEmpty) {
      loggerName = appName;
    }
  } catch (_) {
    // PackageInfoUtil may not have been initialized by direct LogFile users.
  }
  developer.log(
    'Log backend failure: $error',
    name: loggerName,
    error: error,
    stackTrace: stackTrace,
  );
}

Future<String?> appLogZipFile() async {
  final file = logFile;
  if (file == null) {
    return null;
  }
  try {
    final path = (await getAppDocumentsDirectory()).path;
    return await file.createArchive(path);
  } catch (error, stackTrace) {
    _reportLogBackendFailure(error, stackTrace);
    return null;
  }
}

class LogFile {
  final buffer = <String>[];

  final String? wrapSplitter;

  late String fileNamePattern = '@id.log';

  final String location;

  late BinarySize singleFileSizeLimit = BinarySize.parse('500 MB')!;

  late String _fileId = "";

  late int _hours = 24;

  late final EasyLogBackend _backend;
  late final Future<void> _initializing;
  final List<EasyLogBackendRecord> _pendingRecords = <EasyLogBackendRecord>[];
  bool _initialized = false;
  bool _enable = false;
  int _sequence = 0;

  static const int _memoryBufferLimit = 2000;

  LogFile(this.location,
      {required bool enable,
      this.wrapSplitter,
      String? singleFileSizeLimit,
      int? singleFileHourLimit,
      String? nameSpace,
      LoggerLevel? minLevel,
      Duration? retention,
      int maxDiskSizeBytes = 0}) {
    if (singleFileSizeLimit != null) {
      final size = BinarySize.parse(singleFileSizeLimit);
      if (size != null) {
        this.singleFileSizeLimit = size;
      }
    }
    if (singleFileHourLimit != null) {
      _hours = singleFileHourLimit;
    }
    _enable = enable;
    _backend = createEasyLogBackend(
      EasyLogBackendConfig(
        location: location,
        nameSpace: _validNameSpace(nameSpace),
        enabled: enable,
        minLevel: (minLevel ?? LoggerLevel.debug).nativeValue,
        rotationHours: _hours <= 0 ? 24 : _hours,
        singleFileSizeBytes: this.singleFileSizeLimit.bytesCount.toInt(),
        retention: retention ?? const Duration(hours: 48),
        maxDiskSizeBytes: maxDiskSizeBytes,
      ),
      onFailure: _reportLogBackendFailure,
    );
    _initializing = _initialize();
  }

  bool get enable => _enable;

  set enable(bool value) {
    _enable = value;
    _backend.enable = value;
  }

  Future<void> _initialize() async {
    await _backend.initialize();
    _initialized = true;
    final pending = List<EasyLogBackendRecord>.of(_pendingRecords);
    _pendingRecords.clear();
    for (final record in pending) {
      _backend.write(record);
    }
  }

  Future<void> initialize() => _initializing;

  void getFileId() {
    _fileId = getFileName().replaceAll(RegExp(r'\.(log|mx)$'), '');
  }

  String getFileName() {
    final current = _backend.currentFileObject;
    final path = current?.path?.toString() ?? '';
    if (path.isEmpty) {
      return _fileId.isEmpty ? '' : _fileId;
    }
    return path.split(RegExp(r'[/\\]')).last;
  }

  void log(String message) {
    _write(
      LoggerLevel.info,
      message,
      message,
      timestamp: DateTime.now(),
    );
  }

  void _write(
    LoggerLevel level,
    String message,
    String formattedMessage, {
    required DateTime timestamp,
    String? name,
    String? tag,
    String? error,
    String? stackTrace,
  }) {
    if (!enable) {
      return;
    }
    final persistedMessage = wrapSplitter == null
        ? message
        : message.replaceAll('\n', wrapSplitter!);
    final persistedFormatted = wrapSplitter == null
        ? formattedMessage
        : formattedMessage.replaceAll('\n', wrapSplitter!);
    final record = EasyLogBackendRecord(
      sequenceId: ++_sequence,
      timestamp: timestamp,
      level: level.nativeValue,
      message: persistedMessage,
      formattedMessage: persistedFormatted,
      name: name,
      tag: tag,
      error: error,
      stackTrace: stackTrace == null
          ? null
          : (wrapSplitter == null
              ? stackTrace
              : stackTrace.replaceAll('\n', wrapSplitter!)),
    );
    buffer.add(persistedFormatted);
    if (buffer.length > _memoryBufferLimit) {
      buffer.removeRange(0, buffer.length - _memoryBufferLimit);
    }
    if (_initialized) {
      _backend.write(record);
    } else {
      _pendingRecords.add(record);
    }
  }

  void flush() {
    unawaited(flushAsync().catchError((Object error, StackTrace stackTrace) {
      _reportLogBackendFailure(error, stackTrace);
    }));
  }

  Future<void> flushAsync() async {
    await initialize();
    await _backend.flush();
  }

  Future<String> read() async {
    await initialize();
    if (_backend.isBinary) {
      return buffer.isEmpty ? '' : '${buffer.join('\n')}\n';
    }
    return _backend.readCurrent();
  }

  Future<File?> getCurrentFile() async {
    await initialize();
    final current = _backend.currentFileObject;
    final currentPath = current?.path?.toString() ?? '';
    return currentPath.isEmpty ? null : File(currentPath);
  }

  Future<int> filesCount() async {
    await initialize();
    return (await _backend.files()).length;
  }

  Future<BinarySize?> filesSize() async {
    await initialize();
    final files = await _backend.files();
    final total = files.fold<int>(0, (sum, file) => sum + file.sizeBytes);
    return BinarySize()..bytesCount = BigInt.from(total);
  }

  List<String> files() {
    return _backend
        .filesSnapshot()
        .map((file) => file.path)
        .toList(growable: false);
  }

  Directory getDir() => Directory(location);

  Future<void> clear() async {
    await initialize();
    await _backend.clear();
    buffer.clear();
  }

  Future<void> clearCache() async {
    await initialize();
    await _backend.clearExpired();
  }

  Future<String?> createArchive(String outputDirectory) async {
    await flushAsync();
    return _backend.createArchive(outputDirectory);
  }

  Future<void> dispose() async {
    await initialize();
    await _backend.dispose();
  }
}

String _validNameSpace(String? value) {
  if (value != null && value.trim().isNotEmpty) {
    return value.trim();
  }
  try {
    if (appPackageName.isNotEmpty) {
      return appPackageName;
    }
  } catch (_) {
    // LogFile can be constructed before PackageInfoUtil.init().
  }
  try {
    if (appName.isNotEmpty) {
      return appName;
    }
  } catch (_) {
    // Fall back to a stable internal namespace below.
  }
  return 'flutter_easy';
}

Future<void> flushLog() async {
  await logFile?.flushAsync();
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

  int get nativeValue {
    switch (name.toLowerCase()) {
      case 'info':
        return 1;
      case 'warning':
      case 'warn':
        return 2;
      case 'error':
        return 3;
      case 'fatal':
        return 4;
      default:
        return 0;
    }
  }

  late String? ansiColor;

  String get ansiColorTemplate => "\x1B[$ansiColor@message\x1B[0m";

  LoggerLevel(this.name, {this.ansiColor});
}

void logDebug(dynamic message, {String? name, String? tag}) {
  _log(LoggerLevel.debug, message, name: name, tag: tag);
}

void logInfo(dynamic message, {String? name, String? tag}) {
  _log(LoggerLevel.info, message, name: name, tag: tag);
}

void logWarning(
  dynamic message, {
  String? name,
  String? tag,
}) {
  _log(LoggerLevel.warning, message, name: name, tag: tag);
}

void logError(
  dynamic message, {
  String? name,
  String? tag,
  Object? error,
  StackTrace? stackTrace,
}) {
  _log(LoggerLevel.error, message,
      name: name, tag: tag, error: error, stackTrace: stackTrace);
}

void logFatal(
  dynamic message, {
  String? name,
  String? tag,
  Object? error,
  StackTrace? stackTrace,
}) {
  _log(LoggerLevel.fatal, message,
      name: name, tag: tag, error: error, stackTrace: stackTrace);
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
