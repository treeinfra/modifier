import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modifier/modifier.dart';

void main() {
  testWidgets('enable text', (t) async {
    await t.pumpWidget(
      builder((context) => const Text('validation')
          .ensureDirection(context)
          .ensureMedia(context)),
    );
  });
}
