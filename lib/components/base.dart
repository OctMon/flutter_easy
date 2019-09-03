import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'package:oktoast/oktoast.dart';

import '../utils/global_util.dart';
import '../utils/color_util.dart';

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

class BaseApp extends StatelessWidget {
  final Widget home;
  final RouteFactory onGenerateRoute;

  BaseApp({this.home, this.onGenerateRoute});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          primarySwatch: Colors.grey,
          splashColor: Colors.transparent,
        ),
        home: home,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}

Widget _buildLeading({BuildContext context, Widget leading, Color tintColor}) {
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
                child: Icon(Icons.arrow_back_ios, color: tintColor),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              );
      } else {
        _leading = IconButton(
          icon: useCloseButton
              ? const Icon(Icons.close)
              : Icon(Icons.arrow_back_ios, color: tintColor),
          color: tintColor ?? colorWithAppBarTint,
          onPressed: () => Navigator.maybePop(context),
        );
      }
    }
  }
  return _leading;
}

class BaseAppBar extends PlatformWidget<AppBar, PreferredSize> {
  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final double elevation;
  final Color tintColor;
  final Color backgroundColor;
  final Brightness brightness;

  BaseAppBar({
    this.title,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.brightness = Brightness.light,
  });

  @override
  AppBar buildMaterialWidget(BuildContext context) {
    return AppBar(
      leading: _buildLeading(
          context: context,
          leading: leading,
          tintColor: tintColor ?? colorWithAppBarTint),
      title: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                fontSize: 17,
                color: colorWithAppBarTint,
                fontWeight: FontWeight.w500,
              ),
              child: title,
            )
          : null,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorWithAppBarBackground,
      brightness: brightness,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    Widget leading = _buildLeading(
        context: context,
        leading: this.leading,
        tintColor: tintColor ?? colorWithAppBarTint);

    return PreferredSize(
      preferredSize: Size.fromHeight(44),
      child: AppBar(
        leading: leading,
        title: title != null
            ? DefaultTextStyle(
                style: TextStyle(
                  fontSize: 17,
                  color: colorWithAppBarTint,
                  fontWeight: FontWeight.w500,
                ),
                child: title,
              )
            : null,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor ?? colorWithAppBarBackground,
        brightness: brightness,
      ),
    );
  }
}

class BaseSliverAppBar extends PlatformWidget<SliverAppBar, PreferredSize> {
  final Widget title;
  final Widget leading;
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
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.brightness = Brightness.light,
    this.centerTitle,
    this.floating = false,
    this.pinned = false,
    this.expandedHeight,
    this.flexibleSpace,
  });

  @override
  SliverAppBar buildMaterialWidget(BuildContext context) {
    return SliverAppBar(
      leading: _buildLeading(
          context: context,
          leading: this.leading,
          tintColor: tintColor ?? colorWithAppBarTint),
      title: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                fontSize: 17,
                color: colorWithAppBarTint,
                fontWeight: FontWeight.w500,
              ),
              child: title,
            )
          : null,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorWithAppBarBackground,
      brightness: brightness,
      pinned: pinned,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(44),
      child: SliverAppBar(
        leading: _buildLeading(
            context: context,
            leading: this.leading,
            tintColor: tintColor ?? colorWithAppBarTint),
        title: title != null
            ? DefaultTextStyle(
                style: TextStyle(
                  fontSize: 17,
                  color: colorWithAppBarTint,
                  fontWeight: FontWeight.w500,
                ),
                child: title,
              )
            : null,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor ?? colorWithAppBarBackground,
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
          gradient: onPressed != null ? gradient : disableGradient,
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
  final EdgeInsetsGeometry contentPadding;
  final TextEditingController controller;
  final bool obscureText;
  final int maxLength;
  final String hintText;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final Widget suffixIcon;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const BaseTextField(
      {Key key,
      this.contentPadding,
      this.controller,
      this.obscureText = false,
      this.maxLength,
      this.hintText,
      this.focusNode,
      this.keyboardType,
      this.textInputAction,
      this.inputFormatters,
      this.suffixIcon,
      this.onChanged,
      this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color underlineBorderColor = Colors.transparent;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        autofocus: false,
        focusNode: focusNode,
        cursorColor: colorWithTint,
        style: TextStyle(
          color: colorWithHex3,
          fontSize: 14,
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: colorWithHex9,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: underlineBorderColor,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: underlineBorderColor,
            ),
          ),
        ),
        maxLength: maxLength,
        buildCounter: ((
          BuildContext context, {
          // 当前字数长度
          @required int currentLength,
          // 最大字数长度
          @required int maxLength,
          // 当前输入框是否有焦点
          @required bool isFocused,
        }) {
          // 自定义的显示格式
          return null;
        }),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class BaseAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const BaseAlertDialog({
    Key key,
    this.title = const BaseText('温馨提示'),
    this.content,
    this.actions = const <Widget>[],
  })  : assert(actions != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      key: key,
      title: title,
      content: content,
      actions: actions,
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

Future<T> showBaseDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = false,
  WidgetBuilder builder,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder);
}
