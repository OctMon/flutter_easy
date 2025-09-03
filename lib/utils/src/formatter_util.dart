import 'package:flutter/services.dart';

/// 严格限制输入长度，超出部分直接拒绝（不会像 `LengthLimitingTextInputFormatter` 那样允许输入后截断）
class StrictLengthFormatter extends TextInputFormatter {
  final int maxLength;
  final ValueChanged<int>? intercept;

  StrictLengthFormatter({required this.maxLength, this.intercept});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 如果正在输入拼音，则不做任何限制，允许自由输入
    if (newValue.composing.isValid) {
      return newValue;
    }
    // 如果没有拼音输入，则检查最终文本的长度
    if (newValue.text.length > maxLength) {
      intercept?.call(maxLength);
      // 如果超出限制，则截断到最大长度
      return TextEditingValue(
        text: newValue.text.substring(0, maxLength),
        selection: TextSelection.collapsed(offset: maxLength),
      );
    }

    // 长度符合要求，直接返回
    return newValue;
  }
}
