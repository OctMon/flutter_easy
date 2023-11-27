class GirlListModel {
  GirlListModel({
    this.imageUrl,
    this.imageSize,
    this.imageFileLength,
  });

  GirlListModel.fromJson(dynamic json) {
    imageUrl = json['imageUrl'];
    imageSize = json['imageSize'];
    imageFileLength = json['imageFileLength'];
  }

  String? imageUrl;
  String? imageSize;
  num? imageFileLength;

  GirlListModel copyWith({
    String? imageUrl,
    String? imageSize,
    num? imageFileLength,
  }) =>
      GirlListModel(
        imageUrl: imageUrl ?? this.imageUrl,
        imageSize: imageSize ?? this.imageSize,
        imageFileLength: imageFileLength ?? this.imageFileLength,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageUrl'] = imageUrl;
    map['imageSize'] = imageSize;
    map['imageFileLength'] = imageFileLength;
    return map;
  }
}
