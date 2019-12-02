import 'global_util.dart';

void log(String tag, Object value) {
  if (isDebug) {
    print("$tag => $value");
  }
}
