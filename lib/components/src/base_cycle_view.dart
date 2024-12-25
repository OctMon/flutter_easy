import 'package:flutter/material.dart';

import 'package:flutter_easy/utils/export.dart';
import 'base_web_image.dart';

class BaseBannerView extends StatelessWidget {
  final List<String> urls;
  final double? width;
  final double? height;
  final int? playDelay;
  final bool showPagination;
  final BaseSwiperPlugin? pagination;
  final Widget placeholder;
  final ValueChanged<int>? onTap;

  const BaseBannerView(
      {super.key,
      required this.urls,
      this.width,
      this.height,
      this.playDelay,
      this.showPagination = true,
      this.pagination,
      required this.placeholder,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return BaseCycleView(
      width: width,
      height: height,
      playDelay: playDelay,
      showPagination: showPagination,
      pagination: pagination,
      items: urls.map((url) {
        if (url.startsWith("http")) {
          return BaseWebImage(
            url,
            fit: BoxFit.fill,
            placeholder: placeholder,
          );
        } else {
          return Image.asset(
            url,
            fit: BoxFit.fill,
          );
        }
      }).toList(),
      onTap: onTap,
    );
  }
}

class BaseCycleView extends StatelessWidget {
  final List<Widget> items;
  final double? width;
  final double? height;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final int? playDelay;
  final bool showPagination;
  final BaseSwiperPlugin? pagination;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onIndexChanged;

  const BaseCycleView(
      {super.key,
      required this.items,
      this.width,
      this.height,
      this.scrollDirection = Axis.horizontal,
      this.physics,
      this.playDelay,
      this.showPagination = true,
      this.onTap,
      this.onIndexChanged,
      this.pagination});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(
          this.width ?? adaptDp(375),
          this.height ?? adaptDp(180),
        ),
      ),
      child: BaseSwiper(
        scrollDirection: scrollDirection,
        physics: physics,
        loop: items.length > 1,
        autoplay: items.length > 1,
        autoplayDelay: playDelay ?? 4000,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
        onIndexChanged: onIndexChanged,
        pagination: pagination ??
            ((showPagination && items.length > 1)
                ? BaseSwiperPagination(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.bottomRight,
                    builder: BaseDotSwiperPaginationBuilder(
                      size: 5,
                      activeSize: 5,
                      color: Color(0xFF999999),
                      activeColor: Colors.white,
                    ),
                  )
                : null),
        onTap: onTap,
      ),
    );
  }
}
