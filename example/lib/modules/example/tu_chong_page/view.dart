import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    TuChongState state, Dispatch dispatch, ViewService viewService) {
  final ListAdapter adapter = viewService.buildAdapter();
  return BaseScaffold(
    appBar: BaseAppBar(
      brightness: Brightness.dark,
      title: BaseText(S.of(viewService.context).example_PictureWaterfallFlow),
    ),
    body: BaseRefresh(
      controller: state.refreshController,
      emptyWidget: (state.data.isEmptyOrNull)
          ? BasePlaceholderView(
              title: state.message,
              onTap: () => state.refreshController.callRefresh(),
            )
          : null,
      onRefresh: () async => dispatch(TuChongActionCreator.onRequestData(kFirstPage)),
      onLoad: () async =>
          dispatch(TuChongActionCreator.onRequestData(state.page)),
      child: ListView.builder(
        itemBuilder: adapter.itemBuilder,
        itemCount: adapter.itemCount,
      ),
    ),
  );
}
