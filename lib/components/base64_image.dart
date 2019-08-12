import 'dart:convert' as convert;

import 'package:flutter/material.dart';

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

  static String encode(List<int> input) => convert.base64.encode(input);

  @override
  Widget build(BuildContext context) {
    String decode = base64.contains(',') ? base64.split(',')[1] : base64;
    try {
      return Image.memory(
        convert.base64.decode(decode),
        height: width,
        width: height,
        fit: fit,
        gaplessPlayback: true, // 防止重绘
      );
    } catch (e) {
      return Container(width: width, height: height, child: Text(e.toString()));
    }
  }
}
