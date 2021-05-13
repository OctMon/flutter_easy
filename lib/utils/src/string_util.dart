/// 反转字符串
String reverse(String text) {
  if (text.isEmpty) {
    return "";
  }
  StringBuffer string = StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    string.writeCharCode(text.codeUnitAt(i));
  }
  return string.toString();
}

/// 每隔n位 加 pattern
String formatDigitPattern(String text, {int digit = 4, String pattern = ' '}) {
  text = text.replaceAllMapped(RegExp("(.{$digit})"), (Match match) {
    return "${match.group(0)}$pattern";
  });
  if (text.endsWith(pattern)) {
    text = text.substring(0, text.length - 1);
  }
  return text;
}

/// 每隔n位 加 pattern, 从末尾开始
String formatDigitPatternEnd(String text,
        {int digit = 4, String pattern = ' '}) =>
    reverse(formatDigitPattern(reverse(text), digit: digit, pattern: pattern));

/// 每隔n位 加逗号
String formatDigitNum(Object num, {int digit: 3}) =>
    formatDigitPatternEnd(num.toString(), digit: digit, pattern: ',');

/// 保留n位小数
String formatFractionDigitsAsFixed(double amount,
    {int fractionDigits = 2, bool autoClearZero = false}) {
  String fixed = amount.toStringAsFixed(fractionDigits);
  if (autoClearZero) {
    fixed = fixed.replaceAll(".00", "");
  }
  return fixed;
}
