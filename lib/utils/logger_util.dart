import 'package:flutter_easy/flutter_easy.dart';
import 'package:logger/logger.dart';

import 'global_util.dart';

@deprecated
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

var logger = Logger(
  filter: DevelopmentFilter(),
  printer: PrettyPrinter(colors: false, printTime: true),
);
