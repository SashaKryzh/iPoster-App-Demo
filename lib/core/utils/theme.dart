import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';

ThemeData get theme {
  return ThemeData(
    // To remove flutter splash effect
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    // end ---
    errorColor: Palette.red,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.white,
    accentColor: Palette.green,
    scaffoldBackgroundColor: Palette.scaffoldBackground,
    dividerColor: Palette.blackLight,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      buttonColor: Palette.green,
      height: 40,
      // To remove flutter splash effect
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      // end ---
    ),
    textButtonTheme: TextButtonThemeData(
      // To remove flutter splash effect
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((_) => Colors.transparent),
      ),
      // end ---
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    )
  );
}

TextStyle get linkTextStyle {
  return theme.textTheme.caption.copyWith(
    fontSize: 14,
    decoration: TextDecoration.underline,
  );
}
