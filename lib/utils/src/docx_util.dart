import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

ZipDecoder? _zipDecoder;

/// Converts a docx file to text.
/// Only top level numbering is supported.
String docxToText(
  Uint8List bytes, {
  bool handleNumbering = false,
}) {
  _zipDecoder ??= ZipDecoder();

  final archive = _zipDecoder!.decodeBytes(bytes);

  final List<String> list = [];

  for (final file in archive) {
    if (file.isFile && file.name == 'word/document.xml') {
      final fileContent = utf8.decode(file.content);
      final document = xml.XmlDocument.parse(fileContent);

      final paragraphNodes = document.findAllElements('w:p');

      int number = 0;
      String lastNumId = '0';

      for (final paragraph in paragraphNodes) {
        final textNodes = paragraph.findAllElements('w:t');
        var text = textNodes.map((node) => node.innerText).join();

        if (handleNumbering) {
          var numbering = paragraph.getElement('w:pPr')?.getElement('w:numPr');
          if (numbering != null) {
            final numId =
                numbering.getElement('w:numId')!.getAttribute('w:val')!;

            if (numId != lastNumId) {
              number = 0;
              lastNumId = numId;
            }
            number++;
            text = '$number. $text';
          }
        }

        list.add(text);
      }
    }
  }

  return list.join('\n');
}
