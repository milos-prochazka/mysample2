// ignore_for_file: unnecessary_this
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_binder_builder.dart';

typedef ValuePresenter = dynamic Function<T>(T value, dynamic parameter);

class DataBinder
{
  bool autoCreateValue;
  final values = <String, ValueState>{};

  DataBinder({this.autoCreateValue = false});

  ValueState operator [](String name) => values[name]!;

  ValueState<T> getValue<T>(String name, {dynamic defValue})
  {
    if (!this.autoCreateValue)
    {
      return values[name]! as ValueState<T>;
    }
    else
    {
      return (values[name] ?? addValue<T>(name, defValue)) as ValueState<T>;
    }
  }

  ValueState<T> addValue<T>
  (
    String name, T value,
    {ValuePresenter? presenter,
      ValueStateInitializedEvent? onInitialized,
      ValueChangedEvent? onValueChanged,
      ValueStateEvent? onEvent,
      dynamic tag}
  )
  {
    final result = ValueState<T>(name, value,
      presenter: presenter, onValueChanged: onValueChanged, onInitialized: onInitialized, onEvent: onEvent, tag: tag);
    values[name] = result;
    return result;
  }

  P read<P>(String name)
  {
    return values[name]!.read<P>();
  }

  Widget build({Key? key, required BuildContext context, required WidgetBuilder builder})
  {
    return DataBinderWidget(key: key, binder: this, child: Builder(builder: builder));
  }

  static DataBinder of(BuildContext context)
  {
    final ihnerited = context.dependOnInheritedWidgetOfExactType<DataBinderWidget>();

    return ihnerited!.binder;
  }

  forceNotifyAll()
  {
    for (final entry in this.values.entries)
    {
      entry.value.forceValueNotify();
    }
  }

  T readOrDefault<T>
  (
    {required T defaultValue, String? sourceValueName, ValueState? propertySource, dynamic keyParameter}
  )
  {
    if (sourceValueName == null)
    {
      if (keyParameter == null || propertySource == null)
      {
        return defaultValue;
      }
      else
      {
        return propertySource.getProperty(keyParameter) ?? defaultValue;
      }
    }
    else
    {
      return values[sourceValueName]?.read<T>(keyParameter) ?? defaultValue;
    }
  }
}

class DataBinderWidget extends InheritedWidget
{
  final DataBinder binder;
  const DataBinderWidget({super.key, required super.child, required this.binder});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)
  {
    return true;
  }
}

class ValueState<T> extends ChangeNotifier implements ValueListenable<T>
{
  String name;
  ValuePresenter? presenter;
  dynamic state;
  final ValueStateInitializedEvent? onInitialized;
  final ValueStateEvent? onEvent;
  final ValueChangedEvent? onValueChanged;
  Map<dynamic, dynamic>? _properties;
  dynamic tag;

  ValueState
  (
    this.name, this._value,
    {this.presenter,
      this.onInitialized,
      this.onEvent,
      this.onValueChanged,
      this.tag,
      Map<dynamic, dynamic>? properties}
  )
  : _properties = properties;

  P read<P>([dynamic parameter]) => (presenter == null) ? _value as P : presenter!<T>(_value, parameter) as P;
  String readString([dynamic parameter]) =>
  (presenter == null) ? _value.toString() : (presenter!<T>(_value, parameter)).toString();

  T _value;

  @override
  T get value => _value;

  set value(T newValue)
  {
    if (_value != newValue)
    {
      _value = newValue;
      forceValueNotify();
    }
  }

  S setState<S>({required BuildContext context, required ValueStateInitializer initializer})
  {
    if (this.state == null)
    {
      final st = initializer(context, this);
      this.state = st ?? false;
      this.onInitialized?.call(context, this, st);
    }

    return this.state as S;
  }

  forceValue(T newValue)
  {
    _value = newValue;
    forceValueNotify();
  }

  var _nestedNotification = false;
  var _delayedNotification = false;

  forceValueNotify()
  {
    if (_nestedNotification)
    {
      _delayedNotification = true;
    }
    else
    {
      try
      {
        _nestedNotification = true;

        do
        {
          _delayedNotification = false;

          onValueChanged?.call(this);
          notifyListeners();
        }
        while (_delayedNotification);
      }
      finally
      {
        _nestedNotification = false;
      }
    }
  }

  addValueListener(ValueStateEvent listener, {dynamic event, dynamic parameter})
  {
    this.addListener(() => listener.call(this, event, parameter));
  }

  doEvent({dynamic event, dynamic parameter})
  {
    this.onEvent?.call(this, event, parameter);
  }

  Widget buildWidget(BuildContext context, {required ValueStateWidgetBuilder builder, Widget? child})
  {
    print("buildWidget $T");
    return ValueStateBuilder
    (
      valueState: this,
      builder: builder,
      child: child,
    );
  }

  dynamic getProperty(dynamic key) => this._properties?[key];

  void setProperty(dynamic key, dynamic value, [bool forceNotify = false])
  {
    this._properties ??= <dynamic, dynamic>{};
    final old = this._properties![key];

    if (forceNotify || old != value)
    {
      this._properties![key] = value;
      this.forceValueNotify();
    }
  }
}

typedef ValueStateWidgetBuilder<T> = Widget Function(BuildContext context, ValueState<T> value, Widget? child);
typedef ValueStateInitializer = dynamic Function(BuildContext context, ValueState value);
typedef ValueStateInitializedEvent = Function(BuildContext context, ValueState value, dynamic state);
typedef ValueStateEvent = Function(ValueState value, dynamic event, dynamic parameter);
typedef ValueChangedEvent = Function(ValueState value);

////////////////////////////////////////////////////////////////////////////////////////////////

class ValueStateBuilder extends StatefulWidget
{
  final ValueState valueState;
  final ValueStateWidgetBuilder builder;
  final Widget? child;

  ValueStateBuilder({super.key, required this.valueState, required this.builder, this.child});

  @override
  State<ValueStateBuilder> createState() => _ValueStateBuilderState();
}

class _ValueStateBuilderState extends State<ValueStateBuilder>
{
  @override
  void initState()
  {
    super.initState();
    widget.valueState.addListener(_valueChanged);
  }

  @override
  Widget build(BuildContext context)
  {
    return widget.builder(context, widget.valueState, widget.child);
  }

  @override
  void didUpdateWidget(ValueStateBuilder oldWidget)
  {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.valueState != widget.valueState)
    {
      oldWidget.valueState.removeListener(_valueChanged);
      widget.valueState.addListener(_valueChanged);
    }
  }

  @override
  void dispose()
  {
    widget.valueState.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged()
  {
    setState(() {});
  }
}

enum StdValueProperty
{
  enabled(0x0001),
  visible(0x0002),
  length(0x0003),
  slected(0x0004),
  checked(0x0005),
  onClicked(0x1000),
  onSelect(0x1001),
  onComplete(0x1002),
  onSubmited(0x1003),
  onTap(0x1004),
  onPressed(0x1005),
  onLongPress(0x1006),
  onHover(0x1007),
  onFocusChanged(0x1008),
  onChanged(0x1009),
  onChangeStart(0x100A),
  onChangeEnd(0x100B),
  onCanceled(0x100C);

  final int value;
  const StdValueProperty(this.value);
}