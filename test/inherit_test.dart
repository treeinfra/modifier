import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';

void main() {
  testFindAndTrust();
}

void testFindAndTrust() {
  group('find and trust', () {
    // It's strongly not recommended to code like that,
    // because there might many inherited data with the String type
    // in that case, and it will only return the closest one,
    // the they might shadow each other.
    // Please refer to the test below.
    testWidgets('find and trust', (t) async {
      const message = 'it works';
      await t.pumpWidget(
        builder((context) => Text(context.findAndTrust<String>())
            .center
            .ensureDirection(context)
            .ensureMedia(context)).inherit(message),
      );
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('find and trust typed', (t) async {
      const message = 'it works';
      await t.pumpWidget(
        builder((context) =>
                Text(context.findAndTrust<MessageExample>().message)
                    .center
                    .ensureDirection(context)
                    .ensureMedia(context))
            .inherit(const MessageExample(message: message)),
      );
    });
  });
}

/// Wrapping a single text message for demonstration.
/// See the code inside [testFindAndTrust].
class MessageExample {
  const MessageExample({required this.message});

  final String message;
}
