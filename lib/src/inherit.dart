import 'package:flutter/widgets.dart';

class InheritedData<T> extends InheritedWidget {
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
  const InheritedData({
    super.key,
    required this.data,
    required super.child,
  });

  final T data;

  @override
  bool updateShouldNotify(covariant InheritedData<T> oldWidget) =>
      this.data != oldWidget.data;
}

class InheritedStaticData<T> extends InheritedWidget {
  /// Similar to [InheritedData], but the [data] will never change.
  ///
  /// 1. Register an unchanged data into the widget tree.
  ///    That all its descendants can access the [data]
  ///    by calling the [FindInherit.find] method
  ///    (an extension on [BuildContext]).
  /// 2. This widget is designed to handle apis such as static functions,
  ///    which will not change during the whole life cycle.
  /// 3. It's more recommended to use [WrapInherit.inheritStatic]
  ///    (an extension on [Widget])
  ///    rather than calling this constructor directly.
  const InheritedStaticData({
    super.key,
    required this.data,
    required super.child,
  });

  final T data;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

extension WrapInherit on Widget {
  Widget inherit<T>(T data) => InheritedData<T>(data: data, child: this);

  Widget inheritStatic<T>(T data) =>
      InheritedStaticData<T>(data: data, child: this);
}

extension FindInherit on BuildContext {
  T? find<T>() => dependOnInheritedWidgetOfExactType<InheritedData<T>>()?.data;

  T findAndDefault<T>(T defaultValue) => find<T>() ?? defaultValue;

  T findAndTrust<T>() {
    final data = find<T>();
    assert(data != null, 'cannot find $T in context');
    return data!;
  }

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
  @override
  Widget build(BuildContext context) => widget.child.inherit(widget.data);
}
