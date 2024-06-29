import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

/// An encapsulation of [Builder], also used as an alias.
Widget builder(Widget Function(BuildContext context) builder) =>
    Builder(builder: builder);

extension WrapBuilder on Widget {
  Widget builder(Widget Function(BuildContext context, Widget child) builder) =>
      Builder(builder: (context) => builder(context, this));
}

extension WrapTextWidget on String {
  /// Convert a string into text.
  ///
  /// It's a syntax sugar as shortcut of [Text].
  /// But it's strongly not recommended to use if you need better performance,
  /// because it will disable the `const` decoration over the [Text],
  /// that more steps will be done when rendering.
  Text get asText => Text(this);
}

extension WrapMedia on Widget {
  /// Chain style syntax sugar of wrapping [MediaQuery].
  Widget media(MediaQueryData data) => MediaQuery(data: data, child: this);

  /// Ensure that the inner widget can get [MediaQueryData] from the context.
  /// If there's no available [MediaQueryData], it will get from the [View].
  Widget ensureMedia(BuildContext context, {MediaQueryData? defaultValue}) {
    final contextMedia = MediaQuery.maybeOf(context);
    return contextMedia == null
        ? media(defaultValue ?? MediaQueryData.fromView(View.of(context)))
        : this;
  }
}

extension WrapDirection on Widget {
  /// Chain style sugar of wrapping [Directionality].
  Widget direction(TextDirection direction) =>
      Directionality(textDirection: direction, child: this);

  /// Ensure that the inner widget can get [TextDirection] from the context.
  /// You can specify the [defaultValue]
  /// if you prefer [TextDirection.rtl] as default.
  Widget ensureDirection(
    BuildContext context, {
    TextDirection defaultValue = TextDirection.ltr,
  }) {
    final contextDirection = Directionality.maybeOf(context);
    return contextDirection == null ? direction(defaultValue) : this;
  }
}

extension WrapAlign on Widget {
  /// Wrap current widget with [Center],
  /// which will display current widget in the center of the parent.
  Widget get center => Center(child: this);
}

extension WrapPadding on Widget {
  /// Wrap current widget with [Padding].
  /// And it's parameters are encapsulations for [EdgeInsets.only].
  Widget padding({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
        ),
        child: this,
      );

  /// Wrap current widget with [Padding].
  /// And it's parameters are encapsulations for [EdgeInsets.all].
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Wrap current widget with [Padding].
  /// And it's parameters are encapsulations for [EdgeInsets.symmetric].
  Widget paddingSymmetric({
    double vertical = 0,
    double horizontal = 0,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );
}

extension WrapColor on Widget {
  Widget background(Color color) => ColoredBox(color: color, child: this);

  Widget foreground(BuildContext context, Color color) =>
      textForeground(context, color).iconForeground(context, color);

  Widget textForeground(BuildContext context, Color color) {
    final font = DefaultTextStyle.of(context).style.copyWith(color: color);
    return DefaultTextStyle(style: font, child: this);
  }

  Widget iconForeground(BuildContext context, Color color) {
    final icon = IconTheme.of(context).copyWith(color: color);
    return IconTheme(data: icon, child: this);
  }
}

extension WrapList on List<Widget> {
  Widget get asColumn => Column(mainAxisSize: MainAxisSize.min, children: this);

  Widget get asRow => Row(mainAxisSize: MainAxisSize.min, children: this);

  Widget get asStack => Stack(children: this);
}

extension WrapGesture on Widget {
  Widget on({
    void Function()? tap,
    void Function()? doubleTap,
    void Function()? longPress,
  }) =>
      GestureDetector(
        onTap: tap,
        onDoubleTap: doubleTap,
        onLongPress: longPress,
        child: this,
      );
}
