import 'package:flutter/widgets.dart';

class Inherit<T> extends InheritedWidget {
  /// A wrap of generic on the [InheritedWidget] widget.
  ///
  /// 1. Register an inherited [data] into the widget tree.
  ///    That all its descendants can access the [data]
  ///    by calling the [FindInherit.find] method
  ///    (an extension on [BuildContext]).
  /// 2. As it extends the [InheritedWidget] it can also
  ///    pass data to the descendants in the widget tree,
  ///    and let all related widget to re-renderer when the data changed.
  ///    But it let all similar inherit data to share the code
  ///    rather than inherit raw [InheritedWidget] once and once again.
  /// 3. It's more recommended to use [WrapInherit.inherit]
  ///    (an extension on [Widget])
  ///    rather than calling this constructor directly.
  const Inherit({
    super.key,
    required this.data,
    required super.child,
  });

  final T data;

  @override
  bool updateShouldNotify(covariant Inherit<T> oldWidget) =>
      this.data != oldWidget.data;
}

extension WrapInherit on Widget {
  /// Wrap [Inherit] around this widget with given [data],
  /// and you can find it in the widget tree by calling [FindInherit.find].
  Widget inherit<T>(T data) => Inherit<T>(data: data, child: this);
}

extension FindInherit on BuildContext {
  /// Find data from widget tree with given type.
  /// Those data are stored inside into the widget tree
  /// using the [WrapInherit.inherit] extended on [Widget].
  ///
  /// As there might not be any [Inherit]ed data with given type,
  /// the return value might be null.
  /// You can consider using [findAndCheck], [findAndDefault], or [findAndTrust]
  /// for a conciser coding style, rather than processing the nullable result
  /// of this method.
  T? find<T>() => dependOnInheritedWidgetOfExactType<Inherit<T>>()?.data;

  /// [find] data from widget tree with given type.
  /// Those data are stored inside into the widget tree
  /// using the [WrapInherit.inherit] extended on [Widget].
  /// And if not found, then use the [defaultValue].
  T findAndDefault<T>(T defaultValue) => find<T>() ?? defaultValue;

  /// [find] inherited data from widget tree with given type.
  /// Those data are stored inside into the widget tree
  /// using the [WrapInherit.inherit] extended on [Widget].
  ///
  /// You must ensure the data will be found.
  /// There's only an `assert` to check whether it will find the data
  /// in debug mode and there's no check in release mode.
  /// If you cannot make sure there will be such data,
  /// please consider using [find] or [findAndCheck] as alternative.
  T findAndTrust<T>() {
    final data = find<T>();
    assert(data != null, 'cannot find $T in context');
    return data!;
  }

  /// [find] data from widget tree with given type.
  /// Those data are stored inside into the widget tree
  /// using the [WrapInherit.inherit] extended on [Widget].
  /// And if not found, then throw an exception.
  T findAndCheck<T>() {
    final data = find<T>();
    if (data == null) throw Exception('cannot find $T in context');
    return data;
  }
}

class InheritHandler<T> extends StatefulWidget {
  const InheritHandler({
    super.key,
    required this.data,
    required this.child,
  });

  final T data;
  final Widget child;

  @override
  State<InheritHandler<T>> createState() => _InheritHandlerState<T>();
}

class _InheritHandlerState<T> extends State<InheritHandler<T>> {
  late T _data = widget.data;

  void update(T value) {
    if (_data != value) setState(() => _data = value);
  }

  @override
  void didUpdateWidget(covariant InheritHandler<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(widget.data);
  }

  @override
  Widget build(BuildContext context) =>
      widget.child.inherit(_data).inherit(InheritHandlerAPI(update));
}

/// This class is an encapsulation of [_InheritHandlerState.update].
/// It is here because the signature of such method is easy to be confused,
/// that it requires such encapsulation to distinguish from
/// other potential functions with the same signature.
class InheritHandlerAPI<T> {
  const InheritHandlerAPI(this.update);

  final void Function(T value) update;
}

extension WrapInheritHandler on Widget {
  Widget handle<T>(T data) => InheritHandler<T>(data: data, child: this);
}

extension UpdateInheritHandler on BuildContext {
  /// When inherit certain type of data inside widget tree
  /// using [WrapInheritHandler.handle] extension method,
  /// you can use this method to modify its value.
  ///
  /// This method will not check whether there are such inherit
  /// in the widget tree. It there's no such inherit,
  /// it will return without any error.
  /// If you'd like to ensure there's such inherit, see [updateAndCheck].
  void update<T>(T Function(T raw) updater) {
    final raw = find<T>();
    final api = find<InheritHandlerAPI<T>>();
    if (raw != null && api != null) api.update(updater(raw));
  }

  /// When inherit certain type of data inside widget tree
  /// using [WrapInheritHandler.handle] extension method,
  /// you can use this method to modify its value.
  ///
  /// This method will throw exception when cannot find such inherit
  /// inside the widget tree.
  /// If you'd like to ignore such errors, please refer to [update].
  void updateAndCheck<T>(T Function(T raw) updater) {
    final raw = findAndCheck<T>();
    final api = findAndCheck<InheritHandlerAPI<T>>();
    api.update(updater(raw));
  }
}
