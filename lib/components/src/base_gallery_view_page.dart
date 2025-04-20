import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../flutter_easy.dart';

class BaseGalleryViewPage extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Widget? leading;
  final Color? tintColor;
  final Color? backgroundColor;
  final bool enableRotation;

  const BaseGalleryViewPage(
      {super.key,
      required this.images,
      this.currentIndex = 0,
      this.systemOverlayStyle,
      this.leading,
      this.tintColor,
      this.backgroundColor,
      this.enableRotation = false});

  @override
  State<StatefulWidget> createState() => _BaseGalleryViewPageState();
}

class _BaseGalleryViewPageState extends State<BaseGalleryViewPage> {
  late int pageIndex = widget.currentIndex;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        systemOverlayStyle: widget.systemOverlayStyle,
        leading: widget.leading,
        backgroundColor: Colors.transparent,
        tintColor: widget.tintColor,
        title: Text(
          "${pageIndex + 1}/${widget.images.length}",
          style: TextStyle(color: widget.tintColor),
        ), // 显示图片序号
      ),
      extendBodyBehindAppBar: true,
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: BasePhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(),
        pageController: PageController(initialPage: pageIndex),
        itemCount: widget.images.length,
        enableRotation: widget.enableRotation,
        onPageChanged: changeIndex,
        scrollPhysics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        builder: (context, index) {
          return BasePhotoViewGalleryPageOptions.customChild(
            child: BaseWebImage(widget.images[index]),
            heroAttributes:
                BasePhotoViewHeroAttributes(tag: widget.images[index]),
          );
        },
      ),
    );
  }

  void changeIndex(int page) {
    setState(() => pageIndex = page);
  }
}
