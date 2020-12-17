import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:flutter_easy/utils/export.dart';
import 'web_image.dart';

class BaseBannerView extends StatelessWidget {
  final List<String> urls;
  final double width;
  final double height;
  final int playDelay;
  final bool showPagination;
  final SwiperOnTap onTap;

  const BaseBannerView(
      {Key key,
      @required this.urls,
      this.width,
      this.height,
      this.playDelay,
      this.showPagination = true,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseCycleView(
      width: width,
      height: height,
      playDelay: playDelay,
      showPagination: showPagination,
      items: urls.map((url) {
        if (url.startsWith("http")) {
          return WebImage(
            url,
            fit: BoxFit.fill,
            placeholder: Container(),
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
  final double width;
  final double height;
  final Axis scrollDirection;
  final ScrollPhysics physics;
  final int playDelay;
  final bool showPagination;
  final SwiperOnTap onTap;

  const BaseCycleView(
      {Key key,
      this.items,
      this.width,
      this.height,
      this.scrollDirection = Axis.horizontal,
      this.physics,
      this.playDelay,
      this.showPagination = true,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(
          this.width ?? adaptDp(375),
          this.height ?? adaptDp(180),
        ),
      ),
      child: Swiper(
        scrollDirection: scrollDirection,
        physics: physics,
        loop: items.length > 1,
        autoplay: items.length > 1,
        autoplayDelay: playDelay ?? 4000,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
        pagination: (showPagination && items.length > 1)
            ? SwiperPagination(
                margin: EdgeInsets.all(5),
                alignment: Alignment.bottomRight,
                builder: DotSwiperPaginationBuilder(
                  size: 5,
                  activeSize: 5,
                  color: Color(0xFF999999),
                  activeColor: Colors.white,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
