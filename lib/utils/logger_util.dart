import 'package:logger/logger.dart';

import 'global_util.dart';

@deprecated
void log(String tag, Object value) {
  if (isDebug) {
    print("$tag => $value");
  }
}

class _NothingFilter extends DevelopmentFilter {
  @override
  bool shouldLog(LogEvent event) {
    return isDebug ? super.shouldLog(event) : _NothingFilter();
  }
}

var logger = Logger(
  filter: _NothingFilter(),
  printer: PrettyPrinter(colors: false, printTime: true),
);
