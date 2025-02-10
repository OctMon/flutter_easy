import 'package:flutter/widgets.dart';

class BaseClickerClipRRect extends ClipRRect {
  const BaseClickerClipRRect({
    super.key,
    BorderRadius super.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ),
    super.child,
  });
}
