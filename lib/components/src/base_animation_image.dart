import 'package:flutter/material.dart';

Widget? baseDefaultAnimationImage;

class BaseAnimationImage extends StatefulWidget {
  final List<String> assetList;
  final double width;
  final double height;
  final int interval;

  BaseAnimationImage(
      {super.key,
      required this.assetList,
      this.width = 100,
      this.height = 100,
      required this.interval});

  @override
  State<StatefulWidget> createState() {
    return _BaseAnimationImageState();
  }
}

class _BaseAnimationImageState extends State<BaseAnimationImage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final int imageCount = widget.assetList.length;
    final int maxTime = widget.interval * imageCount;

    _controller = new AnimationController(
        duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0.0); // 完成后重新开始
      }
    });

    _animation = new Tween<double>(begin: 0, end: imageCount.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ix = _animation.value.floor() % widget.assetList.length;

    List<Widget> images = [];
    // 把所有图片都加载进内容，否则每一帧加载时会卡顿
    for (int i = 0; i < widget.assetList.length; ++i) {
      if (i != ix) {
        images.add(Image.asset(
          widget.assetList[i],
          width: 0,
          height: 0,
        ));
      }
    }

    images.add(Image.asset(
      widget.assetList[ix],
      width: widget.width,
      height: widget.height,
    ));

    return Stack(alignment: AlignmentDirectional.center, children: images);
  }
}
