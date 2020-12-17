extension DynamicExtension on dynamic {
  /// Example
  /// ```
  /// logWTF("""
  /// -----------true------------
  /// ${[].isEmptyOrNull}
  /// ${null.isEmptyOrNull}
  /// ${''.isEmptyOrNull}
  /// ${"".isEmptyOrNull}
  /// ${List().isEmptyOrNull}
  /// -----------false-----------
  /// ${'n'.isEmptyOrNull}
  /// ${0.isEmptyOrNull}
  /// ${(EmptyClass()).isEmptyOrNull}""");
  /// ```
  bool get isEmptyOrNull {
    if (this == null) {
      return true;
    }

    if (this is String) {
      return "$this".trim().isEmpty;
    }

    return (this is Iterable || this is String || this is Map)
        ? this.isEmpty as bool
        : false;
  }
}
