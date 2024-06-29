import 'package:color_chart/color_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';
import 'package:modifier_test/modifier_test.dart';

void main() {
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

  testWidgets('theme adapt', (t) async {
    const light = CustomizedTheme.light();
    expect(light, light);
    const dark = CustomizedTheme.dark();
    expect(dark, dark);
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
