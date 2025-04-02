import 'dart:math';

String generateSecurePassword({int length = 16}) {
  return PasswordUtil.generateSecurePassword(length: length);
}

/// 安全密码生成工具类
class PasswordUtil {
  static const _lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  static const _upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _numbers = '0123456789';

  /// 生成包含大小写字母和数字的8位密码
  static String generateSecurePassword({int length = 16}) {
    final secureRandom = Random.secure();
    final allChars = '$_lowerCase$_upperCase$_numbers';

    // 确保至少包含一个数字和一个字母
    final passwordChars = [
      _getRandomChar(_lowerCase + _upperCase, secureRandom),
      _getRandomChar(_numbers, secureRandom),
    ];

    // 填充剩余6个字符
    for (var i = 2; i < length; i++) {
      passwordChars.add(_getRandomChar(allChars, secureRandom));
    }

    // 打乱顺序并组合
    return _shuffle(passwordChars, secureRandom).join();
  }

  /// 安全随机选择字符
  static String _getRandomChar(String charPool, Random random) {
    return charPool[random.nextInt(charPool.length)];
  }

  /// Fisher-Yates洗牌算法
  static List<String> _shuffle(List<String> items, Random random) {
    for (var i = items.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = items[i];
      items[i] = items[j];
      items[j] = temp;
    }
    return items;
  }
}
