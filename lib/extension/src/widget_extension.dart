import 'package:flutter/material.dart';

import '../../utils/src/color_util.dart';

extension WidgetExtension on Widget {
  Widget get debugRandomColor {
    return Container(
      color: colorWithRandom(),
      child: this,
    );
  }
}
