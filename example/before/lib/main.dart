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
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MessageHandler(
          message: 'message',
          child: Builder(builder: (context) {
            final message = MessageHandler.of(context);
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Text(message),
                  ),
                  GestureDetector(
                    onTap: () {
                      MessageHandler.update(context, (message) => '$message.');
                    },
                    child: const Text('Click me to append a dot'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MessageHandler extends StatefulWidget {
  const MessageHandler({
    super.key,
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  static String? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedMessage>()?.message;

  static String of(BuildContext context) {
    final message = maybeOf(context);
    assert(message != null, 'cannot find $MessageHandler in context');
    return message!;
  }

  static void update(
    BuildContext context,
    String Function(String raw) updater,
  ) {
    final handler =
        context.dependOnInheritedWidgetOfExactType<_InheritedMessage>();
    if (handler != null) handler.update(updater(handler.message));
  }

  @override
  State<MessageHandler> createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  late String _message = widget.message;

  void update(String message) {
    if (_message != message) {
      setState(() {
        _message = message;
      });
    }
  }

  @override
  void didUpdateWidget(covariant MessageHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(widget.message);
  }

  @override
  Widget build(BuildContext context) => _InheritedMessage(
        message: _message,
        update: update,
        child: widget.child,
      );
}

class _InheritedMessage extends InheritedWidget {
  const _InheritedMessage({
    required this.message,
    required this.update,
    required super.child,
  });

  final String message;
  final void Function(String message) update;

  @override
  bool updateShouldNotify(covariant _InheritedMessage oldWidget) =>
      message != oldWidget.message;
}
