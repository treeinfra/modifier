import 'package:color_chart/color_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';
import 'package:modifier_test/modifier_test.dart';

void main() {
  const light = CustomizedTheme.light();
  const dark = CustomizedTheme.dark();

  testWidgets('platform media', (t) async {
    await builder((context) =>
            'brightness: ${MediaQuery.of(context).platformBrightness.name}'
                .asText
                .center)
        .builder((context, child) => child
            .ensureDirection(context) // line break.
            .ensureMedia(context))
        .pump(t);

    // Light.
    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pump();
    expect(find.text('brightness: ${Brightness.light.name}'), findsOneWidget);

    // Dark.
    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await t.pump();
    expect(find.text('brightness: ${Brightness.dark.name}'), findsOneWidget);
  });

  testWidgets('brightness adapt', (t) async {
    await builder((context) {
      final platformBrightness = MediaQuery.of(context).platformBrightness;
      return [
        'brightness: ${context.findAndTrust<Brightness>().name}'.asText,
        'mode: ${context.findAndTrust<ThemeMode>().name}'.asText,
        'platform: ${platformBrightness.name}'.asText,
      ].asColumn;
    })
        .center
        .builder((context, child) => child
            .theme(light: light, dark: dark)
            .ensureDirection(context)
            .ensureMedia(context))
        .pump(t);

    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pump();
    expect(find.text('brightness: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.system.name}'), findsOneWidget);
    expect(find.text('platform: ${Brightness.light.name}'), findsOneWidget);

    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await t.pump();
    expect(find.text('brightness: ${Brightness.dark.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.system.name}'), findsOneWidget);
    expect(find.text('platform: ${Brightness.dark.name}'), findsOneWidget);
  });
}

class CustomizedTheme with Theme {
  const CustomizedTheme.light({
    this.background = MonoColors.snow,
    this.foreground = MonoColors.coal,
  });

  const CustomizedTheme.dark({
    this.background = MonoColors.night,
    this.foreground = MonoColors.lunar,
  });

  @override
  final Color background;

  @override
  final Color foreground;
}
