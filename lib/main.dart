// ignore_for_file: unnecessary_this
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'support/event_binder.dart';
import 'support/event_binder_builder.dart';

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
  bool _lights = false;

  _MyHomePageState()
  {
    final cnt = binder.addValue
    (
      'counter', 1,
      tag: 'qAqA',
      presenter: <int>(value, param) => '[$value]',
      onValueChanged: (value) => value.setProperty('style', (value.value & 1) == 1 ? style1 : style2)
    );
    cnt.addValueListener
    (
      (value, event, parameter)
      {
        print('${value.value} ${value.tag} $event $parameter');
      }, event: 'EVENT', parameter: 2.33
    );
    //cnt.addValueListener((value,event,param) => value.setProperty('style', (value.value & 1) == 1 ? style1 : style2));

    binder.addValue<TextStyle?>('style', style1,
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
    binder.forceNotifyAll();

    initialized = true;
  }

  final Widget goodJob = const Text('Good job!');
  @override
  Widget build(BuildContext context)
  {
    initContext(context);

    return CheckboxTheme
    (
      data: getCheckboxTheme(context),
      child: binder.build
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
                  //overlayColor: MaterialStateProperty.resolveWith(getOverlayColor),
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
                //EventBinderBuilder.buildCheckBox(context, bindValue: 'check', fillColor: MaterialStateProperty.resolveWith(getColor),),
                EventBinder.of(context)['counter'].buildWidget
                (
                  context,
                  builder: <String>(context, value, child)
                  {
                    final style = binder['style'].read<TextStyle?>();
                    return Text(value.readString('aaa'), style: style);
                  }
                ),
                EventBinderBuilder.buildText(context, bindValue: 'counter', bindStyleParam: 'style'),
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
                      enabled: false,
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

              EventBinder.of(context)['button'].doEvent();
            },
          ),
        )
      )
    );
  }

  CheckboxThemeData getCheckboxTheme(BuildContext context)
  {
    Color fillColor(Set<MaterialState> states)
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

    Color overlayColor(Set<MaterialState> states)
    {
      if (states.contains(MaterialState.disabled))
      {
        return Colors.transparent;
      }
      else
      {
        return Colors.blue.withAlpha(20);
      }
    }

    Color checkColor(Set<MaterialState> states)
    {
      return Colors.transparent;
    }

    final result = CheckboxTheme.of(context).copyWith
    (
      fillColor: MaterialStateColor.resolveWith(fillColor),
      overlayColor: MaterialStateColor.resolveWith(overlayColor)
    );

    return result;
  }
}

///////////////////////////////////////////////////////////////////////////////////////