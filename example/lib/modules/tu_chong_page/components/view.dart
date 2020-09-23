import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'state.dart';

Widget buildView(
    TuChongTileState state, Dispatch dispatch, ViewService viewService) {
  return StaggeredGridView.countBuilder(
    padding: EdgeInsets.symmetric(horizontal: 4.0),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    itemCount: state.images.length,
    itemBuilder: (BuildContext context, int index) => WebImage(
      state.images[index].imageURL,
      placeholder: Container(),
    ),
    staggeredTileBuilder: (int index) =>
        new StaggeredTile.extent(1, state.images[index].imageHeight),
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
  );
  // return Column(
  //   children: state.images.map((e) {
  //     return WebImage(e.imageURL, placeholder: Container(),);
  //   }).toList(),
  // );
}
