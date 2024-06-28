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
            final inner = context.findAndTrust<String>();
            final outer = context.findAndTrust<int>();
            void append() => context.update<String>((inner) => '$inner.');
            void increase() => context.update<int>((outer) => outer + 1);
            return [
              'inner message: $inner'.asText,
              'outer message: $outer'.asText,
              'append dot inner'.asText.on(tap: append),
              'increase outer'.asText.on(tap: increase),
            ].asColumn.center;
          }).handle(context.find<int>().toString()),
        ).handle(123456).ensureDirection(context).ensureMedia(context)));

    // Initial values.
    expect(find.text('inner message: 123456'), findsOneWidget);
    expect(find.text('outer message: 123456'), findsOneWidget);
    expect(find.text('append dot inner'), findsOneWidget);
    expect(find.text('increase outer'), findsOneWidget);

    // Change inner value but outer won't change.
    await t.tap(find.text('append dot inner'));
    await t.pump();
    expect(find.text('inner message: 123456.'), findsOneWidget);
    expect(find.text('outer message: 123456'), findsOneWidget);

    // Change outer value and inner will change.
    await t.tap(find.text('increase outer'));
    await t.pump();
    expect(find.text('inner message: 123457'), findsOneWidget);
    expect(find.text('outer message: 123457'), findsOneWidget);
  });
}
