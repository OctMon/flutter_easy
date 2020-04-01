import 'dart:convert';

/// Converts [value] to a JSON string.
String jsonEncode(Object object, {Object toEncodable(Object nonEncodable)}) =>
    json.encode(object, toEncodable: toEncodable);

/// Parses the string and returns the resulting Json object.
dynamic jsonDecode(String source, {Object reviver(Object key, Object value)}) =>
    json.decode(source, reviver: reviver);

Map sortMap(Map map) {
  List keys = map.keys.toList();
  keys.sort((a, b) {
    List<int> al = a.codeUnits;
    List<int> bl = b.codeUnits;
    for (int i = 0; i < al.length; i++) {
      if (bl.length <= i) return 1;
      if (al[i] > bl[i]) {
        return 1;
      } else if (al[i] < bl[i]) return -1;
    }
    return 0;
  });
  Map newMap = {};
  keys.forEach((e) {
    newMap[e] = map[e];
  });
  return newMap;
}
