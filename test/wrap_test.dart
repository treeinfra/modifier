import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';
import 'package:modifier_test/modifier_test.dart';

void main() {
  testWidgets('multi nested builder', (t) async {
    /// Encapsulation for update platform brightness,
    /// to make testing code conciser.
    Widget updateBrightness(
      BuildContext context,
      Widget child,
      Brightness brightness,
    ) {
      return child.updateMedia(context, (raw) {
        return raw.copyWith(platformBrightness: brightness);
      });
    }

    await builder((context) =>
            'brightness: ${MediaQuery.of(context).platformBrightness.name}'
                .asText
                .center)
        .builder((c, child) => updateBrightness(c, child, Brightness.dark))
        .builder((c, child) => updateBrightness(c, child, Brightness.light))
        .builder((c, child) => child.ensureDirection(c).ensureMedia(c))
        .pump(t);

    expect(find.text('brightness: dark'), findsOneWidget);
  });

  group('ensure text display', () {
    testWidgets('enable text', (t) async {
      await builder((context) => const Text('validation')
          .ensureDirection(context)
          .ensureMedia(context)).pump(t);
      expect(find.text('validation'), findsOneWidget);
    });

    testWidgets('wrap text', (t) async {
      await builder((context) => 'convert string into text'
          .asText
          .ensureDirection(context)
          .ensureMedia(context)).pump(t);
      expect(find.text('convert string into text'), findsOneWidget);
    });
  });
}
