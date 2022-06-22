// ignore_for_file: unnecessary_this
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'event_binder_builder.dart';

typedef ValuePresenter = dynamic Function<T>(T value, dynamic parameter);

class EventBinder
{
  final values = <String, ValueState>{};

  ValueState operator [](String name) => values[name]!;

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
    return EventBinderWidget(key: key, binder: this, child: Builder(builder: builder));
  }

  static EventBinder of(BuildContext context)
  {
    final ihnerited = context.dependOnInheritedWidgetOfExactType<EventBinderWidget>();

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

class EventBinderWidget extends InheritedWidget
{
  final EventBinder binder;
  const EventBinderWidget({super.key, required super.child, required this.binder});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)
  {
    return true;
  }
}

/*typedef EventBinder_ValueBuilder = Function<T>();

class EventInfo
{
  String id;
  dynamic state;
  Object? listenable;

  EventInfo(this.id);

  getValueBuilder<T>(BuildContext context,
    {required ValueWidgetBuilder<T> widgetBuilder, EventBinder_ValueBuilder? valueBuilder, Widget? child})
  {
    if (state == null && valueBuilder != null)
    {
      state = valueBuilder<T>();
      listenable = ValueNotifier<T>(state);
    }

    return ValueListenableBuilder
    (
      builder: widgetBuilder, valueListenable: listenable as ValueNotifier<T>, child: child
    );
  }
}

class EventHandler
{
  EventHandler? next;
  EventHandler? prev;

  EventHandler()
  {
    next = this;
    prev = this;
  }

  void addNext(EventHandler nextEvent)
  {
    assert(next != null && prev != null && nextEvent.next != null && nextEvent.prev != null);

    final nextP = nextEvent.prev!;
    final thisN = this.next;

    this.next = nextEvent;
    nextEvent.prev = this;
    nextP.next = thisN;
  }

  void addPrev(EventHandler prevEvent)
  {
    addPrev(this.prev!);
  }

  void remove()
  {
    if (this.next != null && this.prev != null)
    {
      this.prev!.next = this.next;
      this.next!.prev = this.prev;
      this.next = null;
      this.prev = null;
    }
  }

  void invalidate()
  {
    if (this.next != null && this.prev != null)
    {
      var event = this;

      do
      {
        final nextEvent = event.next!;
        event.next = null;
        event.prev = null;
        event = nextEvent;
      }
      while (event != this);
    }
  }
}

class EventValueNotifier<T> extends ValueNotifier<T>
{
  EventValueNotifier(super.value);

  forceValue(T newValue)
  {
    if (value == newValue)
    {
      forceEvent();
    }
    else
    {
      value = newValue;
    }
  }

  forceEvent()
  {
    this.notifyListeners();
  }
}
*/
/////////////////////////////////////////////////////////////////////////////////////////

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

  Widget buildWidget(BuildContext context, {required ValueStateWidgetBuilder<T> builder, Widget? child})
  {
    return ValueStateBuilder<T>
    (
      valueState: this,
      builder: builder,
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

class ValueStateBuilder<T> extends StatefulWidget
{
  final ValueState<T> valueState;
  final ValueStateWidgetBuilder<T> builder;
  final Widget? child;

  const ValueStateBuilder({super.key, required this.valueState, required this.builder, this.child});

  @override
  State<ValueStateBuilder> createState() => _ValueStateBuilderState<T>();
}

class _ValueStateBuilderState<T> extends State<ValueStateBuilder>
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
  void didUpdateWidget(ValueStateBuilder<T> oldWidget)
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
  enabled(1),
  visible(2),
  length(3);

  final int value;
  const StdValueProperty(this.value);
}