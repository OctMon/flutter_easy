import 'package:flutter/material.dart';

import '../../flutter_easy.dart';

class BaseGalleryViewPage extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final BaseAppBar? appBar;

  const BaseGalleryViewPage(
      {super.key, required this.images, this.currentIndex = 0, this.appBar});

  @override
  State<StatefulWidget> createState() => _BaseGalleryViewPageState();
}

class _BaseGalleryViewPageState extends State<BaseGalleryViewPage> {
  late int pageIndex = widget.currentIndex;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: widget.appBar ??
          BaseAppBar(
            backgroundColor: Colors.transparent,
            title: Text("${pageIndex + 1}/${widget.images.length}"), // 显示图片序号
          ),
      extendBodyBehindAppBar: true,
      body: BasePhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(),
        pageController: PageController(initialPage: pageIndex),
        itemCount: widget.images.length,
        enableRotation: true,
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
