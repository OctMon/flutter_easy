import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'modules/example/image_colors/page.dart';
import 'modules/example/login/page.dart';
import 'modules/root/page.dart';

class Routes {
  static final String root = '/';
  static final String home = '/home';
  static final String example = '/example';
  static final String account = '/account';
  static final String tuChong = '$example/tu_chong';
  static final String photoView = '$example/photo_view';
  static final String imageColors = '$example/image_colors';

  Routes._();

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.root,
      page: () => RootPage(),
    ),
    GetPage(
      name: routesLoginNamed,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.imageColors,
      page: () => ImageColorsPage(),
    ),
  ];
}
