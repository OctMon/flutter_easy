import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/routes.dart';

// import 'action.dart';
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
        GlobalListCell(
          item: BaseKeyValue(
            key: S.of(viewService.context).example_Navigator,
            value: "",
            extend: Icons.navigation_outlined,
          ),
          onPressed: () {
            showDialog(
                context: viewService.context,
                builder: (BuildContext context) {
                  return Material(
                    type: MaterialType.transparency,
                    child: Center(
                      child: Container(
                        height: adaptDp(350),
                        width: adaptDp(300),
                        child: Navigator(
                          initialRoute: '/',
                          onGenerateRoute: (RouteSettings settings) {
                            WidgetBuilder builder;
                            switch (settings.name) {
                              case '/':
                                builder = (context) {
                                  return Card(
                                    child: Column(
                                      children: <Widget>[
                                        GlobalListCell(
                                          item: BaseKeyValue(
                                              key: "first",
                                              value: "",
                                              extend: Icons.flag),
                                        ),
                                        BaseDivider(),
                                        GlobalListCell(
                                          item: BaseKeyValue(
                                              key: "second",
                                              value: "",
                                              extend: Icons.login),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return BaseScaffold(
                                                appBar: BaseAppBar(
                                                  brightness: Brightness.light,
                                                  title: BaseText("title"),
                                                ),
                                                body: Center(
                                                    child: BaseText("body")),
                                              );
                                            }));
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                };
                                break;
                            }
                            return MaterialPageRoute(builder: builder);
                          },
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ],
    ),
  );
}
