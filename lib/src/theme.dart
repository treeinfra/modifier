import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'inherit.dart';
import 'wrap.dart';

/// All handled theme data should have basic properties defined in this mixin.
///
/// The [foreground] and [background] are elementary components of a theme,
/// without such parameters, the theme will be useless.
/// So that they are required.
///
/// It's recommended to use a final parameter rather than a getter.
/// It is defined as a getter here because of the limit of Dart syntax.
/// For example:
///
/// ```dart
/// class Theme with ThemeMixin {
///   const Theme({
///     required this.background,
///     required this.foreground,
///   })
///
///   @override
///   final Color background;
///
///   @override
///   final Color foreground;
/// }
/// ```
mixin ThemeMixin {
  /// Default background of the theme, see [ThemeMixin].
  Color get background;

  /// Default foreground, text and icon color, of the theme, see [ThemeMixin].
  Color get foreground;
}

/// Same as the `ThemeMode` in the `material` package.
/// Code it here to avoid unnecessary calling of material library.
enum ThemeMode { system, light, dark }

extension WrapTheme on Widget {
  /// Wrap a [ThemeHandler] around current widget.
  ///
  /// The [dark] theme is optional, if not provided,
  /// it will be the same as the [light] theme.
  /// There's no strategy to improve performance by inherit
  /// [light] theme directly when there's no [dark] theme,
  /// because even if the [dark] theme is not provided,
  /// it might be modifier by its descendants.
  Widget theme<T extends ThemeMixin>({
    required T light,
    T? dark,
    ThemeMode mode = ThemeMode.system,
  }) =>
      ThemeHandler(
        light: light,
        dark: dark ?? light,
        mode: mode,
        child: this,
      );
}

/// Handle a [ThemeMixin] and the [ThemeMode],
/// and it will also provide the [Brightness] of current theme.
/// And you can also modify current [ThemeMixin] and [ThemeMode] from
/// its descendants in the widget tree via the context.
class ThemeHandler<T extends ThemeMixin> extends StatefulWidget {
  const ThemeHandler({
    super.key,
    required this.light,
    required this.dark,
    this.mode = ThemeMode.system,
    required this.child,
  });

  final T light;
  final T dark;
  final ThemeMode mode;
  final Widget child;

  @override
  State<ThemeHandler<T>> createState() => _ThemeHandlerState<T>();
}

class _ThemeHandlerState<T extends ThemeMixin> extends State<ThemeHandler<T>> {
  late T _light = widget.light;
  late T _dark = widget.dark;
  late ThemeMode _mode = widget.mode;

  /// Compute what [Brightness] should be now according to [_mode]
  /// and [MediaQueryData.platformBrightness] of current platform.
  Brightness get adaptedBrightness => _mode == ThemeMode.system
      ? MediaQuery.of(context).platformBrightness
      : _mode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light;

  @override
  void didUpdateWidget(covariant ThemeHandler<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mode != widget.mode) setState(() => _mode = widget.mode);
    if (_dark != widget.dark) setState(() => _dark = widget.dark);
    if (_light != widget.light) setState(() => _light = widget.light);
  }

  void updateMode(ThemeMode mode) {
    if (_mode != mode) setState(() => _mode = mode);
  }

  void updateCurrentTheme(T theme) {
    switch (adaptedBrightness) {
      case Brightness.dark:
        if (_dark != theme) setState(() => _dark = theme);
      case Brightness.light:
        if (_light != theme) setState(() => _light = theme);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = adaptedBrightness;
    final theme = adaptedBrightness == Brightness.dark ? _dark : _light;
    return widget.child
        .foreground(context, theme.foreground)
        .background(theme.background)
        .inherit(brightness)
        .inherit(theme)
        .inherit(_mode)
        .inherit(InheritHandlerAPI(updateMode))
        .inherit(InheritHandlerAPI(updateCurrentTheme));
  }
}
