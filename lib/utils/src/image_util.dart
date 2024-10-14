import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:image/image.dart';

Future<bool> imageIsJpeg(File file) async {
  // 读取前8个字节，足够判断大部分常见文件格式
  final bytes = await file
      .openRead(0, 8)
      .first;

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
    logDebug('covert image to jpg failed');
    return null;
  }

  final jpgBytes = encodeJpg(image);

  return jpgBytes;
}
