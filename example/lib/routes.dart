import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'modules/home_page/page.dart';
import 'modules/login_page/page.dart';
import 'modules/photo_view_page/page.dart';
import 'modules/root_page/page.dart';
import 'modules/tu_chong_page/page.dart';

class Routes {
  static final String root = '/';
  static final String home = '/home';
  static final String tuChong = '/tu_chong';
  static final String photoView = '/photo_view';

  Routes._();

  static final Map<String, Page<Object, dynamic>> pages =
      <String, Page<Object, dynamic>>{
    routesLoginNamed: LoginPage(),
    Routes.root: RootPage(),
    Routes.home: HomePage(),
    Routes.tuChong: TuChongPage(),
    Routes.photoView: PhotoViewPage(),
  };

  static final AbstractRoutes routes = PageRoutes(
    pages: Routes.pages,
    visitor: (String path, Page<Object, dynamic> page) {
      /// 用户信息变更
      // UserStore.visitor(path, page);

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
        ],
      );
    },
  );
}

/// 简单的 Effect AOP
/// 只针对页面的生命周期进行打印
EffectMiddleware<T> _pageAnalyticsMiddleware<T>({String tag = 'redux'}) {
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
