import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/modules/example/tu_chong/model.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TCImageModel> data = Get.arguments["data"];
    final int index = Get.arguments["index"];
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(data[index].title ?? ""),
      ),
      body: PhotoViewGallery.builder(
        pageController: PageController(initialPage: index),
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                BaseExtendedNetworkImageProvider(data[index].imageURL),
          );
        },
        itemCount: data.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null || event.expectedTotalBytes == null
                  ? 0
                  : event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1),
            ),
          ),
        ),
        backgroundDecoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
}
