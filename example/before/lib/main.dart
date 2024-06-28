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
          child: Text(
            'Complex and endless nesting hell.',
          ),
        ),
      ),
    );
  }
}
