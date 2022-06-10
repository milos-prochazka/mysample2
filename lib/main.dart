// ignore_for_file: unnecessary_this

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomWidgetData
{
  final Color backgroundColor;
  final int width;
  final int height;

  CustomWidgetData
  (
    {
      required this.backgroundColor,
      required this.width,
      required this.height,
    }
  );
}

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      home: MyHomePage(context: context, title: 'title'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  static TextStyle? style1, style2;

  MyHomePage({Key? key, required BuildContext context, required this.title}) : super(key: key)
  {
    style1 = Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.red);
    style2 = Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.green);
  }
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  //final ValueNotifier<int> _counter = ValueNotifier<int,String>(0);
  final _counter = ValueState<int, String>('counter', 0);
  var _style = ValueNotifier<TextStyle>(MyHomePage.style1!);
  final binder = EventBinder();

  _MyHomePageState()
  {
    binder.addValue<int, String>('counter', 1, presenter: <String, int>(value) => '[$value]');
    binder.addValue('b', 2);

    //String s = binder.read('a');

    _counter.presenter = <int, String>(value)
    {
      return '<<< $value >>>';
    };
  }

  final Widget goodJob = const Text('Good job!');
  @override
  Widget build(BuildContext context)
  {
    return binder.build
    (
      context: context,
      child: Scaffold
      (
        appBar: AppBar(title: Text(widget.title)),
        body: Center
        (
          child: Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>
            [
              const Text('You have pushed the button this many times:'),
              _counter.buildWidget
              (
                context, widgetBuilder: <String>(context, value, child)
                {
                  return Text(value);
                }
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton
        (
          child: const Icon(Icons.plus_one),
          onPressed: ()
          {
            var v = binder['counter'];
            v.value++;

            _counter.value += 1;
            _style.value = ((_counter.value & 1) == 1) ? MyHomePage.style1! : MyHomePage.style2!;
          },
        ),
      )
    );
  }
}

typedef ValuePresenter = dynamic Function<T, P>(T value);

class EventBinder
{
  final values = <String, ValueState>{};

  operator [](String name) => values[name];

  addValue<T, P>(String name, T value, {ValuePresenter? presenter})
  {
    values[name] = ValueState<T, P>(name, value, presenter: presenter);
  }

  P read<P>(String name)
  {
    return values[name]!.read<P>();
  }

  Widget build({Key? key, required BuildContext context, required Widget child})
  {
    return InheritedEventBinder(key: key, binder: this, child: child);
  }

  getValueBuilder<T>(String id,
    {required ValueWidgetBuilder<T> widgetBuilder, EventBinder_ValueBuilder? valueBuilder, Widget? child}) {}

  static EventBinder of(BuildContext context)
  {
    final ihnerited = context.dependOnInheritedWidgetOfExactType<InheritedEventBinder>();

    return ihnerited!.binder;
  }
}

class InheritedEventBinder extends InheritedWidget
{
  final EventBinder binder;
  const InheritedEventBinder({super.key, required super.child, required this.binder});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)
  {
    return true;
  }
}

typedef EventBinder_ValueBuilder = Function<T>();

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

/////////////////////////////////////////////////////////////////////////////////////////

class ValueState<T, P> extends ChangeNotifier implements ValueListenable<T>
{
  String name;
  ValuePresenter? presenter;

  ValueState(this.name, this._value, {this.presenter});

  P read<P>()
  {
    P result;
    result = presenter == null ? _value as P : presenter!<T, P>(_value) as P;
    return result;
  }

  T _value;

  @override
  T get value => _value as T;

  set value(T newValue)
  {
    if (_value != newValue)
    {
      _value = newValue;
      this.notifyListeners();
    }
  }

  forceValue(T newValue)
  {
    _value = newValue;
    this.notifyListeners();
  }

  forceEvent()
  {
    this.notifyListeners();
  }

  Widget buildWidget(BuildContext context,
    {required ValueWidgetBuilder<dynamic> widgetBuilder, EventBinder_ValueBuilder? valueBuilder, Widget? child})
  {
    return ValueStateBuilder<T, P>
    (
      valueState: this,
      builder: widgetBuilder,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////

class ValueStateBuilder<T, P> extends StatefulWidget
{
  final ValueState<T, P> valueState;
  final ValueWidgetBuilder<dynamic> builder;
  final Widget? child;

  const ValueStateBuilder({super.key, required this.valueState, required this.builder, this.child});

  @override
  State<ValueStateBuilder> createState() => _ValueStateBuilderState<T, P>();
}

class _ValueStateBuilderState<T, P> extends State<ValueStateBuilder>
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
    return widget.builder(context, widget.valueState.read(), widget.child);
  }

  @override
  void didUpdateWidget(ValueStateBuilder<T, P> oldWidget)
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