import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easy/flutter_easy.dart';

double? baseDefaultTextScaleFactor;

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

VoidCallback? _appBaseURLChangedCallback;

/// 可切环境、查看日志 additional arguments:
/// --dart-define=app-debug-flag=true
/// flutter run --release --dart-define=app-debug-flag=true
Future<void> initEasyApp({VoidCallback? appBaseURLChangedCallback}) async {
  /// https://api.flutter-io.cn/flutter/dart-core/bool/bool.fromEnvironment.html
  const appDebugFlag = bool.fromEnvironment("app-debug-flag");
  isAppDebugFlag = appDebugFlag;
  _appBaseURLChangedCallback = appBaseURLChangedCallback;

  WidgetsFlutterBinding.ensureInitialized();

  final utils = await Future.wait([
    PackageInfoUtil.init(),
    SharedPreferencesUtil.init(),
  ]);

  Get.put(EasyLogConsoleController());

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

  logInfo("Init: $utils");
  if (isAppDebugFlag) {
    final network = await initSelectedBaseURLType();
    logInfo("Network: $network");
  }
}

/// 默认返回按钮的样式
/// initAppBarLeading = Icons.arrow_back;
/// or
/// initAppBarLeading = assetsImagesPath("icon_arrow_back");
dynamic initAppBarLeading;

abstract class PlatformWidget<M extends Widget, C extends Widget>
    extends StatelessWidget {
  const PlatformWidget({Key? key}) : super(key: key);

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
  final ThemeMode themeMode;
  final String? initialRoute;
  final Widget? home;
  final TransitionBuilder? builder;
  final List<NavigatorObserver> navigatorObservers;
  final RouteFactory? onGenerateRoute;
  final List<GetPage>? getPages;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;
  final LocaleResolutionCallback? localeResolutionCallback;

  BaseApp({
    this.title = "",
    this.themeMode = ThemeMode.system,
    this.initialRoute,
    this.home,
    this.builder,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.onGenerateRoute,
    this.getPages,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.localeResolutionCallback,
  });

  @override
  _BaseAppState createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  void initState() {
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
      if (isAppDebugFlag) {
        return Obx(() {
          return Banner(
            color: Colors.deepPurple,
            message: kBaseURLType == BaseURLType.release ? "Release" : "Test",
            location: BannerLocation.topEnd,
            child: _DebugPage(child: child),
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
            textScaleFactor: baseDefaultTextScaleFactor ?? 1.adaptRatio,
          ),
          child: child,
        );
      }
      return child;
    }

    return GetMaterialApp(
      title: widget.title,
      initialRoute: widget.initialRoute,
      theme: getTheme(),
      darkTheme: getTheme(darkMode: true),
      themeMode: widget.themeMode,
      home: widget.home,
      scrollBehavior: isPhone ? null : _MyCustomScrollBehavior(),
      builder: widget.builder ??
          EasyLoading.init(
            builder: (context, child) {
              AdaptUtil.initContext(context);
              return _buildBannerUrlType(
                child: _buildTextScaleFactor(context: context, child: child!),
              );
            },
          ),
      navigatorObservers: widget.navigatorObservers,
      onGenerateRoute: widget.onGenerateRoute,
      getPages: widget.getPages,
      localizationsDelegates: widget.localizationsDelegates,
      supportedLocales: widget.supportedLocales,
      locale: widget.locale,
      localeResolutionCallback: widget.localeResolutionCallback,
      debugShowCheckedModeBanner: false,
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

const double _kDebugIconSize = 50;

class _DebugPage extends StatefulWidget {
  final Widget child;

  const _DebugPage({Key? key, required this.child}) : super(key: key);

  @override
  __DebugPageState createState() => __DebugPageState();
}

class __DebugPageState extends State<_DebugPage> {
  bool _flag = false;

  late Offset _offset = Offset(0, screenHeightDp - 100);

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
            child: Opacity(
              opacity: 0.6,
              child: Container(
                width: _kDebugIconSize,
                height: _kDebugIconSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appTheme(context).primaryColor,
                  borderRadius: BorderRadius.circular(_kDebugIconSize / 2),
                ),
                child: GestureDetector(
                  onPanEnd: _onPanEnd,
                  onPanUpdate: _onPanUpdate,
                  child: BaseButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      _flag ? Icons.clear : Icons.connect_without_contact,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _flag = !_flag;
                      });
                      final context = Get.context;
                      if (context != null) {
                        if (_flag) {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            final EasyLogConsoleController controller =
                                Get.put(EasyLogConsoleController());
                            if (controller.flowchart.value) {
                              0.25.seconds.delay(() {
                                controller.scrollToBottom();
                              });
                            }
                            return EasyLogConsolePage();
                          }));
                        } else {
                          offBack();
                        }
                        setState(() {
                          _flag = !_flag;
                        });
                      }
                    },
                  ),
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
    return initAppBarLeading is String
        ? Image.asset(
            initAppBarLeading,
            width: 24,
            color: tintColor ?? appTheme(context).appBarTheme.foregroundColor,
          )
        : initAppBarLeading is IconData
            ? Icon(initAppBarLeading,
                color:
                    tintColor ?? appTheme(context).appBarTheme.foregroundColor)
            : Icon(Icons.arrow_back_ios,
                color:
                    tintColor ?? appTheme(context).appBarTheme.foregroundColor);
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
  final double? elevation;
  final Color? tintColor;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? height;

  BaseAppBar({
    this.automaticallyImplyLeading = true,
    this.title,
    this.leading,
    this.leadingOnPressed,
    this.actions,
    this.elevation,
    this.tintColor,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.height,
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
      actions: actions ?? [],
      elevation: elevation,
      backgroundColor: backgroundColor,
      systemOverlayStyle:
          systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
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
        actions: actions ?? [],
        elevation: elevation,
        backgroundColor: backgroundColor,
        systemOverlayStyle:
            systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
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
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(screenToolbarHeightDp),
      child: SliverAppBar(
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
        centerTitle: centerTitle,
        floating: floating,
        pinned: pinned,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace,
        systemOverlayStyle:
            systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle,
      ),
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final BaseAppBar? appBar;

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

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  BaseScaffold({
    this.appBar,
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
        resizeToAvoidBottomInset: false,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
      );
    }

    return isAndroid
        ? WillPopScope(
            onWillPop: () async {
              if (EasyLoading.instance.w != null) {
                return false;
              }
              return true;
            },
            child: scaffold(),
          )
        : scaffold();
  }
}

class BaseInkWell extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Color? color;
  final Widget child;
  final VoidCallback? onPressed;

  BaseInkWell(
      {this.padding,
      this.shape,
      this.color,
      required this.child,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        shape: MaterialStateProperty.all(shape),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (onPressed != null && states.contains(MaterialState.pressed)) {
              return Colors.black12;
            }
            return color;
          },
        ),
      ),
      onPressed: onPressed ?? () {},
      child: child,
    );
  }
}

class BaseButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? minSize;
  final Color? color;
  final Color disabledColor;
  final BorderRadius? borderRadius;
  final double? pressedOpacity;
  final Widget child;
  final VoidCallback? onPressed;

  BaseButton(
      {this.padding,
      this.minSize,
      this.color,
      this.disabledColor = CupertinoColors.quaternarySystemFill,
      this.pressedOpacity = 0.4,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      required this.child,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding,
      minSize: minSize,
      color: onPressed == null ? disabledColor : color,
      disabledColor: disabledColor,
      pressedOpacity: pressedOpacity,
      borderRadius: borderRadius,
      child: child,
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
      {Key? key,
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
      required this.onPressed})
      : super(key: key);

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
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.pressed)) {
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

class BaseBackgroundButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final Widget? title;
  final double borderRadius;
  final Color? color;
  final Color? disableColor;
  final VoidCallback? onPressed;

  const BaseBackgroundButton(
      {Key? key,
      this.width = double.infinity,
      this.height = 44,
      this.padding = EdgeInsets.zero,
      this.icon,
      this.title,
      this.borderRadius = 22,
      this.color,
      this.disableColor,
      this.onPressed})
      : super(key: key);

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
        borderRadius: BorderRadius.circular(borderRadius),
        color: onPressed != null
            ? (color ?? appTheme(context).primaryColor)
            : (disableColor ?? Colors.black12),
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black12;
              }
              return Colors.transparent;
            },
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center, children: children),
        ),
      ),
    );
  }
}

class BaseOutlineButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Widget? icon;
  final Widget? title;
  final double borderWidth;
  final double borderRadius;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onPressed;

  const BaseOutlineButton(
      {Key? key,
      this.width = double.infinity,
      this.height = 44,
      this.padding,
      this.backgroundColor,
      this.icon,
      this.title,
      this.borderWidth = 1,
      this.borderRadius = 22,
      this.borderColor,
      this.boxShadow,
      this.onPressed})
      : super(key: key);

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
            adaptDp(borderRadius),
          ),
          border:
              Border.all(color: borderColor ?? appTheme(context).primaryColor),
          boxShadow: boxShadow,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final int maxLines;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? placeholderStyle;
  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final String? placeholder;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final OverlayVisibilityMode clearButtonMode;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final BoxDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;

  const BaseTextField(
      {Key? key,
      this.margin,
      this.padding = const EdgeInsets.all(6.0),
      this.height,
      this.borderRadius,
      this.backgroundColor,
      this.maxLines = 1,
      this.style,
      this.placeholderStyle,
      this.controller,
      this.obscureText = false,
      this.readOnly = false,
      this.maxLength,
      this.placeholder,
      this.focusNode,
      this.keyboardType,
      this.textAlign = TextAlign.start,
      this.textInputAction,
      this.clearButtonMode = OverlayVisibilityMode.editing,
      this.inputFormatters,
      this.prefix,
      this.suffix,
      this.decoration,
      this.onChanged,
      this.onSubmitted,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height ?? adaptDp(40),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? adaptDp(5)),
      ),
      child: CupertinoTextField(
        padding: padding,
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        obscureText: obscureText,
        autofocus: false,
        focusNode: focusNode,
        cursorColor: appTheme(context).primaryColor,
        style: style ??
            (appDarkMode(context)
                ? setDarkTextFieldStyle
                : setLightTextFieldStyle),
        clearButtonMode:
            readOnly ? OverlayVisibilityMode.never : clearButtonMode,
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
      {Key? key, this.title, this.content, this.actions = const <Widget>[]})
      : super(key: key);

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
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets margin;
  final Widget content;

  const BaseCustomAlertDialog({
    Key? key,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.margin = const EdgeInsets.all(38.0),
    required this.content,
  }) : super(key: key);

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
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const BaseAlertDialog({
    Key? key,
    this.barrierDismissible = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.margin = const EdgeInsets.all(38.0),
    this.titlePadding = const EdgeInsets.fromLTRB(20.0, 34.0, 20.0, 20.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.actionPadding = const EdgeInsets.fromLTRB(20, 24, 20, 34),
    this.actionsAxisAlignment = MainAxisAlignment.spaceAround,
    this.title = const Text('提示'),
    required this.content,
    this.actions = const <Widget>[],
  }) : super(key: key);

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
                color: Colors.white,
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
                          fontSize: adaptDp(16),
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
                        fontSize: adaptDp(14),
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
    Key? key,
    this.title,
    this.message,
    this.actions = const <Widget>[],
    required this.cancelButton,
  }) : super(key: key);

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

class BaseDivider extends StatelessWidget {
  /// 分割线的厚度
  final double? thickness;

  /// 缩进距离
  final EdgeInsets? margin;

  /// 分割线颜色
  final Color? color;

  const BaseDivider({
    Key? key,
    this.thickness,
    this.margin,
    this.color,
  })  : assert(thickness == null || thickness >= 0.0),
        super(key: key);

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
  final BorderRadius? borderRadius;
  final ImageFilter? filter;
  final Color? backgroundColor;
  final Widget child;

  const BaseBlurFilter(
      {Key? key,
      this.padding,
      this.borderRadius = BorderRadius.zero,
      this.filter,
      this.backgroundColor = Colors.white10,
      required this.child})
      : super(key: key);

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
