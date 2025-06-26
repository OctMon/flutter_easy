import 'package:flutter/services.dart';

/// 严格限制输入长度，超出部分直接拒绝（不会像 `LengthLimitingTextInputFormatter` 那样允许输入后截断）
class StrictLengthFormatter extends TextInputFormatter {
  final int maxLength;
  final ValueChanged<int>? intercept;

  StrictLengthFormatter({required this.maxLength, this.intercept});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 如果新内容的长度 <= 最大长度，允许输入
    if (newValue.text.length <= maxLength) {
      return newValue;
    }
    // 否则，直接返回旧值（阻止输入）
    intercept?.call(maxLength);
    return oldValue;
  }
}
