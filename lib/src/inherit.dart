import 'package:flutter/widgets.dart';

/// A stateless widget to handle [Inherit]ed data in widget tree.
/// You can get the data value using [FindInherit.find] extension method
/// in the descendant widget of it in the widget tree.
///
/// It's strongly not recommended to use its constructor directly,
/// please consider the [WrapInherit.inherit] extension method on [Widget]
/// before using its constructor directly.
class Inherit<T> extends InheritedWidget {
  /// It's not recommended to use such constructor,
  /// please consider the [WrapInherit.inherit] encapsulation
  /// before using such constructor directly.
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

/// A stateful widget to handle [Inherit]ed data in widget tree.
///
/// 1. You can change the handled data from the descendants in the widget tree
///    using the [BuildContext]'s [InheritHandlerAPI.update] extension method.
/// 2. You can also customize [onUpdate] callback to resolve
///    actions when the value changed.
///
/// It's strongly not recommended to use it directly,
/// please consider using [WrapInheritHandler.handle] extended on [Widget]
/// before calling its constructor directly.
class InheritHandler<T> extends StatefulWidget {
  /// It's not recommended to use such constructor,
  /// please consider the [WrapInheritHandler.handle] encapsulation
  /// before using such constructor directly.
  const InheritHandler({
    super.key,
    this.onUpdate,
    required this.data,
    required this.child,
  });

  final void Function(T value)? onUpdate;
  final T data;
  final Widget child;

  @override
  State<InheritHandler<T>> createState() => _InheritHandlerState<T>();
}

class _InheritHandlerState<T> extends State<InheritHandler<T>> {
  late T _data = widget.data;

  void update(T value) {
    if (_data == value) return;
    setState(() => _data = value);
    widget.onUpdate?.call(value);
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
  /// Handle a data of type [T] into the widget tree.
  ///
  /// 1. This extension method is an encapsulation of [InheritHandler].
  /// 2. You can use [UpdateInheritHandler.update] extension method
  ///    to modify the handled value.
  /// 3. You can also specify [onUpdate] to register trigger actions
  ///    when the value changed.
  Widget handle<T>(T data, {void Function(T)? onUpdate}) => InheritHandler<T>(
        onUpdate: onUpdate,
        data: data,
        child: this,
      );
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
