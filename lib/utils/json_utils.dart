import 'dart:convert';

/// Converts [value] to a JSON string.
String jsonEncode(Object object, {Object toEncodable(Object nonEncodable)}) =>
    json.encode(object, toEncodable: toEncodable);

/// Parses the string and returns the resulting Json object.
dynamic jsonDecode(String source, {Object reviver(Object key, Object value)}) =>
    json.decode(source, reviver: reviver);
