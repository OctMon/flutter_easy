import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package_info_utils.dart';

export 'package:multi_image_picker/multi_image_picker.dart' show Asset, AssetThumb;

Future<List<Asset>> imagePickImages({
  @required int maxImages,
  bool enableCamera = false,
  List<Asset> selectedAssets = const [],
  CupertinoOptions cupertinoOptions = const CupertinoOptions(),
  MaterialOptions materialOptions = const MaterialOptions(),
}) {
  return MultiImagePicker.pickImages(
      maxImages: maxImages,
      enableCamera: true,
      selectedAssets: selectedAssets,
      cupertinoOptions: cupertinoOptions,
      materialOptions: MaterialOptions(
        actionBarColor: "#abcdef",
        actionBarTitle: appName,
        allViewTitle: "所有照片",
        useDetailsView: false,
        selectCircleStrokeColor: "#000000",
      ));
}
