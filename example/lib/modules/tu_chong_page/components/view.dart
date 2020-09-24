import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'state.dart';

Widget buildView(
    TuChongTileState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: ImagesBean.spacing),
        padding: EdgeInsets.symmetric(vertical: 10),
        width: screenWidthDp - ImagesBean.spacing * 2,
        color: colorWithRandom(),
        child: BaseTitle(
          state.data.title,
          textAlign: TextAlign.center,
        ),
      ),
      StaggeredGridView.countBuilder(
        padding: EdgeInsets.symmetric(horizontal: ImagesBean.spacing),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: ImagesBean.crossAxisCount,
        itemCount: state.data.images.length,
        itemBuilder: (BuildContext context, int index) => WebImage(
          state.data.images[index].imageURL,
          placeholder: Container(
            color: colorWithRandom(),
          ),
        ),
        staggeredTileBuilder: (int index) => new StaggeredTile.extent(
            state.data.images[index].isSquare ? ImagesBean.crossAxisCount : 1,
            state.data.images[index].isSquare
                ? screenWidthDp - ImagesBean.spacing * 2
                : state.data.images[index].imageHeight),
        mainAxisSpacing: ImagesBean.spacing,
        crossAxisSpacing: ImagesBean.spacing,
      ),
    ],
  );
  // return Column(
  //   children: state.images.map((e) {
  //     return WebImage(e.imageURL, placeholder: Container(),);
  //   }).toList(),
  // );
}
