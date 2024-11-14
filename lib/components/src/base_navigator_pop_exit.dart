import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

class BaseNavigatorPopExit extends StatelessWidget {
  final Widget child;
  final Duration? duration;

  const BaseNavigatorPopExit({super.key, required this.child, this.duration});

  @override
  Widget build(BuildContext context) {
    /// 上次点击的时间
    DateTime? lastPressedAt;

    return BasePopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (lastPressedAt == null ||
            (DateTime.now().difference(lastPressedAt!) >
                (duration ?? const Duration(seconds: 1)))) {
          // 两次点击间隔超过1秒，重新计时
          lastPressedAt = DateTime.now();
          return;
        }
        SystemNavigator.pop();
      },
      child: child,
    );
  }
}
