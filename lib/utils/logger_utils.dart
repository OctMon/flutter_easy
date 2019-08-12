import 'global_utils.dart';

void log(String tag, Object value) {
  if (!isProduction) {
    print("$tag => $value");
  }
}
