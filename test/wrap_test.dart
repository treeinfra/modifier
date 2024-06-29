import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';
import 'package:modifier_test/modifier_test.dart';

void main() {
  testText();
}

void testText() {
  testWidgets('builder', (t) async {
    Widget updateBrightness(
      BuildContext context,
      Widget child,
      Brightness brightness,
    ) =>
        child.updateMedia(
          context,
          (raw) => raw.copyWith(platformBrightness: brightness),
        );

    await builder(
      (context) {
        final brightness = MediaQuery.of(context).platformBrightness;
        return 'brightness: ${brightness.name}'.asText;
      },
    )
        .builder((c, child) => updateBrightness(c, child, Brightness.dark))
        .builder((c, child) => updateBrightness(c, child, Brightness.light))
        .builder(
          (context, child) => child.center
              .ensureDirection(context)
              .ensureMedia(context), // demo
        )
        .pump(t);

    expect(find.text('brightness: dark'), findsOneWidget);
  });

  group('text', () {
    testWidgets('enable text', (t) async {
      await t.pumpWidget(
        builder((context) => const Text('validation')
            .ensureDirection(context)
            .ensureMedia(context)),
      );
      expect(find.text('validation'), findsOneWidget);
    });

    testWidgets('wrap text', (t) async {
      await t.pumpWidget(
        builder((context) => 'convert string into text'
            .asText
            .ensureDirection(context)
            .ensureMedia(context)),
      );
      expect(find.text('convert string into text'), findsOneWidget);
    });
  });
}
