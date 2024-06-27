# Modifier

Syntax sugar optimizations to avoid nesting hell in Flutter.

Before:

```dart
import 'package:flutter/widgets.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryData.fromView(View.of(context));
    return MediaQuery(
      data: media,
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text('app root'),
        ),
      ),
    );
  }
}
```

After:

```dart
import 'package:flutter/widgets.dart';
import 'package:modifier/modifier.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => const Text('app root')
      .center
      .ensureDirection(context)
      .ensureMedia(context);
}
```
