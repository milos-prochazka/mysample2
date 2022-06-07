// ignore_for_file: unnecessary_this

import 'dart:collection';

import 'package:flutter/material.dart';

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
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  var _style = ValueNotifier<TextStyle>(MyHomePage.style1!);

  final Widget goodJob = const Text('Good job!');
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
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
            ValueListenableBuilder<TextStyle>
            (
              valueListenable: _style,
              builder: (BuildContext context, TextStyle style, Widget? child)
              {
                return ValueListenableBuilder<int>
                (
                  builder: (BuildContext context, int value, Widget? child)
                  {
                    // This builder will only get called when the _counter
                    // is updated.
                    return Row
                    (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>
                      [
                        Text('$value', style: style),
                        //child!,
                      ],
                    );
                  },
                  valueListenable: _counter,
                  // The child parameter is most helpful if the child is
                  // expensive to build and does not depend on the value from
                  // the notifier.
                  //child: goodJob,
                );
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
          _counter.value += 1;
          _style.value = ((_counter.value & 1) == 1) ? MyHomePage.style1! : MyHomePage.style2!;
        },
      ),
    );
  }
}

class EventBinder
{
  getValueBuilder<T>(String id,
    {required ValueWidgetBuilder<T> widgetBuilder, EventBinder_ValueBuilder? valueBuilder, Widget? child}) {}
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