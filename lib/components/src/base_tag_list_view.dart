import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

class BaseTagListView extends StatelessWidget {
  final EdgeInsetsGeometry contentPadding;
  final double spacing;
  final double runSpacing;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final double borderWidth;
  final List<Widget> children;

  const BaseTagListView(
      {super.key,
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 3),
      this.spacing = 10.0,
      this.runSpacing = 5.0,
      this.color,
      this.borderRadius,
      this.borderWidth = 0.5,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children
          .map(
            (child) => Container(
              padding: contentPadding,
              decoration: BoxDecoration(
                border: Border.all(
                  width: borderWidth,
                  color: color ?? appTheme(context).primaryColor,
                ),
                borderRadius: borderRadius ??
                    BorderRadius.circular(
                      adaptDp(3),
                    ),
              ),
              child: child,
            ),
          )
          .toList(),
    );
  }
}
