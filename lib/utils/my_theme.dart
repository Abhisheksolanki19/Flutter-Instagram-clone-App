import 'package:flutter/material.dart';

import 'colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
        scaffoldBackgroundColor: lightMobileBackgroundColor,
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(255, 37, 36, 36),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.grey,
          selectionHandleColor: Colors.black,
        ),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light)
            .copyWith(secondary: Colors.grey),
      );

  static ThemeData darkTheme() => ThemeData(
        scaffoldBackgroundColor: mobileBackgroundColor,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: Colors.grey),
        primarySwatch: Colors.grey,
        primaryColor: Colors.white,
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.grey,
          selectionHandleColor: Colors.black,
        ),
      );

// //Colors
//   static Color creamColor = const Color(0xfff5f5f5);
//   static Color darkCreamColor = Vx.gray900;
//   static Color darkBluishColor = const Color(0xff403b58);
//   static Color lightBluishColor = Vx.indigo500;
}
