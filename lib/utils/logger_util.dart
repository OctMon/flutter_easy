import 'package:dio/dio.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:logger/logger.dart';

import 'global_util.dart';

void log(String tag, Object value) {
  if (isDebug) {
    print("$tag => $value");
  }
}

/// Log a message at level [Level.verbose].
void logVerbose(dynamic message, [dynamic error, StackTrace stackTrace]) {
  isWeb ? log("verbose", message) : logger.v(message, error, stackTrace);
}

/// Log a message at level [Level.debug].
void logDebug(dynamic message, [dynamic error, StackTrace stackTrace]) {
  isWeb ? log("debug", message) : logger.d(message, error, stackTrace);
}

/// Log a message at level [Level.info].
void logInfo(dynamic message, [dynamic error, StackTrace stackTrace]) {
  isWeb ? log("info", message) : logger.i(message, error, stackTrace);
}

/// Log a message at level [Level.warning].
void logWarning(dynamic message, [dynamic error, StackTrace stackTrace]) {
  isWeb ? log("warning", message) : logger.w(message, error, stackTrace);
}

/// Log a message at level [Level.error].
void logError(dynamic message, [dynamic error, StackTrace stackTrace]) {
  isWeb ? log("error", message) : logger.e(message, error, stackTrace);
}

/// Log a message at level [Level.wtf].
void logWTF(dynamic message, [dynamic error, StackTrace stackTrace]) {
  isWeb ? log("wtf", message) : logger.wtf(message, error, stackTrace);
}

void logRequest(RequestOptions options) {
  logVerbose(
      options.data,
      "Request ${options.uri}",
      StackTrace.fromString('method: ${options.method}\n' +
          'responseType: ${options.responseType?.toString()}\n' +
          "followRedirects: ${options.followRedirects}\n" +
          "connectTimeout: ${options.connectTimeout}\n" +
          "receiveTimeout: ${options.receiveTimeout}\n" +
          "extra: ${options.extra}\n" +
          "headers: \n${options.headers}"));
}

void logResponse(Result result) {
  if (result.error != null) {
    logVerbose(
        result.response?.data,
        "Response ${result.response.request.uri}",
        StackTrace.fromString('statusCode: ${result.response.statusCode}\n' +
            "${result.error}: ${result.message}"));
  } else {
    logVerbose(
        result.response?.data,
        "Response ${result.response.request.uri}",
        StackTrace.fromString('statusCode: ${result.response.statusCode}\n' +
            (result.response.isRedirect == true
                ? "redirect: ${result.response.realUri}\n"
                : "") +
            "connectTimeout: ${result.response.request.connectTimeout}\n" +
            (result.response.headers != null
                ? "headers: \n${result.response.headers}"
                : "")));
  }
}

var logger = Logger(
  filter: DevelopmentFilter(),
  printer: PrettyPrinter(colors: false, printTime: true),
);
