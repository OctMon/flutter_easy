import 'package:flutter_screenutil/flutter_screenutil.dart';

get fontAutoSize8 => fontAutoSize(8);

get fontAutoSize9 => fontAutoSize(9);

get fontAutoSize10 => fontAutoSize(10);

get fontAutoSize11 => fontAutoSize(11);

get fontAutoSize12 => fontAutoSize(12);

get fontAutoSize13 => fontAutoSize(13);

get fontAutoSize14 => fontAutoSize(14);

get fontAutoSize15 => fontAutoSize(15);

get fontAutoSize16 => fontAutoSize(16);

get fontAutoSize17 => fontAutoSize(17);

get fontAutoSize18 => fontAutoSize(18);

get fontAutoSize19 => fontAutoSize(19);

get fontAutoSize20 => fontAutoSize(20);

get fontAutoSize21 => fontAutoSize(21);

get fontAutoSize22 => fontAutoSize(22);

get fontAutoSize23 => fontAutoSize(23);

get fontAutoSize24 => fontAutoSize(24);

get fontAutoSize25 => fontAutoSize(25);

get fontAutoSize26 => fontAutoSize(26);

get fontAutoSize27 => fontAutoSize(27);

get fontAutoSize28 => fontAutoSize(28);

get fontAutoSize29 => fontAutoSize(29);

get fontAutoSize30 => fontAutoSize(30);

/// 传入字体大小，默认不根据系统的“字体大小”辅助选项来进行缩放(可在初始化ScreenUtil时设置allowFontScaling)
fontAutoSize(double fontSize) {
  return ScreenUtil.getInstance().setSp(fontSize);
}

/// 传入字体大小，根据系统的“字体大小”辅助选项来进行缩放(如果某个地方不遵循全局的allowFontScaling设置)
fontAutoSizeAllowScaling(double fontSize) {
  return ScreenUtil(allowFontScaling: true).setSp(fontSize);
}
