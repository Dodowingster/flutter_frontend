import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey,
    hintColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey[800],
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.grey[600],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[900],
    ),
  );
}
