import 'package:flutter_easy/flutter_easy.dart';

import 'modules/example/connectivity/view.dart';
import 'modules/example/image_colors/page.dart';
import 'modules/example/login/page.dart';
import 'modules/example/photo_view/page.dart';
import 'modules/example/photos_tab/page.dart';
import 'modules/example/tu_chong/page.dart';
import 'modules/profile/page.dart';
import 'modules/root/page.dart';
import 'modules/splash/page.dart';

import 'middleware/login_middleware.dart';

class Routes {
  static const String root = '/';
  static const String splash = '/splash';
  static const String example = '/example';
  static const String profile = '/profile';
  static const String tuChong = '$example/tu_chong';
  static const String photoView = '$example/photo_view';
  static const String imageColors = '$example/image_colors';
  static const String photosTab = '$example/photos_tab';
  static const String connectivity = '$example/connectivity';

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
      name: Routes.profile,
      page: () => ProfilePage(),
      middlewares: [
        LoginMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.connectivity,
      page: () => ConnectivityPage(),
    ),
    GetPage(
      name: Routes.imageColors,
      page: () => const ImageColorsPage(),
    ),
    GetPage(
      name: Routes.tuChong,
      page: () => TuChongPage(),
    ),
    GetPage(
      name: Routes.photoView,
      page: () => const PhotoViewPage(),
    ),
    GetPage(
      name: Routes.photosTab,
      page: () => PhotosTabPage(),
    ),
  ];
}
