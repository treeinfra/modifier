import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';

void main() {
  testWidgets('inherit and find', (t) async {
    const message = 'it works';
    await t.pumpWidget(
      builder(
        (context) => Text(context.findAndTrust<String>())
            .center
            .ensureDirection(context)
            .ensureMedia(context),
      ).inherit(message),
    );
    expect(find.text(message), findsOneWidget);
  });
}
