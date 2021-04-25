extension MapExtensions on Map {
  /// 按key排序
  Map<String, dynamic> get sortKeys {
    List<String> allKeys = this.keys.toList();
    allKeys.sort((a, b) {
      List<int> aCode = a.codeUnits;
      List<int> bCode = b.codeUnits;
      for (int i = 0; i < aCode.length; i++) {
        if (bCode.length <= i) return 1;
        if (aCode[i] > bCode[i]) {
          return 1;
        } else if (aCode[i] < bCode[i]) {
          return -1;
        }
      }
      return 0;
    });
    var map = Map<String, dynamic>();
    allKeys.forEach((key) {
      map[key] = this[key];
    });
    return map;
  }
}
