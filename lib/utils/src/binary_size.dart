import 'dart:math';

class BinarySize {
  late bool isInIecBase = false;

  late int bytesCount = 0;

  String get displayText => (() {
        var lvBase = isInIecBase ? 1000.0 : 1024.0;

        var lvB = 1.0;
        var lvKB = lvB * lvBase;
        var lvMB = lvKB * lvBase;
        var lvGB = lvMB * lvBase;
        var lvTB = lvGB * lvBase;
        var lvPB = lvTB * lvBase;
        var lvEB = lvPB * lvBase;
        var lvZB = lvEB * lvBase;

        var iecBase = isInIecBase ? 'i' : '';

        if (bytesCount < lvKB) return '$bytesCount B';

        if (bytesCount < lvMB) return '${(bytesCount / lvKB).toStringAsFixed(2)} K${iecBase}B';

        if (bytesCount < lvGB) return '${(bytesCount / lvMB).toStringAsFixed(2)} M${iecBase}B';

        if (bytesCount < lvTB) return '${(bytesCount / lvGB).toStringAsFixed(2)} G${iecBase}B';

        if (bytesCount < lvPB) return '${(bytesCount / lvTB).toStringAsFixed(2)} T${iecBase}B';

        if (bytesCount < lvEB) return '${(bytesCount / lvPB).toStringAsFixed(2)} P${iecBase}B';

        if (bytesCount < lvZB) return '${(bytesCount / lvEB).toStringAsFixed(2)} E${iecBase}B';

        return '${(bytesCount / lvZB).toStringAsFixed(2)} Z${iecBase}B';
      })();

  static BinarySize? parse(String size) {
    BinarySize? result;

    var exp = RegExp(r'(\d+).?(\d*)\s*(B|Ki?B|Mi?B|Gi?B|Ti?B|Pi?B|Ei?B)', caseSensitive: false);

    if (exp.hasMatch(size)) {
      result = BinarySize();

      var match = exp.firstMatch(size);

      if (match == null) return null;

      var integer = match.group(1) ?? '';
      var left = match.group(2) ?? '';
      var unit = match.group(3) ?? '';

      var diff = unit.toLowerCase().contains('i') ? 1000.0 : 1024.0;

      result.isInIecBase = diff == 1000;

      var scale = 1.0;

      switch (unit.toUpperCase().replaceAll('IB', 'B')) {
        case 'B':
          scale = 1;
          break;
        case 'KB':
          scale = diff;
          break;
        case 'MB':
          scale = diff * diff;
          break;
        case 'GB':
          scale = pow(diff, 3).toDouble();
          break;
        case 'TB':
          scale = pow(diff, 4).toDouble();
          break;
        case 'PB':
          scale = pow(diff, 5).toDouble();
          break;
        case 'EB':
          scale = pow(diff, 6).toDouble();
          break;
        default:
          scale = 1;
          break;
      }

      if (unit.contains('b')) scale *= 1.0 / 8.0;

      var p = 0;

      for (var i = integer.length - 1; i >= 0; --i, ++p) {
        var addon = (int.parse(integer[i]) * pow(10, p) * scale).toInt();
        result.bytesCount += addon;
      }

      p = -1;

      for (var i = 0; i < left.length; ++i, --p) {
        var addon = (int.parse(left[i]) * pow(10, p) * scale).toInt();
        result.bytesCount += addon;
      }
    }

    return result;
  }

  BinarySize operator +(BinarySize other) => BinarySize()..bytesCount = bytesCount + other.bytesCount;

  BinarySize operator -(BinarySize other) => BinarySize()..bytesCount = bytesCount - other.bytesCount;

  BinarySize operator *(BinarySize other) => BinarySize()..bytesCount = bytesCount * other.bytesCount;

  double operator /(BinarySize other) => bytesCount / other.bytesCount;

  bool operator <(BinarySize other) => bytesCount < other.bytesCount;

  bool operator <=(BinarySize other) => bytesCount <= other.bytesCount;

  bool operator >(BinarySize other) => bytesCount > other.bytesCount;

  bool operator >=(BinarySize other) => bytesCount >= other.bytesCount;
}
