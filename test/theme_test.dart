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
        'platform: ${platformBrightness.name}'.asText,
        'brightness: ${context.findAndTrust<Brightness>().name}'.asText,
        'mode: ${context.findAndTrust<ThemeMode>().name}'.asText,
      ].asColumn;
    })
        .center
        .theme(light: light, dark: dark)
        .builder((context, child) => child.ensureDirection(context))
        .builder((context, child) => child.ensureMedia(context))
        .pump(t);

    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pump();
    expect(find.text('platform: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('brightness: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.system.name}'), findsOneWidget);

    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await t.pump();
    expect(find.text('platform: ${Brightness.dark.name}'), findsOneWidget);
    expect(find.text('brightness: ${Brightness.dark.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.system.name}'), findsOneWidget);
  });

  testWidgets('change theme mode', (t) async {
    await builder((context) {
      final theme = context.findAndTrust<CustomizedTheme>();
      final platformBrightness = MediaQuery.of(context).platformBrightness;
      void updateThemeMode(ThemeMode mode) =>
          context.updateAndCheck<ThemeMode>((_) => mode);

      return [
        'platform: ${platformBrightness.name}'.asText,
        'brightness: ${context.findAndTrust<Brightness>().name}'.asText,
        'mode: ${context.findAndTrust<ThemeMode>().name}'.asText,
        'background: ${theme.background.hex}'.asText,
        'foreground: ${theme.foreground.hex}'.asText,
        'to system'.asText.on(tap: () => updateThemeMode(ThemeMode.system)),
        'to light'.asText.on(tap: () => updateThemeMode(ThemeMode.light)),
        'to dark'.asText.on(tap: () => updateThemeMode(ThemeMode.dark)),
      ].asColumn;
    })
        .center
        .theme(light: light, dark: dark)
        .builder((context, child) => child.ensureDirection(context))
        .builder((context, child) => child.ensureMedia(context))
        .pump(t);

    t.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pump();
    expect(find.text('platform: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('brightness: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.system.name}'), findsOneWidget);
    expect(find.text('background: ${light.background.hex}'), findsOneWidget);
    expect(find.text('foreground: ${light.foreground.hex}'), findsOneWidget);

    await t.tap(find.text('to dark'));
    await t.pump();
    expect(find.text('platform: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('brightness: ${Brightness.dark.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.dark.name}'), findsOneWidget);
    expect(find.text('background: ${dark.background.hex}'), findsOneWidget);
    expect(find.text('foreground: ${dark.foreground.hex}'), findsOneWidget);

    await t.tap(find.text('to light'));
    await t.pump();
    expect(find.text('platform: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('brightness: ${Brightness.light.name}'), findsOneWidget);
    expect(find.text('mode: ${ThemeMode.light.name}'), findsOneWidget);
    expect(find.text('background: ${light.background.hex}'), findsOneWidget);
    expect(find.text('foreground: ${light.foreground.hex}'), findsOneWidget);
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
