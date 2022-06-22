import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
          style: binder.readOrDefault
          (
            defaultValue: style, sourceValueName: bindStyle, propertySource: value, keyParameter: bindStyleParam
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
          ? (v) => (value.doEvent(event: null, parameter: v))
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
}