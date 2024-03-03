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

/// -------------------------------------------------------------------------------
///                                                                                |
///  This class, DarkTheme, defines a static ThemeData instance named themeData,   |
///  which represents the dark theme configuration for the application.            |
///                                                                                |
///  Inside the themeData, the following configurations are set:                   |
///   - brightness is set to Brightness.dark to indicate a dark theme.             |
///   - primaryColor is set to Colors.grey as the primary color.                   |
///   - hintColor is set to Colors.grey[800] for hint text color.                  |
///   - scaffoldBackgroundColor is set to Colors.black for the background color of |
///     the scaffold.                                                              |
///   - appBarTheme is configured with a background color of Colors.grey[900] for  |
///     app bar.                                                                   |
///   - textTheme defines text styles for various text components, including body  |
///     text and titles, with white color.                                         |
///   - buttonTheme is configured with a buttonColor of Colors.grey[800] and       |
///     ButtonTextTheme.primary.                                                   |
///   - iconTheme sets the default color for icons to white.                       |
///   - dividerColor is set to Colors.grey[600] for dividers.                      |
///   - elevatedButtonTheme configures the style for ElevatedButton with a         |
///     background color of Colors.grey[800].                                      |
///   - cardTheme configures the color of cards to Colors.grey[900].               |
///                                                                                |
///  This class provides a convenient way to access and apply the dark theme       |
///  throughout the application.                                                   |
///                                                                                |
/// -------------------------------------------------------------------------------