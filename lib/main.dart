// ignore_for_file: unnecessary_this
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String title;
  MyHomePage({Key? key, required BuildContext context, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  TextStyle? style1, style2;
  final binder = EventBinder();
  bool initialized = false;
  bool? isChecked = null;

  _MyHomePageState()
  {
    final cnt = binder.addValue('counter', 1, presenter: <int>(value, param) => '[$value]');
    final style = binder.addValue<TextStyle?>('style', null,
      presenter: <TextStyle>(value, param) => (cnt.value & 1) == 1 ? style1 : style2);
    final editor = binder.addValue<String>
    (
      'editor',
      'INIT text',
      onInitialized: (context, value, state) => (state as TextEditingController).text = 'QaQaQa',
    );

    final checkbox = binder.addValue<bool?>('check', false,
      onEvent: (value, event, parameter) => value.value = !(value.value as bool? ?? false));

    final button = binder.addValue<bool>('button', false, onEvent: <bool>(value, event, parameter) => cnt.value++);
  }

  checkEvent(ValueState value, dynamic event, dynamic parameter)
  {
    value.value = !(value.value as bool? ?? false);
  }

  @override
  void initState()
  {
    super.initState();
    initialized = false;
  }

  void initContext(BuildContext context)
  {
    if (initialized)
    {
      return;
    }

    style1 = Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.red, fontWeight: FontWeight.bold);
    style2 = Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.green);

    initialized = false;
  }

  final Widget goodJob = const Text('Good job!');
  @override
  Widget build(BuildContext context)
  {
    initContext(context);

    Color getColor(Set<MaterialState> states)
    {
      const Set<MaterialState> interactiveStates = <MaterialState>
      {
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.disabled))
      {
        return Colors.grey;
      }
      else if (states.any(interactiveStates.contains))
      {
        return Colors.blue;
      }
      else
      {
        return Colors.red;
      }
    }

    return binder.build
    (
      context: context,
      builder: (BuildContext context) => Scaffold
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
              //_counter.buildWidget
              Checkbox
              (
                value: isChecked,
                tristate: true,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                onChanged: (value)
                {
                  setState
                  (
                    ()
                    {
                      isChecked = !(isChecked ?? false);
                    }
                  );
                },
              ),
              EventBinderBuilder.buildCheckBox(context, bindValue: 'check'),
              EventBinder.of(context)['counter'].buildWidget
              (
                context, builder: <String>(context, value, child)
                {
                  final style = binder['style'].read<TextStyle?>();
                  return Text(value.readString('aaa'), style: style);
                }
              ),
              EventBinderBuilder.buildText(context, bindValue: 'counter', bindStyle: 'style'),
              binder['editor'].buildWidget
              (
                context, builder: (context, value, child)
                {
                  return TextField
                  (
                    controller: value.setState
                    (
                      context: context,
                      initializer: (context, value) => TextEditingController(text: value.readString())
                    ),
                    inputFormatters:
                    [
                      FilteringTextInputFormatter.allow(RegExp(r'\d{1,2}\-?\d{0,2}')),
                      //FilteringTextInputFormatter.deny(RegExp('[abFeG]')),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton
        (
          child: const Icon(Icons.plus_one),
          onPressed: ()
          {
            //var v = binder['counter'];
            //v.value++;

            EventBinder.of(context)['button'].doEvevent();
          },
        ),
      )
    );
  }
}

typedef ValuePresenter = dynamic Function<T>(T value, dynamic parameter);

class EventBinder
{
  final values = <String, ValueState>{};

  ValueState operator [](String name) => values[name]!;

  ValueState<T> addValue<T>
  (
    String name, T value,
    {ValuePresenter? presenter,
      VoidCallback? listener,
      ValueStateInitializedEvent? onInitialized,
      ValueStateEvent? onEvent}
  )
  {
    final result = ValueState<T>(name, value,
      presenter: presenter, listener: listener, onInitialized: onInitialized, onEvent: onEvent);
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

  T readOrDefault<T>(String? valueName, dynamic valueParam, T defaultValue)
  {
    if (valueName == null)
    {
      return defaultValue;
    }
    else
    {
      return values[valueName]?.read<T>(valueParam) ?? defaultValue;
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
  ValueStateInitializedEvent? onInitialized;
  ValueStateEvent? _onEvent;

  ValueState(this.name, this._value,
    {this.presenter, VoidCallback? listener, this.onInitialized, ValueStateEvent? onEvent})
  : _onEvent = onEvent
  {
    if (listener != null)
    {
      addListener(listener);
    }
  }

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
      this.notifyListeners();
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
    this.notifyListeners();
  }

  forceValueNotify()
  {
    this.notifyListeners();
  }

  doEvevent({dynamic event, dynamic parameter})
  {
    this._onEvent?.call(this, event, parameter);
  }

  Widget buildWidget(BuildContext context, {required ValueStateWidgetBuilder<T> builder, Widget? child})
  {
    return ValueStateBuilder<T>
    (
      valueState: this,
      builder: builder,
    );
  }
}

typedef ValueStateWidgetBuilder<T> = Widget Function(BuildContext context, ValueState<T> value, Widget? child);
typedef ValueStateInitializer = dynamic Function(BuildContext context, ValueState value);
typedef ValueStateInitializedEvent = Function(BuildContext context, ValueState value, dynamic state);
typedef ValueStateEvent = Function(ValueState value, dynamic event, dynamic parameter);

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

///////////////////////////////////////////////////////////////////////////////////////

class EventBinderBuilder
{
  static Widget buildText
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      //////////////
      TextStyle? style,
      String? bindStyle,
      dynamic bindStyleParam,
      //////////////
      StrutStyle? strutStyle,
      String? bindStrutStyle,
      dynamic bindStrutStyleParam,
      //////////////
      TextAlign? textAlign,
      //////////////
      TextDirection? textDirection,
      String? bindTextDirection,
      dynamic bindTextDirectionParam,
      //////////////
      Locale? locale,
      String? bindLocale,
      dynamic bindLocaleParam,
      //////////////
      bool? softWrap,
      TextOverflow? overflow,
      double? textScaleFactor,
      int? maxLines,
      //////////////
      String? semanticsLabel,
      String? bindSemanticsLabel,
      dynamic bindSemanticsLabelParam,
      //////////////
      TextWidthBasis? textWidthBasis,
      TextHeightBehavior? textHeightBehavior}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: <String>(context, value, child)
      {
        return Text
        (
          value.readString(bindValueParam),
          key: key,
          style: binder.readOrDefault(bindStyle, bindStyleParam, style),
          strutStyle: binder.readOrDefault(bindStrutStyle, bindStrutStyleParam, strutStyle),
          textAlign: textAlign,
          textDirection: binder.readOrDefault(bindTextDirection, bindTextDirectionParam, textDirection),
          locale: binder.readOrDefault(bindLocale, bindLocaleParam, locale),
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: binder.readOrDefault(bindSemanticsLabel, bindSemanticsLabelParam, semanticsLabel),
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior
        );
      }
    );
  }

  static Widget buildCheckBox
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      bool tristate = false,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      MouseCursor? mouseCursor,
      String? mouseValue,
      dynamic mouseValueParam,
      //////////////
      Color? activeColor,
      MaterialStateProperty<Color?>? fillColor,
      Color? checkColor,
      Color? focusColor,
      Color? hoverColor,
      MaterialStateProperty<Color?>? overlayColor,
      double? splashRadius,
      MaterialTapTargetSize? materialTapTargetSize,
      VisualDensity? visualDensity,
      FocusNode? focusNode,
      bool autofocus = false,
      OutlinedBorder? shape,
      BorderSide? side}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: <bool>(context, value, child)
      {
        return Checkbox
        (
          key: key,
          value: binder.readOrDefault(bindValue, bindValueParam, tristate ? null : false),
          onChanged: binder.readOrDefault(enabledValue, enabledValueParam, enabled)
          ? null
          : (v) => (value.doEvevent(event: null, parameter: v)),
          mouseCursor: binder.readOrDefault(mouseValue, mouseValueParam, mouseCursor),
          activeColor: activeColor,
          fillColor: fillColor,
          checkColor: checkColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor,
          splashRadius: splashRadius,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          shape: shape,
          side: side,
        );
      }
    );
  }
}