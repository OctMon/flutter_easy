class ValidUtils {
  ValidUtils._();

  /// 验证手机号码
  static bool isPhone(String phone) {
    if (phone.length == 11) {
      if (RegExp(
          "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}\$")
          .hasMatch(phone)) {
        return true;
      }
    }
    return false;
  }
}