import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    TuChongState state, Dispatch dispatch, ViewService viewService) {
  final ListAdapter adapter = viewService.buildAdapter();
  return BaseScaffold(
    appBar: BaseAppBar(
      brightness: Brightness.dark,
      title: BaseText("图虫"),
    ),
    body: BaseRefresh(
      controller: state.refreshController,
      emptyWidget: (state.data == null || state.data.isEmpty)
          ? PlaceholderView(
              title: state.message,
              onTap: () => state.refreshController.callRefresh(),
            )
          : null,
      onRefresh: () async => dispatch(TuChongActionCreator.onRequestData(null)),
      child: ListView.separated(
          itemBuilder: adapter.itemBuilder,
          itemCount: adapter.itemCount,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 5);
          }),
    ),
  );
}
