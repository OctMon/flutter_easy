import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easy/flutter_easy.dart';

typedef ComputeResult<T> = void Function(T state, RxStatus status);

extension BaseStateExt<T> on StateMixin<T> {
  Widget easy(
    NotifierBuilder<T?> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    void Function()? onLoadTap,
  }) {
    return SimpleBuilder(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: BaseLoadingView());
      } else if (status.isError) {
        return onError != null
            ? onError(status.errorMessage)
            : Center(
                child: BasePlaceholderView(
                title: "${status.errorMessage}",
                onTap: onLoadTap,
              ));
      } else if (status.isEmpty) {
        return onEmpty != null
            ? onEmpty
            : SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(state);
    });
  }

  Widget baseRefresh(
    NotifierBuilder<T?> widget, {
    required EasyRefreshController refreshController,
    Widget Function(String? message)? onEmptyWidget,
    OnRefreshCallback? onRefresh,
    OnLoadCallback? onLoad,
    void Function()? onLoadTap,
  }) {
    return SimpleBuilder(builder: (_) {
      return BaseRefresh(
        controller: refreshController,
        emptyWidget: state.isEmptyOrNull
            ? (onEmptyWidget != null
                ? onEmptyWidget(status.errorMessage)
                : BasePlaceholderView(
                    title: status.errorMessage,
                    onTap: onLoadTap ?? () => refreshController.callRefresh(),
                  ))
            : null,
        onRefresh: onRefresh,
        onLoad: onLoad,
        child: widget(state),
      );
    });
  }

  void updateResult<T>(Result result,
      {required EasyRefreshController refreshController,
      required int page,
      required ComputeResult compute}) {
    dynamic _list = result.models.toList();
    if (result.valid) {
      if (_list.isNotEmpty) {
        if (page > kFirstPage) {
          dynamic _tmp = state;
          compute(_tmp..addAll(_list), RxStatus.success());
          refreshController.finishLoad(
              success: result.valid, noMore: _list.length < kLimitPage);
        } else {
          compute(_list, RxStatus.success());
          refreshController.finishRefresh(success: result.valid, noMore: false);
          refreshController.resetLoadState();
        }
      }
    } else {
      refreshController.resetLoadState();
      if (page > kFirstPage) {
        refreshController.finishLoad(success: result.valid);
      } else {
        refreshController.finishRefresh(success: result.valid);
      }
      dynamic tmp = state;
      compute(tmp, RxStatus.error(result.message));
    }
  }
}

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['extend'] = this.extend;
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
createEasyApp(
    {VoidCallback? appBaseURLChangedCallback,
    Future<void> Function()? initCallback,
    required VoidCallback completionCallback}) {
  /// https://api.flutter-io.cn/flutter/dart-core/bool/bool.fromEnvironment.html
  const appDebugFlag = const bool.fromEnvironment("app-debug-flag");
  isAppDebugFlag = appDebugFlag;
  _appBaseURLChangedCallback = appBaseURLChangedCallback;
  void callback() {
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

    if (initCallback != null) {
      initCallback().then((_) {
        completionCallback();
      });
    } else {
      completionCallback();
    }
  }

  WidgetsFlutterBinding.ensureInitialized();

  Future.wait([
    PackageInfoUtil.init(),
    SharedPreferencesUtil.init(),
  ]).then((e) {
    logInfo("init: $e");
    if (isAppDebugFlag) {
      initSelectedBaseURLType().then((value) {
        logInfo("network: $value");
        callback();
      });
    } else {
      callback();
    }
  });
}

/// 默认返回按钮的样式
/// initAppBarLeading = Icons.arrow_back;
/// or
/// initAppBarLeading = assetsImagesPath("icon_arrow_back");
dynamic initAppBarLeading;

abstract class PlatformWidget<M extends Widget, C extends Widget>
    extends StatelessWidget {
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
      setState(() {});
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
        return Banner(
          color: Colors.deepPurple,
          message:
              "${kBaseURLType == BaseURLType.release ? "Release" : "Test"}",
          location: BannerLocation.topEnd,
          child: _DebugPage(child: child),
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
      builder: widget.builder ??
          EasyLoading.init(
            builder: (context, child) {
              AdaptUtil.initContext(context);
              return _buildBannerUrlType(
                child: Scaffold(
                  // Global GestureDetector that will dismiss the keyboard
                  body: GestureDetector(
                    onTap: () {
                      hideKeyboard(context);
                    },
                    child: child,
                  ),
                ),
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

class _DebugPage extends StatefulWidget {
  final Widget child;

  const _DebugPage({Key? key, required this.child}) : super(key: key);

  @override
  __DebugPageState createState() => __DebugPageState();
}

const double _kMenuSize = 40;

class __DebugPageState extends State<_DebugPage> {
  bool _flag = false;

  Offset _offset = Offset(0, 200);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _flag
            ? Visibility(
                visible: _flag,
                child: EasyLogConsolePage(),
              )
            : SizedBox(),
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Opacity(
            opacity: 0.6,
            child: Container(
              width: _kMenuSize,
              height: _kMenuSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(_kMenuSize / 2),
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
                  onPressed: () {
                    setState(() {
                      _flag = !_flag;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final double circleRadius = _kMenuSize / 2;
    double y = details.globalPosition.dy - circleRadius;
    double x = details.globalPosition.dx - circleRadius;
    if (x < _kMenuSize / 2 - circleRadius) {
      x = _kMenuSize / 2 - circleRadius;
    }

    if (y < _kMenuSize / 2 - circleRadius) {
      y = _kMenuSize / 2 - circleRadius;
    }

    if (x > screenWidthDp - _kMenuSize / 2 - circleRadius) {
      x = screenWidthDp - _kMenuSize / 2 - circleRadius;
    }

    if (y > screenHeightDp - _kMenuSize / 2 - circleRadius) {
      y = screenHeightDp - _kMenuSize / 2 - circleRadius;
    }
    setState(() {
      _offset = Offset(x, y);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    double px;
    final double circleRadius = _kMenuSize / 2;
    if (_offset.dx < screenWidthDp / 2 - circleRadius) {
      px = 0; //begin + (end - begin) * t;
    } else {
      px = screenWidthDp - _kMenuSize; //begin + (end - begin) * t;
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
            color: tintColor,
          )
        : initAppBarLeading is IconData
            ? Icon(initAppBarLeading, color: tintColor)
            : Icon(Icons.arrow_back_ios, color: tintColor);
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
                child: Icon(
                  Icons.close,
                  color: tintColor,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.maybePop(context);
                },
              )
            : BaseButton(
                padding: EdgeInsets.zero,
                child: buildLeading(),
                onPressed:
                    leadingOnPressed ?? () => Navigator.maybePop(context),
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
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(screenToolbarHeightDp),
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
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor,
        systemOverlayStyle: systemOverlayStyle,
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
        leading: this.leading,
        leadingOnPressed: leadingOnPressed,
        tintColor: tintColor,
      ),
      title: title,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor,
      pinned: pinned,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(screenToolbarHeightDp),
      child: SliverAppBar(
        leading: _buildLeading(
          context: context,
          leading: this.leading,
          leadingOnPressed: leadingOnPressed,
          tintColor: tintColor,
        ),
        title: title,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor,
        centerTitle: centerTitle,
        floating: floating,
        pinned: pinned,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace,
        systemOverlayStyle: systemOverlayStyle,
      ),
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final BaseAppBar? appBar;
  final Widget? body;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  BaseScaffold({
    this.appBar,
    this.body,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar != null
          ? (isIOS
              ? appBar?.buildCupertinoWidget(context)
              : appBar?.buildMaterialWidget(context))
          : null,
      body: body,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
    );
  }
}

class BaseText extends StatelessWidget {
  final String? data;
  final InlineSpan? textSpan;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  const BaseText(
    this.data, {
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  })  : assert(
          data != null,
          'A non-null String must be provided to a Text widget.',
        ),
        textSpan = null,
        super(key: key);

  const BaseText.rich(
    this.textSpan, {
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  })  : assert(
          textSpan != null,
          'A non-null TextSpan must be provided to a Text.rich widget.',
        ),
        data = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null && textSpan != null) {
      return Text.rich(
        textSpan!,
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
      );
    }
    return Text(
      data!,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
    );
  }
}

class BaseInkWell extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final double borderRadius;
  final Decoration? decoration;
  final Widget child;
  final VoidCallback? onPressed;

  BaseInkWell(
      {this.margin = EdgeInsets.zero,
      this.padding = EdgeInsets.zero,
      this.color,
      this.borderRadius = 0,
      this.decoration,
      required this.child,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: margin,
        decoration: decoration,
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).highlightColor;
                }
                return color;
              },
            ),
          ),
          child: child,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class BaseButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final VoidCallback? onPressed;

  BaseButton({this.padding, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding,
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
      this.padding,
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
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title!);
    }
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: onPressed != null ? gradient : disableGradient,
        boxShadow: boxShadow,
      ),
      child: Container(
        width: width,
        height: height,
        child: TextButton(
          style: ButtonStyle(
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
          child: Center(
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children),
            ),
          ),
          onPressed: onPressed,
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
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon!);
      children.add(SizedBox(width: 10));
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
            ? (color ?? Theme.of(context).primaryColor)
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
        child: Center(
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children),
          ),
        ),
        onPressed: onPressed,
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
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon!);
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title!);
    }
    return BaseButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            adaptDp(borderRadius),
          ),
          border:
              Border.all(color: borderColor ?? Theme.of(context).primaryColor),
          boxShadow: boxShadow,
        ),
        child: Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class BaseTextField extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
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
      this.padding,
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
      padding: padding,
      height: height ?? adaptDp(40),
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(borderRadius ?? adaptDp(5)),
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: CupertinoTextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          obscureText: obscureText,
          autofocus: false,
          focusNode: focusNode,
          cursorColor: Theme.of(context).primaryColor,
          style: style ??
              TextStyle(
                fontSize: adaptDp(14),
                color: colorWithHex3,
                textBaseline: TextBaseline.alphabetic,
              ),
          clearButtonMode:
              readOnly ? OverlayVisibilityMode.never : clearButtonMode,
          keyboardType: keyboardType,
          textAlign: textAlign,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          placeholder: placeholder,
          placeholderStyle: placeholderStyle ??
              TextStyle(
                fontSize: adaptDp(14),
                color: (readOnly && placeholder.isEmptyOrNull)
                    ? colorWithHex3
                    : Color(0xFFC1C0C8),
                textBaseline: TextBaseline.alphabetic,
              ),
          prefix: prefix,
          suffix: suffix,
          decoration: decoration,
          maxLength: maxLength,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
        ),
      ),
    );
  }
}

Widget baseDefaultGeneralAlertDialogTitle = BaseText('提示');

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
      content: Container(margin: EdgeInsets.only(top: 10), child: content),
      actions: actions,
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
    this.title = const BaseText('提示'),
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
  bool barrierDismissible = false,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(
      context: context,
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

  final Widget child;

  const BaseActionSheetAction({
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: onPressed,
      child: child,
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
    );
  }
}

Future<T?> showBaseModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showCupertinoModalPopup(context: context, builder: builder);
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
      height: thickness ?? 0.5,
      color: color ?? colorWithDivider,
    );
  }
}
