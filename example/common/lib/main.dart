import 'package:color_chart/color_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:modifier/modifier.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return builder((context) {
      final platformBrightness = MediaQuery.of(context).platformBrightness;
      final brightness = context.findAndTrust<Brightness>();
      final theme = context.findAndTrust<Theme>();
      return [
        'Platform brightness: ${platformBrightness.name}'.asText,
        'Theme brightness: ${brightness.name}'.asText,
        'Foreground: ${theme.foreground.hex}'.asText,
        'Background: ${theme.background.hex}'.asText,
      ].asColumn;
    })
        .center
        .theme(light: const Theme.light(), dark: const Theme.dark())
        .ensureDirection(context)
        .ensureMedia(context);
  }
}

class Theme with ThemeMixin {
  const Theme.light({
    this.background = MonoColors.snow,
    this.foreground = MonoColors.ink,
  });

  const Theme.dark({
    this.background = MonoColors.night,
    this.foreground = MonoColors.lunar,
  });

  @override
  final Color background;

  @override
  final Color foreground;
}
