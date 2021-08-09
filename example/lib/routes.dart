import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'modules/example/image_colors/page.dart';
import 'modules/example/login/view.dart';
import 'modules/root/page.dart';
import 'modules/root_page/page.dart' as fish;
import 'modules/account_page/page.dart' as fish;
import 'modules/home_page/page.dart' as fish;
import 'modules/example/example_page/page.dart' as fish;
import 'modules/example/image_colors_page/page.dart' as fish;
import 'modules/example/login_page/page.dart' as fish;
import 'modules/example/photo_view_page/page.dart' as fish;
import 'modules/example/tu_chong_page/page.dart' as fish;
import 'store/user_store/store.dart';

class Routes {
  static final String root = '/';
  static final String home = '/home';
  static final String example = '/example';
  static final String tuChong = '/tu_chong';
  static final String photoView = '/photo_view';
  static final String account = '/account';
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

  static final Map<String, Page<Object, dynamic>> pages =
      <String, Page<Object, dynamic>>{
    routesLoginNamed: fish.LoginPage(),
    Routes.root: fish.RootPage(),
    Routes.home: fish.HomePage(),
    Routes.example: fish.ExamplePage(),
    Routes.tuChong: fish.TuChongPage(),
    Routes.photoView: fish.PhotoViewPage(),
    Routes.account: fish.AccountPage(),
    Routes.imageColors: fish.ImageColorsPage(),
  };

  static final AbstractRoutes fRoutes = PageRoutes(
    pages: Routes.pages,
    visitor: (String path, Page<Object, dynamic> page) {
      /// 用户信息变更
      UserStore.visitor(path, page);

      /// AOP
      /// 页面可以有一些私有的 AOP 的增强， 但往往会有一些 AOP 是整个应用下，所有页面都会有的。
      /// 这些公共的通用 AOP ，通过遍历路由页面的形式统一加入。
      page.enhancer.append(
        /// View AOP
        viewMiddleware: <ViewMiddleware<dynamic>>[
          safetyView<dynamic>(),
        ],

        /// Adapter AOP
        adapterMiddleware: <AdapterMiddleware<dynamic>>[
          safetyAdapter<dynamic>()
        ],

        /// Effect AOP
        effectMiddleware: [
          _pageAnalyticsMiddleware<dynamic>(),
        ],

        /// Store AOP
        middleware: <Middleware<dynamic>>[
          logMiddleware<dynamic>(tag: page.runtimeType.toString()),
          performanceMiddleware(tag: page.runtimeType.toString()),
        ],
      );
    },
  );
}

/// 简单的 Effect AOP
/// 只针对页面的生命周期进行打印
EffectMiddleware<T> _pageAnalyticsMiddleware<T>() {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          logDebug('${logic.runtimeType}', '${action.type}',
              StackTrace.fromString('${ctx.context}'));
        }
        return effect?.call(action, ctx);
      };
    };
  };
}
