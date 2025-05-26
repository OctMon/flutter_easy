import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

final kDefaultWidth = 80.w;
final _kDefaultHeight = 15.w;

/// 进度条
class BaseProgressBar extends StatelessWidget {
  BaseProgressBar(
      {super.key,
      this.width,
      this.height,
      this.backgroundColor,
      this.foregroundColor,
      required this.value});

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 背景色
  final Color? backgroundColor;

  /// 前景色
  final Color? foregroundColor;

  /// 当前值(0-1)
  final double value;

  @override
  Widget build(BuildContext context) {
    double aspectRatio = width != null && height != null
        ? value * width! / height!
        : value * (kDefaultWidth / _kDefaultHeight);
    return Container(
      height: height ?? _kDefaultHeight,
      child: Stack(
        children: <Widget>[
          Container(
            width: width ?? kDefaultWidth,
            height: height ?? _kDefaultHeight,
            color: backgroundColor ?? Color(0xFFEBEBEB),
          ),
          Container(
            color: foregroundColor ?? appTheme(context).primaryColor,
            child:
                aspectRatio <= 0 ? null : AspectRatio(aspectRatio: aspectRatio),
          ),
        ],
      ),
    );
  }
}
