import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String usertype = 'admin';
const String appFont = 'Aller';
const String appFontBold = 'AllerBold';
const Color appFontColorPrimary = Colors.black;//Colors.white;
const Color appFontColorSecondary = Colors.grey;
const Color appColorPrimary = Color.fromARGB(255, 0, 50, 150);//Color.fromARGB(255, 0, 90, 225);
const Color appBackgroundColorPrimary = Colors.white;//Color.fromARGB(255, 25, 25, 25);
const Color appBackgroundColorSecondary = Colors.white;//Color.fromARGB(255, 40, 40, 40);

TextStyle customTextStyle({String fontFamily = appFont, double fontSize = 14.0, Color color = appFontColorPrimary, FontWeight fontWeight = FontWeight.normal, overflow = TextOverflow.ellipsis, double letterSpacing = 0.0, TextDecoration decoration = TextDecoration.none}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    overflow: overflow,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

