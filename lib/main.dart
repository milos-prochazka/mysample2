// ignore_for_file: unnecessary_this
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'support/data_binder.dart';
import 'support/data_binder_builder.dart';

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
  final binder = DataBinder();
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
      'editor', 'INIT text',
      //onInitialized: (context, value, state) => (state as TextEditingController).text = 'QaQaQa',
      onValueChanged: (value)
      {
        if (value.state != null)
        {
          final te = value.state as TextEditingController;
          print('Text changed ${te.text}');
        }
      }
    );

    final editor1 = binder.addValue<String>
    (
      'editor1', 'INIT 1 text',
      //onInitialized: (context, value, state) => (state as TextEditingController).text = 'QaQaQa',
      onValueChanged: (value)
      {
        if (value.state != null)
        {
          final te = value.state as TextEditingController;
          print('Text changed ${te.text}');
        }
      },
      onEvent: (value, event, parameter) => print('Event $event $parameter')
    );

    binder.addValue<double>('slider', 0.5);

    // TODO Upravit checkbox
    final checkbox = binder.addValue<bool?>('check', false,
      onEvent: (value, event, parameter) => value.value = !(value.value as bool? ?? false));

    final radio = binder.addValue<RadioValues?>('radio', RadioValues.second,
      onValueChanged: (value) => print(value.value.toString()));

    binder.addValue<String?>('drop_down', 'Free');

    final button = binder.addValue<bool>('button', false, onEvent: <bool>(value, event, parameter) => cnt.value++);

    binder.addValue<bool>('button1', false,
      onEvent: (value, event, parameter) => print("button1 ${value.name} $event $parameter"));
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

    style1 = Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.red, fontWeight: FontWeight.bold);
    style2 = Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.green);
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
          body: SingleChildScrollView
          (
            child: Center
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
                  DataBinder.of(context)['counter'].buildWidget
                  (
                    context,
                    builder: <String>(context, value, child)
                    {
                      final style = binder['style'].read<TextStyle?>();
                      return Text(value.readString('aaa'), style: style);
                    }
                  ),
                  DataBinderBuilder.buildText(context, bindValue: 'counter', styleParam: 'style'),
                  binder['editor'].buildWidget
                  (
                    context, builder: (context, value, child)
                    {
                      return TextField
                      (
                        controller: value.setState
                        (
                          context: context,
                          initializer: (context, value)
                          {
                            final result = TextEditingController(text: value.readString());
                            result.addListener
                            (
                              ()
                              {
                                value.value = result.text;
                              }
                            );
                            return result;
                          }
                        ),
                        /*inputFormatters:
                      [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}\-?\d{0,2}')),
                        //FilteringTextInputFormatter.deny(RegExp('[abFeG]')),
                      ],*/
                        enabled: true,
                      );
                    }
                  ),
                  DataBinderBuilder.buildTextField(context, bindValue: 'editor1'),
                  buildRadio(context, 'radio'),
                  DataBinderBuilder.buildElevatedButtonIcon
                  (
                    context,
                    bindValue: 'button1',
                    label: const Text('BUTTON1', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    icon: Text('icon')
                  ),
                  DataBinderBuilder.buildDropdownButton
                  (
                    context,
                    bindValue: 'drop_down',
                    items: <String>['One', 'Two', 'Free', 'Four'].map<DropdownMenuItem<String>>
                    (
                      (String value)
                      {
                        return DropdownMenuItem<String>
                        (
                          value: value,
                          child: Text(value),
                        );
                      }
                    ).toList()
                  ),
                  DataBinderBuilder.buildSlider(context,
                    bindValue: 'slider', labelBuilder: (sliderValue) => sliderValue.toStringAsFixed(3))
                ],
              ),
            )
          ),
          floatingActionButton: FloatingActionButton
          (
            child: const Icon(Icons.plus_one),
            onPressed: ()
            {
              //var v = binder['counter'];
              //v.value++;

              DataBinder.of(context)['button'].doEvent();
            },
          ),
        )
      )
    );
  }

  Widget buildRadio(BuildContext context, String bindValue)
  {
    return DataBinderBuilder.buildBasicRadioColumn<RadioValues>
    (
      context,
      bindValue: bindValue,
      checkedValues: [RadioValues.first, RadioValues.second, RadioValues.three],
      titleTexts: ['prvni', 'druhy', 'treti'],
      titleWidgets: [const Text('prvni widget')]
    );
    /*return Column(children:
    <Widget>[
      /////////////////////
      ListTile(
        title: Text('prvni'),
        enabled: false,
        leading: EventBinderBuilder.buildRadio<RadioValues>(context,bindValue: bindValue,checkedValue: RadioValues.first, enabled: false),
      ),
      ////////////////////
      ListTile(
        title: Text('druhy'),
        leading: EventBinderBuilder.buildRadio<RadioValues>(context,bindValue: bindValue,checkedValue: RadioValues.second
        ),
      ),
      ////////////////////
      EventBinderBuilder.buildRadioListTile<RadioValues>(context,bindValue: bindValue,  title: Text('treti'), checkedValue: RadioValues.three),
    ],);*/
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
        return Colors.lightBlue;
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

enum RadioValues { first, second, three }
///////////////////////////////////////////////////////////////////////////////////////