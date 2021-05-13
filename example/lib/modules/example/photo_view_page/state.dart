import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';

class PhotoViewState implements Cloneable<PhotoViewState> {
  TuChongModel? data;

  @override
  PhotoViewState clone() {
    return PhotoViewState()..data = data;
  }
}

PhotoViewState initState(Map<String, dynamic> args) {
  return PhotoViewState()..data = args["data"];
}

extension TuChongModelExtension on Images {
  String get imageURL =>
      "https://photo.tuchong.com/" + "$userId" + "/f/" + "$imgId" + ".jpg";
}
