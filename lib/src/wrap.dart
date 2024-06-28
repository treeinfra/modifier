import 'package:flutter/widgets.dart';

/// An encapsulation of [Builder], also used as an alias.
Widget builder(Widget Function(BuildContext context) builder) =>
    Builder(builder: builder);

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
  Widget ensureMedia(BuildContext context) {
    final contextMedia = MediaQuery.maybeOf(context);
    return contextMedia == null
        ? media(MediaQueryData.fromView(View.of(context)))
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
