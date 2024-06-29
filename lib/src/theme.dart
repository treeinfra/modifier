import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'inherit.dart';
import 'wrap.dart';

mixin Theme {
  /// Default background of the theme.
  /// It's recommended to use a final parameter rather than a getter.
  Color get background;

  /// Default foreground, text and icon color, of the theme.
  /// It's recommended to use a final parameter rather than a getter.
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
  Widget theme<T extends Theme>({
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

class ThemeHandler<T extends Theme> extends StatefulWidget {
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

class _ThemeHandlerState<T extends Theme> extends State<ThemeHandler<T>> {
  late T _light = widget.light;
  late T _dark = widget.dark;
  late ThemeMode _mode = widget.mode;

  late T _theme = theme;
  late Brightness _brightness = brightness;

  /// Compute what theme ([T]) should be now according to [_brightness].
  /// It's not recommended to call it directly, consider using [_theme]
  /// to reduce unnecessary computations.
  T get theme => _brightness == Brightness.dark ? _dark : _light;

  /// Compute what [Brightness] should be now according to [_mode]
  /// and [MediaQueryData.platformBrightness] of current platform.
  /// It's not recommended to call it directly, consider using [_brightness]
  /// to reduce unnecessary computations.
  Brightness get brightness => _mode == ThemeMode.system
      ? MediaQuery.of(context).platformBrightness
      : _mode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light;

  @override
  void didUpdateWidget(covariant ThemeHandler<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    var needSetState = false;
    if (widget.mode != _mode) needSetState = _preUpdateMode(widget.mode);

    if (widget.light != _light) {
      _light = widget.light;
      if (_brightness == Brightness.light) needSetState = true;
    }
    if (widget.dark != _dark) {
      _dark = widget.dark;
      if (_brightness == Brightness.dark) needSetState = true;
    }

    if (needSetState) setState(() {});
  }

  void updateMode(ThemeMode Function(ThemeMode raw) updater) {
    if (_preUpdateMode(updater(_mode))) setState(() {});
  }

  bool _preUpdateMode(ThemeMode mode) {
    if (mode == _mode) return false;
    _mode = mode;
    final brightness = this.brightness;
    if (_brightness != brightness) {
      _brightness = brightness;
      _theme = theme;
    }
    return true;
  }

  void updateCurrentTheme(T Function(T raw) updater) {
    if (_preUpdateCurrentTheme(updater(_theme))) setState(() {});
  }

  bool _preUpdateCurrentTheme(T theme) {
    if (_theme == theme) return false;
    switch (_brightness) {
      case Brightness.dark:
        _dark = theme;
      case Brightness.light:
        _light = theme;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => widget.child
      .foreground(context, _theme.foreground)
      .background(_theme.background)
      .inherit(_brightness)
      .inherit(_theme)
      .inherit(_mode)
      .inherit(InheritHandlerAPI(updateMode))
      .inherit(InheritHandlerAPI(updateCurrentTheme));
}
