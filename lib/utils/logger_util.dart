import 'global_util.dart';

void log(String tag, Object value) {
  if (!isProduction) {
    print("$tag => $value");
  }
}
