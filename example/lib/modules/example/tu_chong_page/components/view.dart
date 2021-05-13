import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/routes.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'state.dart';

const int crossAxisCount = 2;
const double spacing = 4;

Widget buildView(
    TuChongTileState state, Dispatch dispatch, ViewService viewService) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: spacing),
            padding: EdgeInsets.symmetric(vertical: 10),
            width: constraints.maxWidth - spacing * 2,
            color: colorWithRandom(),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Icon(Icons.eighteen_mp)),
                ),
                Expanded(
                  child: Column(
                    children: [
                      BaseTitle(
                        state.data!.title,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5),
                      BaseTitle(
                        state.data!.siteId,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5),
                      BaseTitle(
                        state.data!.tags?.join(","),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          StaggeredGridView.countBuilder(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            itemCount: state.data?.images?.length ?? 0,
            itemBuilder: (BuildContext context, int index) => BaseButton(
              padding: EdgeInsets.zero,
              child: BaseWebImage(
                state.data?.images?[index].imageURL,
                placeholder: Container(
                  color: colorWithRandom(),
                ),
                fit: BoxFit.contain,
              ),
              onPressed: () {
                pushNamed(context, Routes.photoView,
                    arguments: {"data": state.data}, needLogin: (success) {});
              },
            ),
            staggeredTileBuilder: (int index) => new StaggeredTile.extent(
                state.data!.images![index].isSquare
                    ? crossAxisCount
                    : 1,
                state.data!.images![index]
                    .imageHeightInWidth(constraints.maxWidth)),
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
          ),
        ],
      );
    },
  );
  // return Column(
  //   children: state.images.map((e) {
  //     return WebImage(e.imageURL, placeholder: Container(),);
  //   }).toList(),
  // );
}
