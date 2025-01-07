import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:shimmer/shimmer.dart';

Color? baseDefaultShimmerBaseColor;
Color? baseDefaultShimmerHighlightColor;

class BaseShimmer extends StatelessWidget {
  const BaseShimmer(
      {super.key,
      required this.visible,
      required this.child,
      this.baseColor,
      this.highlightColor});

  final bool visible;
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    if (visible) {
      return Shimmer.fromColors(
        baseColor: baseColor ??
            baseDefaultShimmerBaseColor ??
            appTheme(context).primaryColor.withValues(alpha: 0.3),
        highlightColor: highlightColor ??
            baseDefaultShimmerHighlightColor ??
            appTheme(context).primaryColor.withValues(alpha: 0.6),
        child: IgnorePointer(child: child),
      );
    } else {
      return child;
    }
  }
}
