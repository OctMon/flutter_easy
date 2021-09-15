import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/modules/example/tu_chong/model.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TCModel data = Get.arguments;
    return BaseScaffold(
      appBar: BaseAppBar(
        title: BaseText(data.title),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                BaseWebImage.provider(data.imageList?[index].imageURL ?? ""),
          );
        },
        itemCount: data.imageCount,
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
