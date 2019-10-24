import 'package:flutter/material.dart';

import 'package:flutter_easy/utils/crypto_util.dart';

class Base64Image extends StatelessWidget {
  ///
  final String base64;

  /// 设置宽度
  final double width;

  /// 设置高度
  final double height;

  /// 填充
  final BoxFit fit;

  const Base64Image({Key key, this.base64, this.width, this.height, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String encoded = base64.contains(',') ? base64.split(',')[1] : base64;
    try {
      return Image.memory(
        base64Decode(encoded),
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true, // 防止重绘
      );
    } catch (e) {
      return Container(width: width, height: height, child: Text(e.toString()));
    }
  }
}
