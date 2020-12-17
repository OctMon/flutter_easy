import 'dart:async';

extension DurationExtensions on Duration {
  /// Example:
  /// ```
  /// print('📣 wait for 2.5 seconds');
  /// await 2.5.seconds.delay();
  /// print('✅ 2.5 seconds completed');
  /// print('📣 callback in 1.8 seconds');
  /// 1.8.seconds.delay(() => print('✅ 1.8 seconds callback called'));
  /// print('🎉 currently running callback');
  ///```
  Future delay([FutureOr callback()]) async => Future.delayed(this, callback);
}
