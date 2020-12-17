import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

class PlaceholderView extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const PlaceholderView({
    Key key,
    this.title = '暂无数据',
    this.image = 'empty',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == null || title.isEmpty) {
      return Center(
        child: LoadingView(),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        child: Column(
          children: <Widget>[
            Image.asset(
              assetsImagesPath(image),
              width: 100,
              height: 100,
            ),
            SizedBox(height: 15),
            BaseText(
              title,
              style: TextStyle(
                color: Colors.black38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
