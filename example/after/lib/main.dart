import 'package:flutter/widgets.dart';
import 'package:modifier/modifier.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => 'Concise chain style programming.'
      .asText
      .center
      .ensureDirection(context)
      .ensureMedia(context);
}
