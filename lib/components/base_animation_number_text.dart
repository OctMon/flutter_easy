import 'package:flutter/material.dart';

import 'base.dart';

/// 数字滚动效果
class BaseAnimationNumberText extends StatefulWidget {
  final num number;
  final TextStyle style;
  final int duration;
  final int fixed;

  const BaseAnimationNumberText(this.number,
      {Key key, this.style, this.duration: 1200, this.fixed: 2})
      : super(key: key);

  @override
  _BaseAnimationNumberTextState createState() =>
      _BaseAnimationNumberTextState();
}

class _BaseAnimationNumberTextState extends State<BaseAnimationNumberText>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  num _fromNumber = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation = Tween<double>(begin: 0, end: 1).animate(curve);
    _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(BaseAnimationNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 数据变化时执行动画
    if (oldWidget.number != widget.number) {
      _fromNumber = oldWidget.number;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        // 数字默认从0增长。数据变化时，由之前数字为基础变化。
        return BaseText(
          (_fromNumber + (_animation.value * (widget.number - _fromNumber)))
              .toStringAsFixed(widget.fixed),
          style: widget.style,
        );
      },
    );
  }
}
