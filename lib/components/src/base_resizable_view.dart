import 'package:flutter/material.dart';

class BaseResizableView extends StatefulWidget {
  final Offset offset;
  final Size size;
  final Rect boundary;
  final Widget child;
  final Decoration? cornerDecoration;
  final double cornerSize;
  final ValueChanged<Rect>? onResize;

  const BaseResizableView(
      {super.key,
      required this.boundary,
      required this.offset,
      required this.size,
      required this.child,
      this.cornerDecoration,
      this.cornerSize = 24,
      this.onResize});

  @override
  State<BaseResizableView> createState() => _BaseResizableViewState();
}

class _BaseResizableViewState extends State<BaseResizableView> {
  Size _size = Size.zero;
  Offset _position = Offset.zero;

  @override
  void initState() {
    super.initState();
    _size = widget.size;
    _position = widget.offset;
  }

  // 四角调整逻辑
  void _handleCornerResize(DragUpdateDetails details, String cornerType) {
    final delta = details.delta;

    setState(() {
      switch (cornerType) {
        case 'topLeft':
          _position = Offset(
              (_position.dx + delta.dx)
                  .clamp(0, _position.dx + _size.width - 50),
              (_position.dy + delta.dy)
                  .clamp(0, _position.dy + _size.height - 50));
          _size = Size(
              (_size.width - delta.dx).clamp(50, widget.boundary.width),
              (_size.height - delta.dy).clamp(50, widget.boundary.height));
          break;
        case 'topRight':
          _position = Offset(
              _position.dx,
              (_position.dy + delta.dy)
                  .clamp(0, _position.dy + _size.height - 50));
          _size = Size(
              (_size.width + delta.dx)
                  .clamp(50, widget.boundary.width - _position.dx),
              (_size.height - delta.dy).clamp(50, widget.boundary.height));
          break;
        case 'bottomLeft':
          _position = Offset(
              (_position.dx + delta.dx)
                  .clamp(0, _position.dx + _size.width - 50),
              _position.dy);
          _size = Size(
              (_size.width - delta.dx).clamp(50, widget.boundary.width),
              (_size.height + delta.dy)
                  .clamp(50, widget.boundary.height - _position.dy));
          break;
        case 'bottomRight':
          _size = Size(
              (_size.width + delta.dx)
                  .clamp(50, widget.boundary.width - _position.dx),
              (_size.height + delta.dy)
                  .clamp(50, widget.boundary.height - _position.dy));
          break;
      }
    });

    widget.onResize?.call(
        Rect.fromLTWH(_position.dx, _position.dy, _size.width, _size.height));
  }

  // 圆形手柄构建
  Widget _buildHandle(Offset offset, String cornerType) {
    return Positioned(
      left: offset.dx - widget.cornerSize * 0.5,
      top: offset.dy - widget.cornerSize * 0.5,
      child: GestureDetector(
        onPanUpdate: (d) => _handleCornerResize(d, cornerType),
        child: Container(
          width: widget.cornerSize,
          height: widget.cornerSize,
          decoration: widget.cornerDecoration ??
              BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final corners = {
      'topLeft': _position,
      'topRight': _position + Offset(_size.width, 0),
      'bottomLeft': _position + Offset(0, _size.height),
      'bottomRight': _position + Offset(_size.width, _size.height),
    };

    return Stack(
      children: [
        // 主体可拖拽区域
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _position = Offset(
                    (_position.dx + details.delta.dx)
                        .clamp(0, widget.boundary.width - _size.width),
                    (_position.dy + details.delta.dy)
                        .clamp(0, widget.boundary.height - _size.height));
              });
              widget.onResize?.call(Rect.fromLTWH(
                  _position.dx, _position.dy, _size.width, _size.height));
            },
            child: Container(
              width: _size.width,
              height: _size.height,
              child: widget.child,
            ),
          ),
        ),

        // 四角圆形手柄
        ...corners.entries.map((e) => _buildHandle(e.value, e.key)),

        // 中心点标记（可选）
        // Positioned(
        //   left: _position.dx + _size.width/2 - 8,
        //   top: _position.dy + _size.height/2 - 8,
        //   child: Container(
        //     width: 16,
        //     height: 16,
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
