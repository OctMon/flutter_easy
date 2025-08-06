import 'package:flutter/material.dart';

import 'package:flutter_easy/utils/export.dart';
import 'base_web_image.dart';

class BaseBannerView extends StatelessWidget {
  final List<String> urls;
  final double? width;
  final double? height;
  final int? playDelay;
  final double? scale;
  final BaseSwiperLayout layout;
  final double viewportFraction;
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
      this.scale,
      this.layout = BaseSwiperLayout.DEFAULT,
      this.viewportFraction = 1.0,
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
      viewportFraction: viewportFraction,
      scale: scale,
      layout: layout,
      showPagination: showPagination,
      pagination: pagination,
      items: urls.map((url) {
        if (url.startsWith("http") || kWebImagePrefix != null) {
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
  final double? scale;
  final BaseSwiperLayout layout;
  final double viewportFraction;
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
      this.scale,
      this.layout = BaseSwiperLayout.DEFAULT,
      this.viewportFraction = 1.0,
      this.showPagination = true,
      this.onTap,
      this.onIndexChanged,
      this.pagination});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(
          this.width ?? 375.w,
          this.height ?? 180.w,
        ),
      ),
      child: BaseSwiper(
        scrollDirection: scrollDirection,
        physics: physics,
        loop: items.length > 1,
        autoplay: items.length > 1,
        autoplayDelay: playDelay ?? 4000,
        viewportFraction: viewportFraction,
        scale: scale,
        layout: layout,
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
