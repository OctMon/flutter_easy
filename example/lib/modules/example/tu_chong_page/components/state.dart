import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';

class TuChongTileState implements Cloneable<TuChongTileState> {
  TuChongModel? data;

  @override
  TuChongTileState clone() {
    return TuChongTileState()..data = data;
  }
}

extension TuChongModelExtension on Images {
  static double spacing = 4;

  double imageHeightInWidth(double screenWidth) {
    if (isSquare) {
      return (screenWidth - spacing * 2) * height! / width!;
    }
    return 0;
  }

  bool get isSquare {
    return width! >= height!;
  }

  String get imageURL =>
      "https://photo.tuchong.com/" + "$userId" + "/f/" + "$imgId" + ".jpg";
}
