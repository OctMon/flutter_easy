import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'state.dart';

Widget buildView(
    PhotoViewState state, Dispatch dispatch, ViewService viewService) {
  return BaseScaffold(
    appBar: BaseAppBar(
      brightness: Brightness.light,
      title: BaseText(state.data?.title),
    ),
    body: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: BaseWebImage.provider(state.data?.images?[index].imageURL ?? ""),
        );
      },
      itemCount: state.data?.imageCount,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null || event.expectedTotalBytes == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
      backgroundDecoration: BoxDecoration(color: Colors.white),
    ),
  );
}
