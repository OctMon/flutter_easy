import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/routes.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';
import 'controller.dart';

const int _kCrossAxisCount = 2;
const double _kSpacing = 4;

class TuChongPage extends StatelessWidget {
  final TuChongController controller = Get.put(TuChongController());

  @override
  Widget build(BuildContext context) {
    return GetX<TuChongController>(
      builder: (controller) {
        return BaseScaffold(
          appBar: BaseAppBar(
            brightness: Brightness.dark,
            title: BaseText(S.of(context).example_PictureWaterfallFlow),
          ),
          body: BaseRefresh(
            controller: controller.refreshController,
            emptyWidget: (controller.list.isEmptyOrNull)
                ? BasePlaceholderView(
                    title: controller.message.value,
                    onTap: () => controller.refreshController.callRefresh(),
                  )
                : null,
            onRefresh: () async => controller.onRequestData(kFirstPage),
            onLoad: () async => controller.onRequestData(controller.page),
            child: ListView.builder(
              itemCount: controller.list.length,
              itemBuilder: (BuildContext context, int index) {
                final data = controller.list[index];
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: _kSpacing),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: constraints.maxWidth - _kSpacing * 2,
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
                                      data.title,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(width: 5),
                                    BaseTitle(
                                      data.siteId,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(width: 5),
                                    BaseTitle(
                                      data?.tags?.join(","),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        StaggeredGridView.countBuilder(
                          padding: EdgeInsets.symmetric(horizontal: _kSpacing),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: _kCrossAxisCount,
                          itemCount: data?.images?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) =>
                              BaseButton(
                            padding: EdgeInsets.zero,
                            child: BaseWebImage(
                              data?.images[index].imageURL,
                              placeholder: Container(
                                color: colorWithRandom(),
                              ),
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              toNamed(Routes.photoView, arguments: data);
                            },
                          ),
                          staggeredTileBuilder: (int index) =>
                              new StaggeredTile.extent(
                                  data.images[index].isSquare
                                      ? _kCrossAxisCount
                                      : 1,
                                  data.images[index].imageHeightInWidth(
                                      constraints.maxWidth)),
                          mainAxisSpacing: _kSpacing,
                          crossAxisSpacing: _kSpacing,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
