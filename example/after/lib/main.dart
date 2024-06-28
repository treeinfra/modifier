import 'package:flutter/widgets.dart';
import 'package:modifier/modifier.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => builder((context) => [
            context.findAndTrust<String>().asText.padding(bottom: 50),
            'Click me to append a dot'
                .asText
                .on(tap: () => context.update<String>((message) => '$message.'))
          ].asColumn)
      .center
      .handle('message')
      .ensureDirection(context)
      .ensureMedia(context);
}
