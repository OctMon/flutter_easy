import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'modules/example/image_colors/page.dart';
import 'modules/example/login/page.dart';
import 'modules/example/photo_view/page.dart';
import 'modules/example/tu_chong/page.dart';
import 'modules/root/page.dart';
import 'modules/splash/page.dart';

class Routes {
  static final String root = '/';
  static final String splash = '/splash';
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
      name: Routes.splash,
      page: () => SplashPage(),
    ),
    GetPage(
      name: routesLoginNamed,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.imageColors,
      page: () => ImageColorsPage(),
    ),
    GetPage(
      name: Routes.tuChong,
      page: () => TuChongPage(),
    ),
    GetPage(
      name: Routes.photoView,
      page: () => PhotoViewPage(),
    ),
  ];
}
