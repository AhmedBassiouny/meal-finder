import 'package:flutter/material.dart';
import 'package:meal_finder/theme/cr_text_theme.dart';
import 'package:meal_finder/theme/w_color_scheme.dart';

final appTheme = AppTheme(wColors, crTextTheme);

class AppTheme {
  AppTheme(this.wColors, this.wTextTheme);

  final WColorScheme wColors;
  final TextTheme wTextTheme;

  ThemeData get themeData => ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: wColors.N100,
          foregroundColor: wColors.N800,
          titleTextStyle: wTextTheme.displaySmall,
        ),
        scaffoldBackgroundColor: wColors.N100,
        elevatedButtonTheme: ElevatedButtonThemeData(style: defaultButtonStyle),
        textTheme: wTextTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      );

  ButtonStyle get defaultButtonStyle => ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );
}
