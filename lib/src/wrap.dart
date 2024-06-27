import 'package:flutter/widgets.dart';

/// An encapsulation of [Builder], also used as an alias.
Widget builder(Widget Function(BuildContext context) builder) =>
    Builder(builder: builder);

extension WrapMedia on Widget {
  /// Chain style syntax sugar of wrapping [MediaQuery].
  Widget wrapMedia(MediaQueryData data) => MediaQuery(data: data, child: this);

  /// Ensure that the inner widget can get [MediaQueryData] from the context.
  /// If there's no available [MediaQueryData], it will get from the [View].
  Widget ensureMedia(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    return media == null
        ? wrapMedia(MediaQueryData.fromView(View.of(context)))
        : this;
  }
}

extension WrapDirection on Widget {
  /// Chain style sugar of wrapping [Directionality].
  Widget wrapDirection(TextDirection direction) =>
      Directionality(textDirection: direction, child: this);

  /// Ensure that the inner widget can get [TextDirection] from the context.
  /// You can specify the [defaultValue]
  /// if you prefer [TextDirection.rtl] as default.
  Widget ensureDirection(
    BuildContext context, {
    TextDirection defaultValue = TextDirection.ltr,
  }) {
    final direction = Directionality.maybeOf(context);
    return direction == null ? wrapDirection(defaultValue) : this;
  }
}

extension WrapAlign on Widget {
  /// Wrap current widget with [Center],
  /// which will display current widget in the center of the parent.
  Widget get center => Center(child: this);
}
