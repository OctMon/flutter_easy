import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:image/image.dart';

Future<bool> imageIsJpeg(File file) async {
  // 读取前8个字节，足够判断大部分常见文件格式
  final bytes = await file.openRead(0, 8).first;

  // 打印文件头字节的十六进制表示
  final header =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
  logDebug('文件头: $header');
  if (header.startsWith('ff d8')) {
    return true;
  }
  return false;
}

/// to the JPEG format.
Future<Uint8List?> convertImageToJpg({
  required File inputFile,
  int quality = 100,
  JpegChroma chroma = JpegChroma.yuv444,
}) async {
  final imageBytes = inputFile.readAsBytesSync();

  final image = decodeImage(imageBytes);

  if (image == null) {
    return null;
  }

  final jpgBytes = encodeJpg(image);

  return jpgBytes;
}

Future<File?> compressImageToJpg({
  required File inputFile,
  int? width,
  int? height,
  File? outputFile,
  int quality = 100,
}) async {
  // 异步读取文件字节
  final imageBytes = await inputFile.readAsBytes();

  // 在isolate中执行图像解码和调整大小
  final resized = await compute(
      _decodeAndResize,
      _ResizeParams(
        imageBytes: imageBytes,
        width: width,
        height: height,
      ));

  if (resized == null) return null;

  // 在isolate中执行JPEG编码
  final jpegData = await compute(
      _encodeJpeg,
      _EncodeParams(
        image: resized,
        quality: quality,
      ));

  outputFile ??= File(
      "${getDirname(inputFile.path)}/${getBasenameWithoutExtension(inputFile.path)}_compressed.jpg");

  // 异步写入文件
  final compressedFile = await outputFile.writeAsBytes(jpegData);

  logDebug('compressed: ${compressedFile.path} '
      'width: ${resized.width} height: ${resized.height} '
      'before: ${inputFile.lengthSync()} '
      'after: ${compressedFile.lengthSync()}');

  return compressedFile;
}

// 需要在文件顶部添加的参数类
class _ResizeParams {
  final Uint8List imageBytes;
  final int? width;
  final int? height;

  _ResizeParams({
    required this.imageBytes,
    required this.width,
    required this.height,
  });
}

class _EncodeParams {
  final Image image;
  final int quality;

  _EncodeParams({
    required this.image,
    required this.quality,
  });
}

// 需要在isolate中执行的函数
Image? _decodeAndResize(_ResizeParams params) {
  final image = decodeImage(params.imageBytes);
  return image != null
      ? copyResize(image, width: params.width, height: params.height)
      : null;
}

Uint8List _encodeJpeg(_EncodeParams params) {
  return encodeJpg(params.image, quality: params.quality);
}
