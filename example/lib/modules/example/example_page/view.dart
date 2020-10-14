import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/routes.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ExampleState state, Dispatch dispatch, ViewService viewService) {
  return BaseScaffold(
    appBar: BaseAppBar(
      title: BaseText(S.of(viewService.context).example),
    ),
    body: ListView(
      children: [
        GlobalListCell(
          item: BaseKeyValue(
              key: S.of(viewService.context).example_PictureWaterfallFlow,
              value: "",
              extend: Icons.image),
          onPressed: () {
            pushNamed(viewService.context, Routes.tuChong);
          },
        ),
        GlobalListCell(
          item: BaseKeyValue(
              key: S
                  .of(viewService.context)
                  .example_ExtractProminentColorsFromAnImage,
              value: "",
              extend: Icons.colorize),
          onPressed: () {
            pushNamed(viewService.context, Routes.imageColors);
          },
        ),
      ],
    ),
  );
}
