import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'event_binder.dart';

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
      String? styleValue,
      dynamic styleParam,
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
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          strutStyle: binder.readOrDefault
          (
            defaultValue: strutStyle,
            sourceValueName: bindStrutStyle,
            propertySource: value,
            keyParameter: bindStrutStyleParam
          ),
          textAlign: textAlign,
          textDirection: binder.readOrDefault
          (
            defaultValue: textDirection,
            sourceValueName: bindTextDirection,
            propertySource: value,
            keyParameter: bindTextDirectionParam
          ),
          locale: binder.readOrDefault
          (
            defaultValue: locale, sourceValueName: bindLocale, propertySource: value, keyParameter: bindLocaleParam
          ),
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: binder.readOrDefault
          (
            defaultValue: semanticsLabel,
            sourceValueName: bindSemanticsLabel,
            propertySource: value,
            keyParameter: bindSemanticsLabelParam
          ),
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior
        );
      }
    );
  }

  static Widget buildElevatedButton
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      ButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget? child}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: child, builder: (context, value, child)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return ElevatedButton
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          onLongPress: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onLongPress, null)) : null,
          onHover: enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onHover, param)) : null,
          onFocusChange:
          enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onFocusChanged, param)) : null,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
        );
      }
    );
  }

  static Widget buildElevatedButtonIcon
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      ButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget label,
      required Widget icon}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: label, builder: (context, value, label)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return ElevatedButton.icon
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          onLongPress: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onLongPress, null)) : null,
          onHover: enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onHover, param)) : null,
          onFocusChange:
          enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onFocusChanged, param)) : null,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          label: label!,
          icon: icon,
        );
      }
    );
  }

  static Widget buildTextButton
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      ButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget child}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: child, //
      builder: (context, value, child)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return TextButton
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          onLongPress: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onLongPress, null)) : null,
          onHover: enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onHover, param)) : null,
          onFocusChange:
          enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onFocusChanged, param)) : null,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child!,
        );
      }
    );
  }

  static Widget buildTextButtonIcon
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      ButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget icon,
      required Widget label}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: label, //
      builder: (context, value, label)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return TextButton.icon
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          onLongPress: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onLongPress, null)) : null,
          onHover: enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onHover, param)) : null,
          onFocusChange:
          enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onFocusChanged, param)) : null,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          label: label!,
          icon: icon
        );
      }
    );
  }

  static Widget buildOutlinedButton
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      ButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget child}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: child, //
      builder: (context, value, child)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return OutlinedButton
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          onLongPress: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onLongPress, null)) : null,
          onHover: enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onHover, param)) : null,
          onFocusChange:
          enableEvent ? ((param) => value.onEvent?.call(value, StdValueProperty.onFocusChanged, param)) : null,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child!,
        );
      }
    );
  }

  static Widget buildOutlinedButtonIcon
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      ButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
      required Widget icon,
      required Widget label}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: label, //
      builder: (context, value, label)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return OutlinedButton.icon
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          onLongPress: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onLongPress, null)) : null,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          label: label!,
          icon: icon
        );
      }
    );
  }

  static Widget buildIconButton
  (
    BuildContext context,
    {required String bindValue,
      Key? key,
      //////////////
      IconButtonStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      double? iconSize,
      VisualDensity? visualDensity,
      EdgeInsetsGeometry? padding,
      AlignmentGeometry? alignment,
      double? splashRadius,
      Color? color,
      Color? focusColor,
      Color? hoverColor,
      Color? highlightColor,
      Color? splashColor,
      Color? disabledColor,
      //////////////
      MouseCursor? mouseCursor,
      String? mouseValue,
      dynamic mouseValueParam,
      //////////////
      FocusNode? focusNode,
      bool autofocus = false,
      //////////////
      String? tooltip,
      String? tooltipValue,
      dynamic tooltipValueParam,
      //////////////
      bool enableFeedback = true,
      BoxConstraints? constraints,
      required Widget icon}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      child: icon, //
      builder: (context, value, icon)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        final btnStyle = binder.readOrDefault
        (
          defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
        );

        return IconButton
        (
          key: key,
          onPressed: enableEvent ? (() => value.onEvent?.call(value, StdValueProperty.onPressed, null)) : null,
          iconSize: iconSize ?? btnStyle?.iconSize,
          padding: padding ?? btnStyle?.padding ?? const EdgeInsets.all(8.0),
          alignment: alignment ?? btnStyle?.alignment ?? Alignment.center,
          splashRadius: splashRadius ?? btnStyle?.splashRadius,
          color: color ?? btnStyle?.color,
          focusColor: focusColor ?? btnStyle?.focusColor,
          hoverColor: hoverColor ?? btnStyle?.hoverColor,
          highlightColor: highlightColor ?? btnStyle?.highlightColor,
          splashColor: splashColor ?? btnStyle?.splashColor,
          disabledColor: disabledColor ?? btnStyle?.disabledColor,
          // mouseCursor
          mouseCursor: binder.readOrDefault
          (
            defaultValue: mouseCursor,
            sourceValueName: mouseValue,
            propertySource: value,
            keyParameter: mouseValueParam
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          // mouseCursor
          tooltip: binder.readOrDefault
          (
            defaultValue: tooltip,
            sourceValueName: tooltipValue,
            propertySource: value,
            keyParameter: tooltipValueParam
          ),
          enableFeedback: enableFeedback,
          constraints: constraints,
          icon: icon!
        );
      }
    );
  }

  static Widget buildDropdownButton<T>
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      required List<DropdownMenuItem<T>>? items,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      TextStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      DropdownButtonBuilder? selectedItemBuilder,
      Widget? hint,
      Widget? disabledHint,
      int elevation = 8,
      Widget? underline,
      Widget? icon,
      Color? iconDisabledColor,
      Color? iconEnabledColor,
      double iconSize = 24.0,
      bool isDense = false,
      bool isExpanded = false,
      double? itemHeight = kMinInteractiveDimension,
      Color? focusColor,
      FocusNode? focusNode,
      bool autofocus = false,
      Color? dropdownColor,
      double? menuMaxHeight,
      bool? enableFeedback,
      AlignmentGeometry alignment = AlignmentDirectional.centerStart,
      BorderRadius? borderRadius}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: (context, value, label)
      {
        final enableEvent = binder.readOrDefault
        (
          defaultValue: enabled, sourceValueName: enabledValue, propertySource: value, keyParameter: enabledValueParam
        );

        return DropdownButton<T>
        (
          key: key,
          // style
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          // items
          items: items,
          // value
          value: binder.readOrDefault
          (
            defaultValue: null, sourceValueName: bindValue, propertySource: value, keyParameter: bindValueParam
          ),
          selectedItemBuilder: selectedItemBuilder,
          hint: hint,
          disabledHint: disabledHint,
          onChanged: (newValue) => enableEvent ? value.value = newValue : null,
          onTap: () => enableEvent ? value.onEvent?.call(value, StdValueProperty.onClicked, null) : null,
          elevation: elevation,
          underline: underline,
          icon: icon,
          iconDisabledColor: iconDisabledColor,
          iconEnabledColor: iconEnabledColor,
          iconSize: iconSize,
          isDense: isDense,
          isExpanded: isExpanded,
          itemHeight: itemHeight,
          focusColor: focusColor,
          focusNode: focusNode,
          autofocus: autofocus,
          dropdownColor: dropdownColor,
          menuMaxHeight: menuMaxHeight,
          enableFeedback: enableFeedback,
          alignment: alignment,
          borderRadius: borderRadius
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
          // value
          value: binder.readOrDefault
          (
            defaultValue: tristate ? null : false,
            sourceValueName: bindValue,
            propertySource: value,
            keyParameter: bindValueParam
          ),
          // onChanged event
          onChanged: binder.readOrDefault
          (
            defaultValue: enabled,
            sourceValueName: enabledValue,
            propertySource: value,
            keyParameter: enabledValueParam
          )
          ? (v) => (value.doEvent(event: null, parameter: v)) // TODO Upravit checkbox na value.value = v
          : null,
          // mouseCursor
          mouseCursor: binder.readOrDefault
          (
            defaultValue: mouseCursor,
            sourceValueName: mouseValue,
            propertySource: value,
            keyParameter: mouseValueParam
          ),
          //
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

  static Widget buildRadio<T>
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      required T checkedValue,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      MouseCursor? mouseCursor,
      String? mouseValue,
      dynamic mouseValueParam,
      //////////////
      bool toggleable = false,
      Color? activeColor,
      MaterialStateProperty<Color?>? fillColor,
      Color? focusColor,
      Color? hoverColor,
      MaterialStateProperty<Color?>? overlayColor,
      double? splashRadius,
      MaterialTapTargetSize? materialTapTargetSize,
      VisualDensity? visualDensity,
      FocusNode? focusNode,
      bool autofocus = false}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: <T>(context, v, child)
      {
        final value = v as ValueState<T?>;
        return Radio<T>
        (
          key: key,
          value: checkedValue as T,
          groupValue: value.read<T?>(bindValueParam),
          // onChanged event
          onChanged: binder.readOrDefault
          (
            defaultValue: enabled,
            sourceValueName: enabledValue,
            propertySource: value,
            keyParameter: enabledValueParam
          )
          ? (newValue) => value.value = newValue
          : null,
          // mouseCursor
          mouseCursor: binder.readOrDefault
          (
            defaultValue: mouseCursor,
            sourceValueName: mouseValue,
            propertySource: value,
            keyParameter: mouseValueParam
          ),
          //
          toggleable: toggleable,
          activeColor: activeColor,
          fillColor: fillColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor,
          splashRadius: splashRadius,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus
        );
      }
    );
  }

  static Widget buildRadioListTile<T>
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      required T checkedValue,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      bool toggleable = false,
      Color? activeColor,
      Widget? title,
      Widget? subtitle,
      bool isThreeLine = false,
      bool? dense,
      Widget? secondary,
      bool selected = false,
      ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
      bool autofocus = false,
      EdgeInsetsGeometry? contentPadding,
      ShapeBorder? shape,
      Color? tileColor,
      Color? selectedTileColor,
      VisualDensity? visualDensity,
      FocusNode? focusNode,
      bool? enableFeedback}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: <T>(context, v, child)
      {
        final value = v as ValueState<T?>;
        return RadioListTile<T>
        (
          key: key,
          value: checkedValue as T,
          groupValue: value.read<T?>(bindValueParam),
          // onChanged event
          onChanged: binder.readOrDefault
          (
            defaultValue: enabled,
            sourceValueName: enabledValue,
            propertySource: value,
            keyParameter: enabledValueParam
          )
          ? (newValue) => value.value = newValue
          : null,
          //
          toggleable: toggleable,
          activeColor: activeColor,
          title: title,
          subtitle: subtitle,
          isThreeLine: isThreeLine,
          dense: dense,
          secondary: secondary,
          selected: selected,
          controlAffinity: controlAffinity,
          autofocus: autofocus,
          contentPadding: contentPadding,
          shape: shape,
          tileColor: tileColor,
          visualDensity: visualDensity,
          focusNode: focusNode,
          enableFeedback: enableFeedback
        );
      }
    );
  }

  static Widget buildBasicRadioColumn<T>
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      required List<T> checkedValues,
      List<Widget>? titleWidgets,
      List<String>? titleTexts,
      //////////////
      bool enabled = true,
      String? enabledValue,
      dynamic enabledValueParam,
      //////////////
      bool toggleable = false,
      Color? activeColor,
      bool isThreeLine = false,
      bool? dense,
      Widget? secondary,
      bool selected = false,
      ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
      bool autofocus = false,
      EdgeInsetsGeometry? contentPadding,
      ShapeBorder? shape,
      Color? tileColor,
      Color? selectedTileColor,
      VisualDensity? visualDensity,
      FocusNode? focusNode,
      bool? enableFeedback}
  )
  {
    int count = math.max(titleWidgets?.length ?? 0, titleTexts?.length ?? 0);
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: <T>(context, v, child)
      {
        final value = v as ValueState<T?>;
        final children = <Widget>[];

        for (int i = 0; i < count; i++)
        {
          final title = i < (titleWidgets?.length ?? 0) ? titleWidgets![i] : Text(titleTexts![i]);
          children.add
          (
            RadioListTile<T>
            (
              key: key,
              value: checkedValues[i] as T,
              groupValue: value.read<T?>(bindValueParam),
              // onChanged event
              onChanged: binder.readOrDefault
              (
                defaultValue: enabled,
                sourceValueName: enabledValue,
                propertySource: value,
                keyParameter: enabledValueParam
              )
              ? (newValue) => value.value = newValue
              : null,
              //
              toggleable: toggleable,
              activeColor: activeColor,
              title: title,
              isThreeLine: isThreeLine,
              dense: dense,
              secondary: secondary,
              selected: selected,
              controlAffinity: controlAffinity,
              autofocus: autofocus,
              contentPadding: contentPadding,
              shape: shape,
              tileColor: tileColor,
              visualDensity: visualDensity,
              focusNode: focusNode,
              enableFeedback: enableFeedback
            )
          );
        }

        return Column(children: children);
      }
    );
  }

  static Widget buildTextField
  (
    BuildContext context,
    {required String bindValue,
      dynamic bindValueParam,
      //////////////
      Key? key,
      FocusNode? focusNode,
      InputDecoration? decoration = const InputDecoration(),
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      TextCapitalization textCapitalization = TextCapitalization.none,
      //////////////
      TextStyle? style,
      String? styleValue,
      dynamic styleParam,
      //////////////
      StrutStyle? strutStyle,
      String? bindStrutStyle,
      dynamic bindStrutStyleParam,
      //////////////
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      TextDirection? textDirection,
      bool readOnly = false,
      ToolbarOptions? toolbarOptions,
      bool? showCursor,
      bool autofocus = false,
      String obscuringCharacter = '•',
      //////////////
      bool obscureText = false,
      String? bindObscureText,
      dynamic bindObscureTextParam,
      //////////////
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      int? maxLines = 1,
      int? minLines,
      bool expands = false,
      int? maxLength,
      MaxLengthEnforcement? maxLengthEnforcement,
      AppPrivateCommandCallback? onAppPrivateCommand,
      List<TextInputFormatter>? inputFormatters,
      //////////////
      bool enabled = true,
      String? bindEnabled,
      dynamic bindEnabledParam,
      //////////////
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      //////////////
      MouseCursor? mouseCursor,
      String? bindMouseCursor,
      dynamic bindMouseCursorParam,
      //////////////
      InputCounterWidgetBuilder? buildCounter,
      ScrollController? scrollController,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints = const <String>[],
      Clip clipBehavior = Clip.hardEdge,
      String? restorationId,
      bool scribbleEnabled = true,
      bool enableIMEPersonalizedLearning = true}
  )
  {
    final binder = EventBinder.of(context);

    return binder[bindValue].buildWidget
    (
      context, //
      builder: <String>(context, v, child)
      {
        final value = v as ValueState<String>;
        final controller = value.setState
        (
          context: context, initializer: (context, value) => TextEditingController(text: value.readString())
        );

        return TextField
        (
          key: key,
          controller: controller,
          focusNode: focusNode,
          decoration: decoration,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: styleValue, propertySource: value, keyParameter: styleParam
          ),
          strutStyle: binder.readOrDefault
          (
            defaultValue: strutStyle,
            sourceValueName: bindStrutStyle,
            propertySource: value,
            keyParameter: bindStrutStyleParam
          ),
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textDirection: textDirection,
          readOnly: readOnly,
          toolbarOptions: toolbarOptions,
          showCursor: showCursor,
          autofocus: autofocus,
          obscuringCharacter: obscuringCharacter,
          obscureText: binder.readOrDefault
          (
            defaultValue: obscureText,
            sourceValueName: bindObscureText,
            propertySource: value,
            keyParameter: bindObscureTextParam
          ),
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
          onChanged: (data) => value.value = data as String,
          onEditingComplete: () => value.doEvent(event: StdValueProperty.onComplete),
          onSubmitted: (data) => value.doEvent(event: StdValueProperty.onSubmited, parameter: data),
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: binder.readOrDefault
          (
            defaultValue: enabled, sourceValueName: bindEnabled, propertySource: value, keyParameter: bindEnabledParam
          ),
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          selectionHeightStyle: selectionHeightStyle,
          selectionWidthStyle: selectionWidthStyle,
          keyboardAppearance: keyboardAppearance,
          scrollPadding: scrollPadding,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          selectionControls: selectionControls,
          onTap: value.doEvent(event: StdValueProperty.onTap),
          mouseCursor: binder.readOrDefault
          (
            defaultValue: mouseCursor,
            sourceValueName: bindMouseCursor,
            propertySource: value,
            keyParameter: bindMouseCursorParam
          ),
          buildCounter: buildCounter,
          scrollController: scrollController,
          scrollPhysics: scrollPhysics,
          autofillHints: autofillHints,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          scribbleEnabled: scribbleEnabled,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        );
      }
    );
  }
}

class IconButtonStyle
{
  double? iconSize;
  VisualDensity? visualDensity;
  EdgeInsetsGeometry? padding;
  AlignmentGeometry? alignment;
  double? splashRadius;
  Color? color;
  Color? focusColor;
  Color? hoverColor;
  Color? highlightColor;
  Color? splashColor;
  Color? disabledColor;

  IconButtonStyle
  (
    {this.iconSize,
      this.visualDensity,
      this.padding,
      this.alignment,
      this.splashRadius,
      this.color,
      this.focusColor,
      this.hoverColor,
      this.highlightColor,
      this.splashColor,
      this.disabledColor}
  );

  IconButtonStyle copyWith
  (
    {double? iconSize,
      VisualDensity? visualDensity,
      EdgeInsetsGeometry? padding,
      AlignmentGeometry? alignment,
      double? splashRadius,
      Color? color,
      Color? focusColor,
      Color? hoverColor,
      Color? highlightColor,
      Color? splashColor,
      Color? disabledColor}
  )
  {
    return IconButtonStyle
    (
      iconSize: iconSize ?? this.iconSize,
      visualDensity: visualDensity ?? this.visualDensity,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
      splashRadius: splashRadius ?? this.splashRadius,
      color: color ?? this.color,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      splashColor: splashColor ?? this.splashColor,
      disabledColor: disabledColor ?? this.disabledColor
    );
  }
}