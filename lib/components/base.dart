import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'package:oktoast/oktoast.dart';

import '../utils/global_util.dart';
import '../utils/color_util.dart';
import '../utils/adapt_util.dart';
import '../utils/json_util.dart';
import '../utils/package_info_util.dart';

export 'base_refresh.dart';

abstract class BaseState<T> {
  String get message;

  set message(String message);

  T get data;

  set data(T data);
}

abstract class BaseRefreshState<C, T> extends BaseState<T> {
  C get refreshController;

  set refreshController(C controller);

  int get page;

  set page(int page);
}

class BaseKeyValue {
  String key;
  String value;
  dynamic extend;

  BaseKeyValue({this.key, this.value, this.extend});

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

createEasyApp(
    {String appName,
    String appPackageName,
    String appVersion,
    String appBuildNumber,
    bool usePackage = true,
    sharedPreferencesWebInstance,
    Widget initView,
    Future<void> Function() initCallback,
    @required void Function() completionCallback}) {
  void callback() {
    if (initCallback != null) {
      initCallback().then((_) {
        completionCallback();
      });
    } else {
      completionCallback();
    }
  }

  runApp(initView ??
      BaseApp(title: appName, home: Scaffold(backgroundColor: Colors.white)));

  Future.wait([
    PackageInfoUtil.init(
        appName: appName,
        appPackageName: appPackageName,
        appVersion: appVersion,
        appBuildNumber: appBuildNumber,
        usePackage: usePackage),
    SharedPreferencesUtil.init(
        sharedPreferencesWebInstance: sharedPreferencesWebInstance),
  ]).then((e) {
    log("init:", e);
    callback();
  });
}

/// 默认返回按钮的样式
/// initAppBarLeading = Icons.arrow_back;
/// or
//  initAppBarLeading = assetsImagesPath("icon_arrow_back");
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
  final Widget home;
  final RouteFactory onGenerateRoute;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  BaseApp({
    this.title = "",
    this.home,
    this.onGenerateRoute,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  });

  @override
  _BaseAppState createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: widget.title,
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          primarySwatch: Colors.grey,
          splashColor: Colors.transparent,
        ),
        home: widget.home,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: widget.onGenerateRoute,
        localizationsDelegates: widget.localizationsDelegates,
        supportedLocales: widget.supportedLocales,
      ),
    );
  }
}

Widget _buildLeading(
    {BuildContext context,
    Widget leading,
    VoidCallback leadingOnPressed,
    Color tintColor}) {
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

  final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

  final bool canPop = parentRoute?.canPop ?? false;
  final bool useCloseButton =
      parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

  Widget _leading = leading;
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
          color: tintColor ?? colorWithAppBarTint,
          onPressed: leadingOnPressed ?? () => Navigator.maybePop(context),
        );
      }
    }
  }
  return _leading;
}

class BaseAppBar extends PlatformWidget<AppBar, PreferredSize> {
  final bool automaticallyImplyLeading;
  final Widget title;
  final Widget leading;
  final VoidCallback leadingOnPressed;
  final List<Widget> actions;
  final double elevation;
  final Color tintColor;
  final Color backgroundColor;
  final Brightness brightness;

  BaseAppBar({
    this.automaticallyImplyLeading = true,
    this.title,
    this.leading,
    this.leadingOnPressed,
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.brightness,
  });

  @override
  AppBar buildMaterialWidget(BuildContext context) {
    Brightness brightness = this.brightness ?? colorWithBrightness;
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading
          ? _buildLeading(
              context: context,
              leading: leading,
              leadingOnPressed: leadingOnPressed,
              tintColor: tintColor ??
                  (brightness == Brightness.light
                      ? colorWithAppBarTint
                      : colorWithAppBarDartTint))
          : null,
      title: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                fontSize: 17,
                color: tintColor ??
                    (brightness == Brightness.light
                        ? colorWithAppBarTint
                        : colorWithAppBarDartTint),
                fontWeight: FontWeight.w500,
              ),
              child: title,
            )
          : null,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor ??
          (brightness == Brightness.light
              ? colorWithAppBarBackground
              : colorWithAppBarDarkBackground),
      brightness: brightness,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    Brightness brightness = this.brightness ?? colorWithBrightness;
    return PreferredSize(
      preferredSize: Size.fromHeight(screenToolbarHeightDp),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: automaticallyImplyLeading
            ? _buildLeading(
                context: context,
                leading: leading,
                leadingOnPressed: leadingOnPressed,
                tintColor: tintColor ??
                    (brightness == Brightness.light
                        ? colorWithAppBarTint
                        : colorWithAppBarDartTint))
            : null,
        title: title != null
            ? DefaultTextStyle(
                style: TextStyle(
                  fontSize: 17,
                  color: tintColor ??
                      (brightness == Brightness.light
                          ? colorWithAppBarTint
                          : colorWithAppBarDartTint),
                  fontWeight: FontWeight.w500,
                ),
                child: title,
              )
            : null,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor ??
            (brightness == Brightness.light
                ? colorWithAppBarBackground
                : colorWithAppBarDarkBackground),
        brightness: brightness,
      ),
    );
  }
}

class BaseSliverAppBar extends PlatformWidget<SliverAppBar, PreferredSize> {
  final Widget title;
  final Widget leading;
  final VoidCallback leadingOnPressed;
  final List<Widget> actions;
  final double elevation;
  final Color tintColor;
  final Color backgroundColor;
  final Brightness brightness;
  final bool centerTitle;
  final bool floating;
  final bool pinned;
  final double expandedHeight;
  final Widget flexibleSpace;

  BaseSliverAppBar({
    this.title,
    this.leading,
    this.leadingOnPressed,
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.brightness,
    this.centerTitle,
    this.floating = false,
    this.pinned = false,
    this.expandedHeight,
    this.flexibleSpace,
  });

  @override
  SliverAppBar buildMaterialWidget(BuildContext context) {
    Brightness brightness = this.brightness ?? colorWithBrightness;
    return SliverAppBar(
      leading: _buildLeading(
          context: context,
          leading: this.leading,
          leadingOnPressed: leadingOnPressed,
          tintColor: tintColor ??
              (brightness == Brightness.light
                  ? colorWithAppBarTint
                  : colorWithAppBarDartTint)),
      title: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                fontSize: 17,
                color: tintColor ??
                    (brightness == Brightness.light
                        ? colorWithAppBarTint
                        : colorWithAppBarDartTint),
                fontWeight: FontWeight.w500,
              ),
              child: title,
            )
          : null,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor ??
          (brightness == Brightness.light
              ? colorWithAppBarBackground
              : colorWithAppBarDarkBackground),
      brightness: brightness,
      pinned: pinned,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    Brightness brightness = this.brightness ?? colorWithBrightness;
    return PreferredSize(
      preferredSize: Size.fromHeight(screenToolbarHeightDp),
      child: SliverAppBar(
        leading: _buildLeading(
            context: context,
            leading: this.leading,
            leadingOnPressed: leadingOnPressed,
            tintColor: tintColor ??
                (brightness == Brightness.light
                    ? colorWithAppBarTint
                    : colorWithAppBarDartTint)),
        title: title != null
            ? DefaultTextStyle(
                style: TextStyle(
                  fontSize: 17,
                  color: tintColor ??
                      (brightness == Brightness.light
                          ? colorWithAppBarTint
                          : colorWithAppBarDartTint),
                  fontWeight: FontWeight.w500,
                ),
                child: title,
              )
            : null,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor ??
            (brightness == Brightness.light
                ? colorWithAppBarBackground
                : colorWithAppBarDarkBackground),
        brightness: brightness,
        centerTitle: centerTitle,
        floating: floating,
        pinned: pinned,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace,
      ),
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final BaseAppBar appBar;
  final Widget body;
  final Color backgroundColor;
  final Widget bottomNavigationBar;

  BaseScaffold({
    this.appBar,
    this.body,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    if (appBar == null) {
      return Scaffold(
        body: body,
        backgroundColor: backgroundColor ?? colorWithScaffoldBackground,
        bottomNavigationBar: bottomNavigationBar,
      );
    }
    return Scaffold(
      appBar: isIOS
          ? appBar.buildCupertinoWidget(context)
          : appBar.buildMaterialWidget(context),
      body: body,
      backgroundColor: backgroundColor ?? colorWithScaffoldBackground,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BaseText extends StatelessWidget {
  final String data;
  final InlineSpan textSpan;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final TextWidthBasis textWidthBasis;

  const BaseText(
    this.data, {
    Key key,
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
    Key key,
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
        textSpan,
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
      data,
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

class BaseTitle extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final Color color;
  final int maxLines;
  final double height;
  final TextOverflow overflow;

  const BaseTitle(this.title,
      {Key key,
      this.textAlign,
      this.fontSize = 14,
      this.fontWeight,
      this.fontFamily,
      this.color,
      this.maxLines,
      this.height,
      this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseText(
      title ?? 'text is null',
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? colorWithTitle,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        height: height,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class BaseInkWell extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double borderRadius;
  final Decoration decoration;
  @required
  final Widget child;
  @required
  final VoidCallback onPressed;

  BaseInkWell(
      {this.margin = EdgeInsets.zero,
      this.padding = EdgeInsets.zero,
      this.color,
      this.borderRadius = 0,
      this.decoration,
      this.child,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: margin,
        decoration: decoration,
        child: FlatButton(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: color,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 15,
              color: colorWithHex3,
              fontWeight: FontWeight.w400,
            ),
            child: child,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class BaseButton extends StatelessWidget {
  @required
  final EdgeInsetsGeometry padding;
  @required
  final Widget child;
  @required
  final VoidCallback onPressed;

  BaseButton({this.padding, this.child, this.onPressed});

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
  final EdgeInsetsGeometry padding;
  final Widget icon;
  final Widget title;
  final double borderRadius;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final Gradient disableGradient;
  final VoidCallback onPressed;

  const BaseGradientButton(
      {Key key,
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
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon);
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title);
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
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          splashColor: Colors.transparent,
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
  final Widget icon;
  final Widget title;
  final double borderRadius;
  final Color color;
  final Color disableColor;
  final VoidCallback onPressed;

  const BaseBackgroundButton(
      {Key key,
      this.width = double.infinity,
      this.height = 44,
      this.padding,
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
      children.add(icon);
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title);
    }
    return Container(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: onPressed != null
              ? (color ?? colorWithTint)
              : (disableColor ?? Colors.grey),
        ),
        child: Container(
          width: width,
          height: height,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            splashColor: Colors.transparent,
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
      ),
    );
  }
}

class BaseOutlineButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget icon;
  final Widget title;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final Color highlightedBorderColor;
  final Color disabledBorderColor;
  final VoidCallback onPressed;

  const BaseOutlineButton(
      {Key key,
      this.width = double.infinity,
      this.height = 44,
      this.padding,
      this.icon,
      this.title,
      this.borderWidth = 1,
      this.borderRadius = 22,
      this.borderColor,
      this.highlightedBorderColor,
      this.disabledBorderColor,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon);
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title);
    }
    return Container(
      padding: padding,
      child: Container(
        width: width,
        height: height,
        child: OutlineButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          borderSide: BorderSide(
            color: borderColor ?? colorWithTint,
            width: borderWidth,
          ),
          highlightedBorderColor: highlightedBorderColor,
          disabledBorderColor: disabledBorderColor,
          splashColor: Colors.transparent,
          child: Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class BaseTextField extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final int maxLines;
  final TextEditingController controller;
  final TextStyle style;
  final TextStyle placeholderStyle;
  final bool readOnly;
  final bool obscureText;
  final int maxLength;
  final String placeholder;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final OverlayVisibilityMode clearButtonMode;
  final List<TextInputFormatter> inputFormatters;
  final Widget prefix;
  final Widget suffix;
  final BoxDecoration decoration;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final GestureTapCallback onTap;

  const BaseTextField(
      {Key key,
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
          cursorColor: colorWithTint,
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
                color: (readOnly && placeholder.isEmpty)
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
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const BaseGeneralAlertDialog(
      {Key key, this.title, this.content, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      key: key,
      title: title ?? baseDefaultGeneralAlertDialogTitle,
      content: DefaultTextStyle(
        style: TextStyle(fontSize: adaptDp(15), color: colorWithHex3),
        child: Container(margin: EdgeInsets.only(top: 10), child: content),
      ),
      actions: actions,
    );
  }
}

class BaseAlertDialog extends Dialog {
  final bool barrierDismissible;
  final EdgeInsets margin;
  final EdgeInsets titlePadding;
  final EdgeInsets contentPadding;
  final EdgeInsets actionPadding;
  final MainAxisAlignment actionsAxisAlignment;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const BaseAlertDialog({
    Key key,
    this.barrierDismissible = false,
    this.margin = const EdgeInsets.all(38.0),
    this.titlePadding = const EdgeInsets.fromLTRB(20.0, 34.0, 20.0, 20.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.actionPadding = const EdgeInsets.fromLTRB(20, 24, 20, 34),
    this.actionsAxisAlignment = MainAxisAlignment.spaceAround,
    this.title = const BaseText('提示'),
    this.content,
    this.actions = const <Widget>[],
  })  : assert(actions != null),
        super(key: key);

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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
    @required this.child,
  }) : assert(child != null);

  final VoidCallback onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final TextStyle textStyle;
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
Future<T> showBaseDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = false,
  @required WidgetBuilder builder,
}) {
  return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder);
}

class BaseActionSheet extends StatelessWidget {
  final Widget title;
  final Widget message;
  final List<Widget> actions;
  final Widget cancelButton;

  const BaseActionSheet({
    Key key,
    this.title,
    this.message,
    this.actions = const <Widget>[],
    this.cancelButton,
  })  : assert(
            actions != null ||
                title != null ||
                message != null ||
                cancelButton != null,
            'An action sheet must have a non-null value for at least one of the following arguments: '
            'actions, title, message, or cancelButton'),
        super(key: key);

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
    @required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    @required this.child,
  })  : assert(child != null),
        assert(onPressed != null);

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

Future<T> showBaseModalBottomSheet<T>({
  @required BuildContext context,
  WidgetBuilder builder,
}) {
  return showCupertinoModalPopup(context: context, builder: builder);
}
