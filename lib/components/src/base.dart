import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../utils/src/adapt_util.dart';
import '../../utils/src/color_util.dart';
import '../../utils/src/global_util.dart';
import '../../utils/src/intl_util.dart';
import '../../utils/src/json_util.dart';
import '../../utils/src/logger_util.dart';
import '../../utils/src/network_util.dart';
import '../../utils/src/package_info_util.dart';
import '../../utils/src/share_util.dart';
import '../../utils/src/shared_preferences_util.dart';
import '../../utils/src/vendor_util.dart';
import '../../extension/src/widget_extension.dart';

/// TextScaler.linear(1.adaptRatio),
TextScaler? baseDefaultTextScale = TextScaler.noScaling;

class BaseKeyValue {
  late String key;
  late String value;
  dynamic extend;

  BaseKeyValue({required this.key, required this.value, this.extend});

  BaseKeyValue.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    extend = json['extend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    data['extend'] = extend;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class BaseUploadModel {
  BaseUploadModel({
    this.id,
    this.width,
    this.height,
    this.url,
    this.createdAt,
    this.isSelected = false,
  });

  BaseUploadModel.fromJson(dynamic json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    createdAt = json['createdAt'];
  }

  String? id;
  num? width;
  num? height;
  String? url;
  num? createdAt;
  bool isSelected = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['width'] = width;
    map['height'] = height;
    map['url'] = url;
    map['createdAt'] = createdAt;
    return map;
  }
}

class BaseSettings<T> {
  final String? title;
  final String? hint;
  dynamic extend;
  final Widget? child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<T>? changed;

  BaseSettings(
      {this.title,
      this.hint,
      this.extend,
      this.child,
      this.onPressed,
      this.onLongPress,
      this.changed});
}

class BaseSettingsObx<T> extends BaseSettings<T> {
  final Rx<T> obs;

  BaseSettingsObx({
    super.title,
    super.hint,
    super.extend,
    super.child,
    super.onPressed,
    super.onLongPress,
    super.changed,
    required this.obs,
  });
}

class BaseTextDialogAction {
  final String? title;
  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? background;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;

  BaseTextDialogAction(
      {this.title,
      this.child,
      this.borderRadius,
      this.background,
      this.textStyle,
      this.onPressed});
}

mixin BaseUpdateValidMixin {
  final canSubmit = false.obs;

  void updateValid();

  Future<void> submit();
}

VoidCallback? _appBaseURLChangedCallback;

/// 可切环境、查看日志 additional arguments:
/// --dart-define=app-debug-flag=true
/// flutter run --release --dart-define=app-debug-flag=true
Future<void> initEasyApp({
  bool? logToFile,
  VoidCallback? appBaseURLChangedCallback,
  void Function(Object exception, StackTrace? stackTrace)?
      customExceptionReport,
  String? logFileWrapSplitter,
  String? singleFileSizeLimit,
  int? singleFileHourLimit,
}) async {
  /// https://api.flutter-io.cn/flutter/dart-core/bool/bool.fromEnvironment.html
  const appDebugFlag = bool.fromEnvironment("app-debug-flag");
  isAppDebugFlag = appDebugFlag;
  _appBaseURLChangedCallback = appBaseURLChangedCallback;

  WidgetsFlutterBinding.ensureInitialized();

  BaseEasyLoading.instance.maskType = BaseEasyLoadingMaskType.black;

  final utils = await Future.wait([
    PackageInfoUtil.init(),
    SharedPreferencesUtil.init(),
  ]);

  if (!isWeb) {
    logToFile ??= isAppDebugFlag;
    logFile = LogFile(
      join((await getAppDocumentsDirectory()).path, "logs"),
      enable: logToFile,
      wrapSplitter: logFileWrapSplitter,
      singleFileSizeLimit: singleFileSizeLimit,
      singleFileHourLimit: singleFileHourLimit,
    );
    logDebug("logFile: ${logFile?.location}");
  }

  void localLogWriter(String text, {bool isError = false}) {
    if (isError) {
      logError(text);
    } else {
      logDebug(text);
    }
  }

  Get.config(
    enableLog: isDebug || isAppDebugFlag,
    logWriterCallback: localLogWriter,
  );

  logInfo("Init: $utils ${appChannel} ${gitBranch} ${gitCommit}");
  final network = await initSelectedBaseURLType();
  logInfo("Network: $network $kBaseURLType");

  appDocumentsDirectoryPath =
      isWeb ? "" : (await getAppDocumentsDirectory()).path;
  appTemporaryDirectoryPath =
      isWeb ? "" : (await getAppTemporaryDirectory()).path;
  appSupportDirectoryPath = isWeb ? "" : (await getAppSupportDirectory()).path;

  // 清除分享图片缓存
  clearShareDirectory();

  // 先将 onError 保存起来
  var onError = FlutterError.onError;
  // onError是FlutterError的一个静态属性，它有一个默认的处理方法 dumpErrorToConsole
  FlutterError.onError = (errorDetails) {
    if (customExceptionReport != null) {
      customExceptionReport.call(errorDetails.exception, errorDetails.stack);
    } else {
      logError("${errorDetails.exception}\n${errorDetails.stack}");
    }
    // 调用默认的onError处理
    onError?.call(errorDetails);
  };
  // 官方推荐使用
  PlatformDispatcher.instance.onError = (error, stack) {
    if (customExceptionReport != null) {
      customExceptionReport.call(error, stack);
    } else {
      logError("$error\n$stack");
    }
    return true;
  };
}

/// 默认返回按钮的样式
/// initAppBarLeading = Icons.arrow_back;
/// or
/// initAppBarLeading = assetsImagesPath("icon_arrow_back");
dynamic initAppBarLeading;

abstract class PlatformWidget<M extends Widget, C extends Widget>
    extends StatelessWidget {
  const PlatformWidget({super.key});

  M buildMaterialWidget(BuildContext context);

  C buildCupertinoWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);
  }
}

class BaseApp extends StatefulWidget {
  final String title;
  final bool useMaterial3;
  final ThemeMode themeMode;
  final String? initialRoute;
  final Widget? home;
  final TransitionBuilder? builder;
  final List<NavigatorObserver> navigatorObservers;
  final ValueChanged<Routing?>? routingCallback;
  final RouteFactory? onGenerateRoute;
  final List<GetPage>? getPages;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;
  final LocaleResolutionCallback? localeResolutionCallback;
  final bool? debugShowCheckedModeBanner;
  final bool? showDebugTools;
  final Size designSize;
  final bool splitScreenMode;
  final bool minTextAdapt;

  BaseApp({
    this.title = "",
    this.useMaterial3 = true,
    this.themeMode = ThemeMode.system,
    this.initialRoute,
    this.home,
    this.builder,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.routingCallback,
    this.onGenerateRoute,
    this.getPages,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.localeResolutionCallback,
    this.debugShowCheckedModeBanner,
    this.showDebugTools,
    this.designSize = const Size(375, 812),
    this.splitScreenMode = false,
    this.minTextAdapt = false,
  });

  @override
  _BaseAppState createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  void initState() {
    IntlUtil.initSupportedLocales(widget.supportedLocales.toList());
    baseURLChangedCallback = () {
      if (_appBaseURLChangedCallback != null) {
        _appBaseURLChangedCallback!();
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildBannerUrlType({required Widget child}) {
      if (isAppDebugFlag && widget.debugShowCheckedModeBanner != false) {
        return Obx(() {
          final showDebugTools = widget.showDebugTools ?? isAppDebugFlag;
          return Banner(
            color: Colors.deepPurple,
            message: "${kBaseURLType.name}",
            location: BannerLocation.topEnd,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (showDebugTools) _DebugPage(child: child),
                if (!showDebugTools) child,
                SizedBox(
                  height: screenStatusBarHeightDp,
                  child: Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        "$appVersion+$appBuildNumber",
                        style: TextStyle(
                          fontSize: 12,
                          // color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }
      return child;
    }

    Widget _buildTextScaleFactor(
        {required BuildContext context, required Widget child}) {
      if (!isWeb) {
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: baseDefaultTextScale,
          ),
          child: child,
        );
      }
      return child;
    }

    final botToastBuilder = BotToastInit(); //1. call BotToastInit

    var navigatorObservers = widget.navigatorObservers.toList();
    navigatorObservers.add(BotToastNavigatorObserver());
    return BaseScreenUtilInit(
      // 填入设计稿中设备的屏幕尺寸,单位dp
      designSize: widget.designSize,
      // 是否根据宽度/高度中的最小值适配文字
      minTextAdapt: widget.minTextAdapt,
      // 支持分屏尺寸
      splitScreenMode: widget.splitScreenMode,
      child: GetMaterialApp(
        title: widget.title,
        initialRoute: widget.initialRoute,
        theme: getTheme(useMaterial3: widget.useMaterial3),
        darkTheme: getTheme(darkMode: true, useMaterial3: widget.useMaterial3),
        themeMode: widget.themeMode,
        home: widget.home,
        scrollBehavior: isPhone ? null : _MyCustomScrollBehavior(),
        builder: widget.builder ??
            BaseEasyLoading.init(
              builder: (context, child) {
                child = botToastBuilder(context, child);
                return _buildBannerUrlType(
                  child: _buildTextScaleFactor(context: context, child: child),
                );
              },
            ),
        navigatorObservers: navigatorObservers,
        routingCallback: widget.routingCallback,
        onGenerateRoute: widget.onGenerateRoute,
        getPages: widget.getPages,
        localizationsDelegates: widget.localizationsDelegates,
        supportedLocales: widget.supportedLocales,
        locale: widget.locale,
        localeResolutionCallback: widget.localeResolutionCallback,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// https://github.com/peng8350/flutter_pulltorefresh/issues/544#issuecomment-953643946
class _MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

const double _kDebugIconSize = 44;

class _DebugPage extends StatefulWidget {
  final Widget child;

  const _DebugPage({required this.child});

  @override
  __DebugPageState createState() => __DebugPageState();
}

class __DebugPageState extends State<_DebugPage> {
  bool _flag = false;

  late Offset _offset = Offset(0, screenHeightDp * 0.8);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 显示悬浮按钮
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _insertOverlay(context));
        return widget.child;
      },
    );
  }

  /// 悬浮按钮，可以拖拽
  void _insertOverlay(BuildContext context) {
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      Overlay.of(overlayContext).insert(
        OverlayEntry(builder: (context) {
          return Positioned(
            left: _offset.dx,
            top: _offset.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanEnd: _onPanEnd,
              onPanUpdate: _onPanUpdate,
              onTap: () async {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _flag = !_flag;
                });
                if (_flag) {
                  to(() => EasyLogPage(), transition: Transition.noTransition);
                } else {
                  offBack();
                }
              },
              child: Container(
                width: _kDebugIconSize,
                height: _kDebugIconSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_kDebugIconSize / 2),
                  border: Border.all(color: appTheme(context).primaryColor),
                ),
                child: Icon(
                  _flag ? Icons.clear : Icons.connect_without_contact,
                  color: appTheme(context).primaryColor,
                ),
              ),
            ),
          );
        }),
      );
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final double circleRadius = _kDebugIconSize / 2;
    double y = details.globalPosition.dy - circleRadius;
    double x = details.globalPosition.dx - circleRadius;
    if (x < _kDebugIconSize / 2 - circleRadius) {
      x = _kDebugIconSize / 2 - circleRadius;
    }

    if (y < _kDebugIconSize / 2 - circleRadius) {
      y = _kDebugIconSize / 2 - circleRadius;
    }

    if (x > screenWidthDp - _kDebugIconSize / 2 - circleRadius) {
      x = screenWidthDp - _kDebugIconSize / 2 - circleRadius;
    }

    if (y > screenHeightDp - _kDebugIconSize / 2 - circleRadius) {
      y = screenHeightDp - _kDebugIconSize / 2 - circleRadius;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _offset = Offset(x, y);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    double px;
    const double circleRadius = _kDebugIconSize / 2;
    if (_offset.dx < screenWidthDp / 2 - circleRadius) {
      px = 0; //begin + (end - begin) * t;
    } else {
      px = screenWidthDp - _kDebugIconSize; //begin + (end - begin) * t;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _offset = Offset(px, _offset.dy);
    });
  }
}

Widget? _buildLeading(
    {required BuildContext context,
    Widget? leading,
    required VoidCallback? leadingOnPressed,
    required Color? tintColor}) {
  Widget buildLeading() {
    return initAppBarLeading is Widget
        ? initAppBarLeading
        : initAppBarLeading is String
            ? Image.asset(
                initAppBarLeading,
                width: 24,
                color:
                    tintColor ?? appTheme(context).appBarTheme.foregroundColor,
              )
            : initAppBarLeading is IconData
                ? Icon(initAppBarLeading,
                    color: tintColor ??
                        appTheme(context).appBarTheme.foregroundColor)
                : Icon(Icons.arrow_back_ios,
                    color: tintColor ??
                        appTheme(context).appBarTheme.foregroundColor);
  }

  final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);

  final bool canPop = parentRoute?.canPop ?? false;
  final bool useCloseButton =
      parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

  Widget? _leading = leading;
  if (_leading == null) {
    if (canPop) {
      if (isIOS) {
        _leading = useCloseButton
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.maybePop(context);
                },
                child: Icon(
                  Icons.close,
                  color: tintColor,
                ),
              )
            : BaseButton(
                padding: EdgeInsets.zero,
                onPressed:
                    leadingOnPressed ?? () => Navigator.maybePop(context),
                child: buildLeading(),
              );
      } else {
        _leading = IconButton(
          icon: useCloseButton ? const Icon(Icons.close) : buildLeading(),
          color: tintColor ?? setDarkAppBarForegroundColor,
          onPressed: leadingOnPressed ?? () => Navigator.maybePop(context),
        );
      }
    }
  }
  return _leading;
}

class BaseAppBar extends PlatformWidget<AppBar, PreferredSize> {
  final bool automaticallyImplyLeading;
  final Widget? title;
  final Widget? leading;
  final VoidCallback? leadingOnPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double bottomOpacity;
  final double? elevation;
  final Color? tintColor;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final double? height;
  final bool? centerTitle;

  BaseAppBar({
    this.automaticallyImplyLeading = true,
    this.title,
    this.leading,
    this.leadingOnPressed,
    this.actions,
    this.bottom,
    this.bottomOpacity = 1.0,
    this.elevation,
    this.tintColor,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.height,
    this.centerTitle,
  });

  @override
  AppBar buildMaterialWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading
          ? _buildLeading(
              context: context,
              leading: leading,
              leadingOnPressed: leadingOnPressed,
              tintColor: tintColor,
            )
          : null,
      title: title,
      centerTitle: centerTitle,
      actions: actions ?? [],
      bottom: bottom,
      bottomOpacity: bottomOpacity,
      elevation: elevation,
      backgroundColor: backgroundColor,
      systemOverlayStyle:
          systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height ?? screenToolbarHeightDp),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: automaticallyImplyLeading
            ? _buildLeading(
                context: context,
                leading: leading,
                leadingOnPressed: leadingOnPressed,
                tintColor: tintColor,
              )
            : null,
        title: title,
        centerTitle: centerTitle,
        actions: actions ?? [],
        bottom: bottom,
        bottomOpacity: bottomOpacity,
        elevation: elevation,
        backgroundColor: backgroundColor,
        systemOverlayStyle:
            systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
        forceMaterialTransparency: forceMaterialTransparency,
      ),
    );
  }
}

class BaseSliverAppBar extends PlatformWidget<SliverAppBar, PreferredSize> {
  final Widget? title;
  final Widget? leading;
  final VoidCallback? leadingOnPressed;
  final List<Widget>? actions;
  final double? elevation;
  final Color? tintColor;
  final Color? backgroundColor;
  final bool? centerTitle;
  final bool floating;
  final bool pinned;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;

  BaseSliverAppBar({
    this.title,
    this.leading,
    this.leadingOnPressed,
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.centerTitle,
    this.floating = false,
    this.pinned = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
  });

  @override
  SliverAppBar buildMaterialWidget(BuildContext context) {
    return SliverAppBar(
      leading: _buildLeading(
        context: context,
        leading: leading,
        leadingOnPressed: leadingOnPressed,
        tintColor: tintColor,
      ),
      title: title,
      actions: actions ?? [],
      elevation: elevation,
      backgroundColor: backgroundColor,
      pinned: pinned,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      systemOverlayStyle:
          systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    const _offsetY = -6.0;
    return PreferredSize(
      preferredSize: Size.fromHeight(screenToolbarHeightDp),
      child: SliverAppBar(
        leading: Transform.translate(
          offset: Offset(0, _offsetY),
          child: _buildLeading(
            context: context,
            leading: leading,
            leadingOnPressed: leadingOnPressed,
            tintColor: tintColor,
          ),
        ),
        title: title != null
            ? Transform.translate(offset: Offset(0, _offsetY), child: title)
            : title,
        actions: actions
                ?.map((e) =>
                    Transform.translate(offset: Offset(0, _offsetY), child: e))
                .toList() ??
            [],
        elevation: elevation,
        backgroundColor: backgroundColor,
        centerTitle: centerTitle,
        floating: floating,
        pinned: pinned,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace,
        systemOverlayStyle:
            systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
        forceMaterialTransparency: forceMaterialTransparency,
      ),
    );
  }
}

class BasePopScope extends StatelessWidget {
  final bool onlyAndroid;

  final Widget child;

  final bool canPop;

  final PopInvokedWithResultCallback? onPopInvokedWithResult;

  const BasePopScope(
      {this.onlyAndroid = true,
      required this.child,
      this.canPop = true,
      this.onPopInvokedWithResult});

  @override
  Widget build(BuildContext context) {
    return (!onlyAndroid || isAndroid)
        ? PopScope(
            canPop: BaseEasyLoading.isShow ? false : canPop,
            onPopInvokedWithResult: (bool didPop, result) {
              logDebug("didPop: $didPop, result: $result");
              if (onPopInvokedWithResult != null) {
                onPopInvokedWithResult!(didPop, result);
                return;
              }
              if (!didPop && !BaseEasyLoading.isShow) {
                offBack();
              }
            },
            child: child,
          )
        : child;
  }
}

class BaseScaffold extends StatelessWidget {
  final BaseAppBar? appBar;
  final bool useBasePopScope;

  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;

  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  final Widget? body;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  BaseScaffold({
    this.appBar,
    this.useBasePopScope = false,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.drawerScrimColor,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.body,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
  });

  @override
  Widget build(BuildContext context) {
    Widget scaffold() {
      return Scaffold(
        appBar: appBar != null
            ? (isIOS
                ? appBar?.buildCupertinoWidget(context)
                : appBar?.buildMaterialWidget(context))
            : null,
        drawer: drawer,
        onDrawerChanged: onDrawerChanged,
        endDrawer: endDrawer,
        onEndDrawerChanged: onEndDrawerChanged,
        drawerScrimColor: drawerScrimColor,
        drawerDragStartBehavior: drawerDragStartBehavior,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        body: body,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
      );
    }

    if (useBasePopScope) {
      return BasePopScope(
        child: scaffold(),
      );
    }

    return scaffold();
  }
}

class BaseInkWell extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? pressedColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  BaseInkWell(
      {required this.child,
      this.color,
      this.pressedColor,
      this.borderRadius,
      this.onPressed,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          highlightColor: pressedColor,
          child: child,
        ),
      ),
    );
  }
}

class BaseButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double minSize;
  final Color? color;
  final Color disabledColor;
  final BorderRadius? borderRadius;
  final double? pressedOpacity;
  final Widget child;
  final VoidCallback? onPressed;

  BaseButton(
      {super.key,
      this.padding,
      this.minSize = 0,
      this.color,
      this.disabledColor = CupertinoColors.quaternarySystemFill,
      this.pressedOpacity = 0.4,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      required this.child,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    final style = appTheme(context).textTheme.bodyMedium;
    return CupertinoButton(
      key: key,
      padding: padding,
      minSize: minSize,
      color: onPressed == null ? disabledColor : color,
      disabledColor: disabledColor,
      pressedOpacity: pressedOpacity,
      borderRadius: borderRadius,
      child: style != null
          ? DefaultTextStyle(
              style: style,
              child: child,
            )
          : child,
      onPressed: onPressed,
    );
  }
}

class BaseGradientButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Widget? title;
  final double borderRadius;
  final Gradient gradient;
  final List<BoxShadow>? boxShadow;
  final Gradient disableGradient;
  final VoidCallback? onPressed;

  const BaseGradientButton(
      {super.key,
      this.width = double.infinity,
      this.height = 44,
      this.padding = EdgeInsets.zero,
      this.icon,
      this.title,
      this.borderRadius = 22,
      this.gradient =
          const LinearGradient(colors: [Color(0xFFFF6597), Color(0xFFFF4040)]),
      this.disableGradient =
          const LinearGradient(colors: [Color(0xFFE3E3E3), Color(0xFFD3D3D3)]),
      this.boxShadow,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon!);
      children.add(const SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title!);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: onPressed != null ? gradient : disableGradient,
        boxShadow: boxShadow,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(padding),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.black12;
                }
                return Colors.transparent;
              },
            ),
          ),
          onPressed: onPressed,
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children),
          ),
        ),
      ),
    );
  }
}

@Deprecated('use [BaseTextButton()] instead')
class BaseBackgroundButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final Widget? title;
  final BorderRadiusGeometry borderRadius;
  final Border? border;
  final Color? color;
  final Color? pressedColor;
  final Color? disableColor;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const BaseBackgroundButton({
    super.key,
    this.width = double.infinity,
    this.height = 44,
    this.padding = EdgeInsets.zero,
    this.icon,
    this.title,
    this.borderRadius = const BorderRadius.all(Radius.circular(32)),
    this.border,
    this.color,
    this.pressedColor,
    this.disableColor,
    this.onPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon!);
      children.add(const SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title!);
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
        color: (onPressed != null || onLongPress != null)
            ? (color ?? appTheme(context).primaryColor)
            : (disableColor ?? Colors.black12),
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(padding),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: borderRadius)),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return pressedColor ?? Colors.black12;
              }
              return Colors.transparent;
            },
          ),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center, children: children),
        ),
      ),
    );
  }
}

@Deprecated('use [BaseButton()] instead')
class BaseOutlineButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final Color? backgroundColor;
  final Widget? icon;
  final Widget? title;
  final double borderWidth;
  final double borderRadius;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onPressed;

  const BaseOutlineButton(
      {super.key,
      this.width = double.infinity,
      this.height = 44,
      this.padding,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.backgroundColor,
      this.icon,
      this.title,
      this.borderWidth = 1,
      this.borderRadius = 22,
      this.borderColor,
      this.boxShadow,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon!);
      children.add(const SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title!);
    }
    return BaseButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      color: Colors.transparent,
      disabledColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          border: Border.all(
              width: borderWidth,
              color: borderColor ?? appTheme(context).primaryColor),
          boxShadow: boxShadow,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
  }
}

class BaseTextField extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final int maxLines;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? placeholderStyle;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final String? placeholder;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final BaseOverlayVisibilityMode clearButtonMode;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final BoxDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;

  const BaseTextField(
      {super.key,
      this.margin,
      this.padding = const EdgeInsets.all(6.0),
      this.borderRadius,
      this.backgroundColor,
      this.maxLines = 1,
      this.style,
      this.placeholderStyle,
      this.controller,
      this.obscureText = false,
      this.autofocus = false,
      this.readOnly = false,
      this.maxLength,
      this.placeholder,
      this.focusNode,
      this.keyboardType,
      this.textAlign = TextAlign.start,
      this.textInputAction,
      this.clearButtonMode = BaseOverlayVisibilityMode.editing,
      this.inputFormatters,
      this.prefix,
      this.suffix,
      this.decoration,
      this.onChanged,
      this.onSubmitted,
      this.buildCounter,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 5.r),
      ),
      child: maxLines > 1
          ? Padding(
              padding: padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (prefix != null) prefix!,
                  Expanded(
                    child: TextField(
                      controller: controller,
                      maxLines: maxLength,
                      readOnly: readOnly,
                      obscureText: obscureText,
                      autofocus: autofocus,
                      focusNode: focusNode,
                      cursorColor: appTheme(context).primaryColor,
                      keyboardType: keyboardType,
                      textAlign: textAlign,
                      textInputAction: textInputAction,
                      inputFormatters: inputFormatters,
                      style: style ??
                          (appDarkMode(context)
                              ? setDarkTextFieldStyle
                              : setLightTextFieldStyle),
                      decoration: InputDecoration.collapsed(
                        hintText: placeholder,
                        hintStyle: placeholderStyle,
                      ),
                      maxLength: maxLength,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      onTap: onTap,
                      buildCounter: buildCounter,
                    ),
                  ),
                  if (suffix != null) suffix!,
                ],
              ),
            )
          : CupertinoTextField(
              padding: padding,
              controller: controller,
              maxLines: maxLines,
              readOnly: readOnly,
              obscureText: obscureText,
              autofocus: autofocus,
              focusNode: focusNode,
              cursorColor: appTheme(context).primaryColor,
              style: style ??
                  (appDarkMode(context)
                      ? setDarkTextFieldStyle
                      : setLightTextFieldStyle),
              clearButtonMode:
                  readOnly ? BaseOverlayVisibilityMode.never : clearButtonMode,
              keyboardType: keyboardType,
              textAlign: textAlign,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              placeholder: placeholder,
              placeholderStyle: placeholderStyle ??
                  (appDarkMode(context)
                      ? setDarkPlaceholderTextFieldStyle
                      : setLightPlaceholderTextFieldStyle),
              prefix: prefix,
              suffix: suffix,
              decoration: decoration,
              maxLength: maxLength,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              onTap: onTap,
            ),
    );
  }
}

Widget baseDefaultGeneralAlertDialogTitle = const Text('提示');

class BaseGeneralAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  const BaseGeneralAlertDialog(
      {super.key, this.title, this.content, this.actions = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      key: key,
      title: title ?? baseDefaultGeneralAlertDialogTitle,
      content:
          Container(margin: const EdgeInsets.only(top: 10), child: content),
      actions: actions,
    );
  }
}

class BaseCustomAlertDialog extends Dialog {
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets margin;
  final Widget content;

  const BaseCustomAlertDialog({
    super.key,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.margin = const EdgeInsets.all(38.0),
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAlertDialog(
      titlePadding: EdgeInsets.zero,
      actionPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: const SizedBox(),
      borderRadius: borderRadius,
      margin: margin,
      content: content,
      backgroundColor: backgroundColor,
    );
  }
}

class BaseAlertDialog extends Dialog {
  final bool barrierDismissible;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets margin;
  final EdgeInsets titlePadding;
  final EdgeInsets contentPadding;
  final EdgeInsets actionPadding;
  final MainAxisAlignment actionsAxisAlignment;
  final Color? backgroundColor;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const BaseAlertDialog({
    super.key,
    this.barrierDismissible = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.margin = const EdgeInsets.all(38.0),
    this.titlePadding = const EdgeInsets.fromLTRB(20.0, 34.0, 20.0, 20.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.actionPadding = const EdgeInsets.fromLTRB(20, 24, 20, 34),
    this.actionsAxisAlignment = MainAxisAlignment.spaceAround,
    this.backgroundColor,
    this.title = const Text('提示'),
    required this.content,
    this.actions = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: barrierDismissible ? () => Navigator.of(context).pop() : null,
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: ShapeDecoration(
                color: backgroundColor ??
                    appTheme(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
              ),
              margin: margin,
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: titlePadding,
                    child: Center(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: colorWithHex3,
                        ),
                        child: title,
                      ),
                    ),
                  ),
                  Container(
                    padding: contentPadding,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorWithHex3,
                      ),
                      child: content,
                    ),
                  ),
                  Container(
                    padding: actionPadding,
                    child: new Row(
                      mainAxisAlignment: actionsAxisAlignment,
                      children: actions,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BaseDialogAction extends StatelessWidget {
  const BaseDialogAction({
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.textStyle,
    required this.child,
  });

  final VoidCallback? onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final TextStyle? textStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
      textStyle: textStyle,
      child: child,
    );
  }
}

///  只针对[BaseGeneralAlertDialog]设置[barrierDismissible]有效
@Deprecated('use [showBaseAlert()] instead')
Future<T?> showBaseDialog<T>({
  required BuildContext context,
  Color? barrierColor = Colors.black54,
  bool barrierDismissible = false,
  bool useSafeArea = true,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(
      context: context,
      useSafeArea: useSafeArea,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      builder: builder);
}

class BaseActionSheet extends StatelessWidget {
  final Widget? title;
  final Widget? message;
  final List<Widget> actions;
  final Widget cancelButton;

  const BaseActionSheet({
    super.key,
    this.title,
    this.message,
    this.actions = const <Widget>[],
    required this.cancelButton,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      key: key,
      title: title,
      message: message,
      actions: actions,
      cancelButton: cancelButton,
    );
  }
}

class BaseActionSheetAction extends StatelessWidget {
  final VoidCallback onPressed;

  final bool isDefaultAction;

  final bool isDestructiveAction;

  final bool isEnable;

  final Widget child;

  const BaseActionSheetAction({
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.isEnable = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: onPressed,
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
      child: child,
    );
  }
}

@Deprecated('use [showBaseBottomSheet()] instead')
Future<T?> showBaseModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
}) {
  return showCupertinoModalPopup(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible);
}

Future<T?> showBaseBottomSheet<T>(
  Widget bottomSheet, {
  Color? backgroundColor,
  double? elevation,
  bool persistent = true,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor = kCupertinoModalBarrierColor,
  bool? ignoreSafeArea,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? settings,
  Duration? enterBottomSheetDuration,
  Duration? exitBottomSheetDuration,
}) {
  return Get.bottomSheet(
    bottomSheet,
    backgroundColor: backgroundColor,
    elevation: elevation,
    persistent: persistent,
    shape: shape,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor,
    ignoreSafeArea: ignoreSafeArea,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    settings: settings,
    enterBottomSheetDuration: enterBottomSheetDuration,
    exitBottomSheetDuration: exitBottomSheetDuration,
  );
}

Future<T?> showBaseTopSheet<T>(
  Widget child, {
  bool barrierDismissible = true,
  BorderRadiusGeometry? borderRadius,
  Duration transitionDuration = const Duration(milliseconds: 250),
  Color? backgroundColor,
  Color barrierColor = const Color(0x80000000),
  Offset startOffset = const Offset(0, -1.0),
  Curve curve = Curves.easeOutCubic,
}) {
  return showGeneralDialog<T?>(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
    barrierColor: barrierColor,
    barrierLabel: MaterialLocalizations.of(Get.context!).dialogLabel,
    pageBuilder: (context, _, __) => child,
    transitionBuilder: (context, animation, _, child) {
      return SlideTransition(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              type: backgroundColor == null
                  ? MaterialType.transparency
                  : MaterialType.canvas,
              color: backgroundColor,
              borderRadius: borderRadius,
              clipBehavior: Clip.antiAlias,
              child: child,
            )
          ],
        ),
        position: CurvedAnimation(parent: animation, curve: curve)
            .drive(Tween<Offset>(begin: startOffset, end: Offset.zero)),
      );
    },
  );
}

Future<T?> showBaseAlert<T>(
  Widget widget, {
  bool barrierDismissible = true,
  Color? barrierColor,
  bool useSafeArea = true,
  GlobalKey<NavigatorState>? navigatorKey,
  Object? arguments,
  Duration? transitionDuration,
  Curve? transitionCurve,
  String? name,
  RouteSettings? routeSettings,
}) {
  return Get.dialog<T>(
    widget,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    navigatorKey: navigatorKey,
    arguments: arguments,
    transitionDuration: transitionDuration,
    transitionCurve: transitionCurve,
    name: name,
    routeSettings: routeSettings,
  );
}

class BaseDivider extends StatelessWidget {
  /// 分割线的厚度
  final double? thickness;

  /// 缩进距离
  final EdgeInsets? margin;

  /// 分割线颜色
  final Color? color;

  const BaseDivider({
    super.key,
    this.thickness,
    this.margin,
    this.color,
  }) : assert(thickness == null || thickness >= 0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: thickness ?? 1,
      color: color ?? appTheme(context).dividerColor,
    );
  }
}

class BaseBlurFilter extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry borderRadius;
  final ImageFilter? filter;
  final Color? backgroundColor;
  final Widget child;

  const BaseBlurFilter(
      {super.key,
      this.padding,
      this.borderRadius = BorderRadius.zero,
      this.filter,
      this.backgroundColor = Colors.white10,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: filter ??
            ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
        child: Container(
          color: backgroundColor,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class BaseBorderText extends StatelessWidget {
  const BaseBorderText({
    super.key,
    required this.child,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
    this.strokeWidth = 1.0,
    this.strokeColor = Colors.black,
    this.textAlignment = Alignment.center,
  });

  /// the stroke cap style
  final StrokeCap strokeCap;

  /// the stroke joint style
  final StrokeJoin strokeJoin;

  /// the stroke width
  final double strokeWidth;

  /// the stroke color
  final Color strokeColor;

  /// the [Text] widget to apply stroke on
  final Text child;

  /// the alignment of the text
  final Alignment textAlignment;

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    if (child.style != null) {
      style = child.style!.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = strokeCap
          ..strokeJoin = strokeJoin
          ..strokeWidth = strokeWidth
          ..color = strokeColor,
        color: null,
      );
    } else {
      style = TextStyle(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = strokeCap
          ..strokeJoin = strokeJoin
          ..strokeWidth = strokeWidth
          ..color = strokeColor,
      );
    }
    return Stack(
      alignment: textAlignment,
      textDirection: child.textDirection,
      children: <Widget>[
        Text(
          child.data!,
          style: style,
          maxLines: child.maxLines,
          overflow: child.overflow,
          semanticsLabel: child.semanticsLabel,
          softWrap: child.softWrap,
          strutStyle: child.strutStyle,
          textAlign: child.textAlign,
          textDirection: child.textDirection,
        ),
        child,
      ],
    );
  }
}

class BaseCard extends StatelessWidget {
  final double? elevation;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const BaseCard(
      {super.key,
      this.elevation = 0.0,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      this.color = Colors.white,
      this.padding = const EdgeInsets.all(12.0),
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class BaseTextButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Color? color;
  final Color? pressedColor;
  final Color? disableColor;
  final List<BoxShadow>? boxShadow;
  final bool autofocus;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const BaseTextButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    required this.child,
    this.borderRadius,
    this.border,
    this.color,
    this.pressedColor,
    this.disableColor,
    this.boxShadow,
    this.autofocus = false,
    this.onPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        color: (onPressed != null || onLongPress != null)
            ? (color ?? appTheme(context).primaryColor)
            : (disableColor ?? Colors.black12),
        boxShadow: boxShadow,
      ),
      child: TextButton(
        autofocus: autofocus,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size.zero),
          padding: WidgetStateProperty.all(padding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero),
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return pressedColor ?? Colors.black12;
              } else if (states.contains(WidgetState.disabled)) {
                return disableColor ?? Colors.black12;
              }
              return Colors.transparent;
            },
          ),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}

class BaseBottomBarItem extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  final Widget icon;

  final Widget? label;

  final double spacing;

  final VoidCallback? onPressed;

  const BaseBottomBarItem({
    super.key,
    this.padding = const EdgeInsets.all(5),
    required this.icon,
    this.label,
    this.spacing = 0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      padding: padding,
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: spacing),
          if (label != null) label!,
        ],
      ),
    );
  }
}

class BaseBottomBar extends StatelessWidget {
  final double height;
  final MainAxisAlignment mainAxisAlignment;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final BorderRadiusGeometry borderRadius;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? backgroundColor;
  final bool ignoreSafeArea;
  final List<BoxShadow>? boxShadow;
  final ValueChanged<int>? onPressed;

  const BaseBottomBar(
      {super.key,
      this.height = kBottomNavigationBarHeight,
      this.mainAxisAlignment = MainAxisAlignment.spaceAround,
      this.mainAxisSpacing = 0.0,
      this.crossAxisSpacing = 4.0,
      required this.items,
      this.currentIndex = 0,
      this.borderRadius = BorderRadius.zero,
      this.selectedItemColor,
      this.unselectedItemColor,
      this.selectedLabelStyle,
      this.unselectedLabelStyle,
      this.backgroundColor = Colors.white,
      this.ignoreSafeArea = false,
      this.boxShadow = const [
        BoxShadow(
          color: Color(0x08000000),
          offset: Offset(0, -4),
          blurRadius: 8,
        ),
      ],
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: backgroundColor,
            boxShadow: boxShadow,
          ),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return BaseBottomBarItem(
                spacing: crossAxisSpacing,
                icon: isSelected ? item.activeIcon : item.icon,
                label: item.label != null
                    ? Text(
                        item.label!,
                        style: isSelected
                            ? selectedLabelStyle ??
                                TextStyle(
                                  fontSize: 13,
                                  color: selectedItemColor ??
                                      appTheme(context).primaryColor,
                                )
                            : unselectedLabelStyle ??
                                TextStyle(
                                  fontSize: 13,
                                  color: unselectedItemColor ?? Colors.black,
                                ),
                      )
                    : null,
                onPressed: () => onPressed?.call(index),
              );
            }).toList(),
          ).withSpacing(mainAxisSpacing),
        ),
        if (!ignoreSafeArea)
          Container(
            height: screenBottomBarHeightDp,
            color: backgroundColor,
          ),
      ],
    );
  }
}

class BaseSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color? activeColor;
  final Color? inactiveColor;
  final int? divisions;
  final String? label;
  final double? trackHeight;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  const BaseSlider(
      {super.key,
      required this.value,
      required this.min,
      required this.max,
      this.activeColor,
      this.inactiveColor,
      this.divisions,
      this.label,
      this.trackHeight,
      this.onChanged,
      this.onChangeEnd});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: Get.theme.sliderTheme.copyWith(
        trackHeight: trackHeight,
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: 0, // 禁用触摸涟漪扩展
        ),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
    );
  }
}
