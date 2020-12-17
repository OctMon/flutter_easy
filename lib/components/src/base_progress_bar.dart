import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

final _kDeafultWidth = adaptDp(80);
final _kDeafultHeight = adaptDp(15);

/// 进度条
class BaseProgressBar extends StatelessWidget {
  BaseProgressBar(
      {Key key,
      this.width,
      this.height,
      this.backgroudColor,
      this.foregroundColor,
      @required this.value})
      : super(key: key);

  /// 宽度
  final double width;

  /// 高度
  final double height;

  /// 背景色
  final Color backgroudColor;

  /// 前景色
  final Color foregroundColor;

  /// 当前值(0-1)
  final double value;

  @override
  Widget build(BuildContext context) {
    double aspectRatio = width != null && height != null && value != null
        ? value * width / height
        : value * (_kDeafultWidth / _kDeafultHeight);
    return Container(
      height: height ?? _kDeafultHeight,
      child: Stack(
        children: <Widget>[
          Container(
            width: width ?? _kDeafultWidth,
            height: height ?? _kDeafultHeight,
            color: backgroudColor ?? Color(0xFFEBEBEB),
          ),
          Container(
            color: foregroundColor ?? colorWithTint,
            child:
                aspectRatio <= 0 ? null : AspectRatio(aspectRatio: aspectRatio),
          ),
        ],
      ),
    );
  }
}
