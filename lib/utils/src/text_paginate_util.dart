import 'package:flutter/material.dart';

/// 计算字符在文本中的索引
class TextPaginate {
  final String text;
  final TextStyle textStyle;
  final double pageWidth;
  final double pageHeight;
  final EdgeInsets padding;
  final TextDirection textDirection;

  late final Characters _characters;
  List<int>? _pageOffsets;

  TextPaginate({
    required this.text,
    required this.textStyle,
    required this.pageWidth,
    required this.pageHeight,
    this.padding = EdgeInsets.zero,
    this.textDirection = TextDirection.ltr,
  }) {
    _characters = text.characters;
  }

  /// 分页处理，返回每个分页的开始下标列表
  Future<List<int>> paginate() async {
    if (_pageOffsets != null) return _pageOffsets!;

    final List<int> offsets = [];
    int start = 0;
    final characterList = _characters.toList();

    final availableWidth = pageWidth - padding.horizontal;
    final availableHeight = pageHeight - padding.vertical;

    while (start < characterList.length) {
      offsets.add(start);

      final remainingText = characterList.sublist(start).join();
      final span = TextSpan(text: remainingText, style: textStyle);

      final painter = TextPainter(
        text: span,
        textDirection: textDirection,
        maxLines: null,
      );
      painter.layout(maxWidth: availableWidth);

      final position = painter.getPositionForOffset(Offset(0, availableHeight));
      final localOffset = position.offset;

      final safeOffset = painter.getOffsetBefore(localOffset) ?? localOffset;
      int nextStart =
          start + _getCharacterIndexFromOffset(remainingText, safeOffset);

      if (nextStart <= start) {
        // If we're stuck near the end, just end it
        if ((characterList.length - start) < 10) break;
        nextStart = start + 1;
      }

      start = nextStart;
    }

    _pageOffsets = offsets;
    return offsets;
  }

  /// 获取指定页的文字
  String getPageText(int index) {
    if (_pageOffsets == null) {
      throw Exception('先调用分页处理方法');
    }

    final start = _pageOffsets![index];
    final end = (index + 1 < _pageOffsets!.length)
        ? _pageOffsets![index + 1]
        : _characters.length;

    return _characters.skip(start).take(end - start).toString();
  }

  /// 根据 UTF-16 offset 找字符下标
  int _getCharacterIndexFromOffset(String text, int utf16Offset) {
    final chars = text.characters;
    int count = 0;
    int currentUtf16Count = 0;

    for (final c in chars) {
      currentUtf16Count += c.length;
      count++;
      if (currentUtf16Count >= utf16Offset) break;
    }

    return count;
  }

  int get pageCount => _pageOffsets?.length ?? 0;
}
