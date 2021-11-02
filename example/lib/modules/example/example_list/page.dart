import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/routes.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

class ExampleListPage extends StatelessWidget {
  const ExampleListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(S.of(context).example),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_sharp),
            onPressed: () async {
              offAllNamed(Routes.root);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          GlobalListCell(
            item: BaseKeyValue(
                key: S.of(context).example_PictureWaterfallFlow,
                value: "",
                extend: Icons.image),
            onPressed: () {
              // pushNamed(viewService.context, Routes.tuChong);
              toNamed(Routes.tuChong);
            },
          ),
          GlobalListCell(
            item: BaseKeyValue(
                key: S.of(context).example_ExtractProminentColorsFromAnImage,
                value: "",
                extend: Icons.colorize),
            onPressed: () {
              // pushNamed(viewService.context, Routes.imageColors);
              toNamed(Routes.imageColors);
            },
          ),
          GlobalListCell(
            item: BaseKeyValue(
                key: "BaseTabPage",
                value: "",
                extend: Icons.view_list),
            onPressed: () {
              toNamed(Routes.photosTab);
            },
          ),
          GlobalListCell(
            item: BaseKeyValue(
              key: S.of(context).example_Navigator,
              value: "",
              extend: Icons.navigation_outlined,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Material(
                      type: MaterialType.transparency,
                      child: Center(
                        child: SizedBox(
                          height: adaptDp(350),
                          width: adaptDp(300),
                          child: Navigator(
                            initialRoute: '/',
                            onGenerateRoute: (RouteSettings settings) {
                              late WidgetBuilder builder;
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
                                                extend: Icons.login),
                                          ),
                                          const BaseDivider(),
                                          GlobalListCell(
                                            item: BaseKeyValue(
                                                key: "Flags",
                                                value: "",
                                                extend: Icons.flag),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                List<MapEntry<String, String>>
                                                    locales =
                                                    LocaleNamesLocalizationsDelegate
                                                        .nativeLocaleNames
                                                        .entries
                                                        .toList();
                                                return BaseScaffold(
                                                  appBar: BaseAppBar(
                                                    title: const Text("Flags"),
                                                  ),
                                                  body: ListView.separated(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    itemCount: locales.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      MapEntry locale =
                                                          locales[index];
                                                      final String?
                                                          localeString =
                                                          LocaleNames.of(
                                                                  context)
                                                              ?.nameOf(
                                                                  locale.key);
                                                      return BaseButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  50.adaptRatio,
                                                              height:
                                                                  50.adaptRatio,
                                                              child:
                                                                  BaseWebImage(
                                                                "https://flagpedia.net/data/flags/h160/${(locale.key as String).split("_").last.toLowerCase()}.webp",
                                                                placeholder:
                                                                    const SizedBox(),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8.0),
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${locale.key}🌍${locale.value}',
                                                                  ),
                                                                  Text(
                                                                      localeString ??
                                                                          ""),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          showBaseDialog(
                                                              barrierDismissible:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return BaseAlertDialog(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  titlePadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  actionPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  title:
                                                                      const SizedBox(),
                                                                  content:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      offBack();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .black,
                                                                      child:
                                                                          RotatedBox(
                                                                        quarterTurns:
                                                                            1,
                                                                        child:
                                                                            BaseWebImage(
                                                                          "https://flagpedia.net/data/flags/w1160/${(locale.key as String).split("_").last.toLowerCase()}.webp",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                      );
                                                      // String countryCode = locales;
                                                      // return WebImage("https://flagpedia.net/data/flags/normal/${countryCode?.toLowerCase()??''}.png");
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return const BaseDivider();
                                                    },
                                                  ),
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
}
