import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';

void main() {
  testText();
}

void testText() {
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
