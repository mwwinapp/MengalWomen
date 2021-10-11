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

ThemeData customTheme(bool isDark) {
  return ThemeData(
    //colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
    scaffoldBackgroundColor: appBackgroundColorPrimary,
    dialogBackgroundColor: appBackgroundColorPrimary,
    fontFamily: 'Aller',
    appBarTheme: AppBarTheme(
      backgroundColor: appColorPrimary,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'AllerBold',
      ),
      bodyText2: TextStyle(
        color: Colors.grey,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: appBackgroundColorPrimary,
      filled: true,
      isDense: true,
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: appColorPrimary),
      focusedBorder:OutlineInputBorder(
        borderSide: const BorderSide(color: appColorPrimary, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: appFontColorSecondary,
          width: 1.0,
        ),
      ),
      border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(35.0),),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(appColorPrimary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(color: appColorPrimary),
            ),
          )
      ),
    ),
    iconTheme: IconThemeData(
      color: appColorPrimary,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(appColorPrimary),
    ),
  );
}

/**/