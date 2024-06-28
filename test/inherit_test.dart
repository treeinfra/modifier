import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';

void main() {
  testFindAndTrust();
  testInheritHandler();
}

/// Wrapping a single text message for demonstration.
/// See the code inside [testFindAndTrust].
class MessageExample {
  const MessageExample({required this.message});

  final String message;
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

void testInheritHandler() {
  testWidgets('inherit handler', (t) async {
    await t.pumpWidget(builder((context) => builder((context) {
          final message = context.findAndTrust<String>();
          void update() => context.update<String>((message) => '$message.');
          return [
            'message: $message'.asText,
            'append dot'.asText.on(tap: update)
          ].asColumn;
        })
            .center
            .handle('message')
            .ensureDirection(context)
            .ensureMedia(context)));
    expect(find.text('message: message'), findsOneWidget);
    expect(find.text('append dot'), findsOneWidget);
    await t.tap(find.text('append dot'));
    await t.pump();
    expect(find.text('message: message.'), findsOneWidget);
  });

  testWidgets('inherit handler outer modify', (t) async {
    await t.pumpWidget(builder((context) => builder(
          (context) => builder((context) {
            final outer = context.findAndTrust<String>();
            final inner = context.findAndTrust<MessageExample>();
            return [
              'outer message: $outer'.asText,
              'inner message: ${inner.message}'.asText,
              'append dot inner'.asText.on(),
              'append dot outer'.asText.on(),
            ].asColumn.center;
          }).handle(MessageExample(message: context.findAndTrust<String>())),
        )
            .handle('inherited message')
            .ensureDirection(context)
            .ensureMedia(context)));
  });
}
