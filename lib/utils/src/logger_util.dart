import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:logger/logger.dart';

import 'global_util.dart';

void _log(String tag, dynamic value, {StackTrace? stackTrace}) {
  if (isDebug || isAppDebugFlag) {
    developer.log("${DateTime.now()} $value",
        time: DateTime.now(), name: tag, stackTrace: stackTrace);
  }
}

void logDebug(dynamic message) {
  _log("DEBUG", message);
}

void logInfo(dynamic message) {
  _log("INFO", message);
}

void logWarning(dynamic message) {
  _log("WARNING", message);
}

void logError(dynamic message) {
  _log("ERROR", message, stackTrace: StackTrace.current);
}

void logWTF(dynamic message) {
  _log("WTF", message, stackTrace: StackTrace.current);
}

void logRequest(RequestOptions options) {
  var string = """
\n->->->->->->->->->->Request->->->->->->->->->
[URL] ${options.uri}
[Method]		 ${options.method}
[ConnectTimeout] ${options.connectTimeout / 1000}"
[ReceiveTimeout] ${options.receiveTimeout / 1000}"
[FollowRedirects] ${options.followRedirects}"
""";
  if (!options.headers.isEmptyOrNull) {
    string += """
[Header]
${options.headers}
""";
  }
  if (!options.extra.isEmptyOrNull) {
    string += """
[Extra]
${options.extra}
""";
  }
  if (options.data != null) {
    string += """
[Body]
${options.data}
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
[ConnectTimeout] ${(result.response?.requestOptions.connectTimeout ?? 0) / 1000}"
[ReceiveTimeout] ${(result.response?.requestOptions.receiveTimeout ?? 0) / 1000}"
[FollowRedirects] ${result.response?.requestOptions.followRedirects}"
""";
  if (result.response?.requestOptions.headers != null) {
    string += """
[Header]
${result.response?.requestOptions.headers}
""";
  }
  if (result.response?.requestOptions.extra != null) {
    string += """
[Extra]
${result.response?.requestOptions.extra}
""";
  }
  if (result.response?.requestOptions.data != null) {
    string += """
[Body]
${result.response?.requestOptions.data}
""";
  }
  string +=
      "----------------------${result.response?.statusCode}------------------->";
  if (result.response?.headers != null) {
    string += """
\n[Header]
${result.response?.headers}
""";
  }
  if (result.response?.extra != null && !result.response!.extra.isEmptyOrNull) {
    string += """
[Extra]
${result.response?.extra}
""";
  }
  if (result.response?.data != null) {
    string += """
[Data]
${result.response?.data}
""";
  }
  string += "->->->->->->->->->->Response->->->->->->->->->";
  logInfo(string);
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return isDebug || isAppDebugFlag;
  }
}

var memoryOutput = MemoryOutput();
var streamOutput = StreamOutput();
var logger = Logger(
  filter: _LogFilter(),
  printer: PrettyPrinter(colors: false, printTime: true),
  output: MultiOutput([
    ConsoleOutput(),
    memoryOutput,
    streamOutput,
  ]),
);
