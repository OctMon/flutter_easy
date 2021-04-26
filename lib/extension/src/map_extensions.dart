import 'dart:collection';

extension MapExtensions<K, V> on Map<K, V> {
  /// 按key排序
  Map<K, V> get sortKeys {
    return SplayTreeMap<K, V>.from(this);
  }
}
