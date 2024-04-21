import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

String _costumeSplitter = " ";

String _addCostumeSplitter(String? message) =>
    message == null || message == '' ? '' : "[$message]";

String _colorize(String message, LoggerLevel logLevel) {
  if (logLevel.ansiColor == null) return message;
  return logLevel.ansiColorTemplate.replaceFirst("@message", message);
}

void _log(LoggerLevel level, dynamic message) {
  if (isDebug || isAppDebugFlag) {
    final dateTime = DateTime.now();
    var timestamp = _addCostumeSplitter(
        '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}');
    var logLevel = _addCostumeSplitter(level.name);
    var formattedMessage = timestamp + _costumeSplitter + logLevel;
    formattedMessage += _costumeSplitter + "$message";

    if (isIOS) {
      for (var line in formattedMessage.split('\n')) {
        developer.log(line, name: appName);
        if (Get.isRegistered<EasyLogConsoleController>()) {
          Get.find<EasyLogConsoleController>().logs.add(line);
        }
      }
      return;
    }

    formattedMessage =
        _addCostumeSplitter(appName) + _costumeSplitter + formattedMessage;
    formattedMessage = _colorize(formattedMessage, level);

    for (var line in formattedMessage.split('\n')) {
      print(line);
      if (line.length >= 966) {
        developer.log(line);
      }
      if (Get.isRegistered<EasyLogConsoleController>()) {
        Get.find<EasyLogConsoleController>().logs.add(line);
      }
    }
  }
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
[URL] ${result.response?.requestOptions.uri}
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

class EasyLogConsoleController extends GetxController {
  final scrollController = ScrollController();

  /// 所有的日志
  var logs = <String>[].obs;

  /// 在最下面标志
  var followBottom = true.obs;

  /// 自动滚动
  var flowchart = true.obs;

  @override
  void onInit() {
    scrollController.addListener(() {
      updateFollowBottom();
    });
    ever(logs, (value) {
      0.25.seconds.delay(() {
        scrollToBottom();
      });
    });
    super.onInit();
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
    if (scrollController.hasClients && flowchart.value) {
      followBottom.value = true;

      var scrollPosition = scrollController.position;
      scrollController.jumpTo(scrollPosition.maxScrollExtent);
      // scrollController.animateTo(
      //   scrollPosition.maxScrollExtent,
      //   duration: new Duration(milliseconds: 400),
      //   curve: Curves.easeOut,
      // );
    }
  }
}

class EasyLogConsolePage extends StatelessWidget {
  final EasyLogConsoleController controller =
      Get.put(EasyLogConsoleController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        leading: IconButton(
          icon: Icon(
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
          IconButton(
            icon: Icon(
              CupertinoIcons.bin_xmark,
            ),
            onPressed: () {
              controller.logs.clear();
            },
          ),
          IconButton(
            icon: Obx(() {
              return Icon(
                controller.flowchart.value
                    ? CupertinoIcons.flowchart_fill
                    : CupertinoIcons.flowchart,
              );
            }),
            onPressed: () {
              controller.flowchart.toggle();
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
              Color? color = null;
              if (log.startsWith("[${debugColor}")) {
                color = Colors.blue;
              } else if (log.startsWith("[${infoColor}")) {
                color = Colors.green;
              } else if (log.startsWith("[${warningColor}")) {
                color = Colors.yellow;
              } else if (log.startsWith("[${errorColor}")) {
                color = Colors.red;
              } else if (log.startsWith("[${fatalColor}")) {
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
              return BaseDivider(thickness: 5);
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
