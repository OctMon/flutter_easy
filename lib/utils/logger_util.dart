import 'package:logger/logger.dart';

import 'global_util.dart';

@deprecated
void log(String tag, Object value) {
  if (isDebug) {
    print("$tag => $value");
  }
}

var logger = Logger(
  filter: DevelopmentFilter(),
  printer: PrettyPrinter(colors: false, printTime: true),
);
