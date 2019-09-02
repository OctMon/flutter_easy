import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 传入字体大小，默认不根据系统的“字体大小”辅助选项来进行缩放(可在初始化ScreenUtil时设置allowFontScaling)
fontAutoSize(double fontSize) {
  return ScreenUtil.getInstance().setSp(fontSize);
}

/// 传入字体大小，根据系统的“字体大小”辅助选项来进行缩放(如果某个地方不遵循全局的allowFontScaling设置)
fontAutoSizeAllowScaling(double fontSize) {
  return ScreenUtil(allowFontScaling: true).setSp(fontSize);
}
