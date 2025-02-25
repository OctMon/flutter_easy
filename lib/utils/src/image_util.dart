import 'dart:io';
import 'dart:typed_data';
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

Future<File?> compressImageToJpg(
    {required File inputFile,
    int? width,
    int? height,
    File? outputFile,
    int quality = 100}) async {
  List<int> imageBytes = await inputFile.readAsBytes();
  Image? image = decodeImage(Uint8List.fromList(imageBytes));

  if (image != null) {
    Image resized = copyResize(image, width: width, height: height);
    outputFile = outputFile ??
        File(
            "${getDirname(inputFile.path)}/${getBasenameWithoutExtension(inputFile.path)}_compressed.jpg");
    File compressedFile = outputFile
      ..writeAsBytesSync(encodeJpg(resized, quality: quality));

    logDebug(
        'compressed: ${compressedFile.path} before: ${inputFile.lengthSync()} after: ${compressedFile.lengthSync()}');
    return compressedFile;
  }
  return null;
}
