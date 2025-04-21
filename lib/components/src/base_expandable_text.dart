import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BaseExpandableText extends StatefulWidget {
  static String expandTitle = "more";
  static String collapseTitle = "collapse";

  /// 显示的文本
  final String text;

  /// 显示的最多行数
  final int? maxLines;

  /// 文本的样式
  final TextStyle? style;

  /// 展开或者收起的时候的回调
  final ValueChanged<bool>? onExpanded;

  /// 更多按钮渐变色的初始色 默认白色
  final Color? color;

  const BaseExpandableText(this.text,
      {super.key,
      this.maxLines = 1000000,
      this.style,
      this.onExpanded,
      this.color});

  _BaseExpandableTextState createState() => _BaseExpandableTextState();
}

class _BaseExpandableTextState extends State<BaseExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _defaultTextStyle();
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
          ellipsis: BaseExpandableText.collapseTitle,
        );
        tp.layout(maxWidth: size.maxWidth);
        if (tp.didExceedMaxLines) {
          if (this._expanded) {
            return _expandedText(context, widget.text);
          } else {
            return _foldedText(context, widget.text);
          }
        } else {
          return _regularText(widget.text, style);
        }
      },
    );
  }

  Widget _foldedText(context, String text) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          style: _defaultTextStyle(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _clickExpandTextWidget(context),
        )
      ],
    );
  }

  Widget _clickExpandTextWidget(context) {
    Color gradientColor = widget.color ?? Colors.white;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 22),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientColor.withAlpha(100),
              gradientColor,
              gradientColor
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Text(
          BaseExpandableText.expandTitle,
          style: TextStyle(
            fontSize: widget.style?.fontSize,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _expanded = true;
          if (null != widget.onExpanded) {
            widget.onExpanded!(_expanded);
          }
        });
      },
    );
  }

  Widget _expandedText(context, String text) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(text: text, style: _defaultTextStyle(), children: [
        _foldButtonSpan(context),
      ]),
    );
  }

  TextStyle _defaultTextStyle() {
    TextStyle style = widget.style ??
        TextStyle(
          fontSize: widget.style?.fontSize,
        );
    return style;
  }

  InlineSpan _foldButtonSpan(context) {
    return TextSpan(
      text: ' ' + BaseExpandableText.collapseTitle,
      style: TextStyle(
        fontSize: widget.style?.fontSize,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            _expanded = false;
            if (null != widget.onExpanded) {
              widget.onExpanded!(_expanded);
            }
          });
        },
    );
  }

  Widget _regularText(text, style) {
    return Text(text, style: style);
  }
}
