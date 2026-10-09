import 'package:animations/animations.dart';
import 'package:finance_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  //*==== Smooth shared-axis transition for every page route by default ====*/
  static const _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: SharedAxisPageTransitionsBuilder(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
    },
  );

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.background_light,
    primaryColor: AppColor.primary_color,
    dividerColor: AppColor.border_light,
    pageTransitionsTheme: _pageTransitions,
    colorScheme: const ColorScheme.light(
      primary: AppColor.primary_color,
      onPrimary: Colors.white,
      secondary: AppColor.mid_green_color,
      onSecondary: Colors.white,
      tertiary: AppColor.accent_gold,
      surface: AppColor.surface_light,
      onSurface: AppColor.text_dark,
      outline: AppColor.border_light,
      error: AppColor.loss_color,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.background_light,
      foregroundColor: AppColor.text_dark,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColor.surface_light,
      elevation: 0,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.background_dark,
    primaryColor: AppColor.primary_color,
    dividerColor: AppColor.border_dark,
    pageTransitionsTheme: _pageTransitions,
    colorScheme: const ColorScheme.dark(
      primary: AppColor.mid_green_color,
      onPrimary: Colors.white,
      secondary: AppColor.light_green_color,
      onSecondary: AppColor.dark_green_color,
      tertiary: AppColor.accent_gold,
      surface: AppColor.surface_dark,
      onSurface: AppColor.text_primary,
      surfaceContainerHighest: AppColor.surface_elevated,
      outline: AppColor.border_dark,
      error: AppColor.loss_color,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.background_dark,
      foregroundColor: AppColor.text_primary,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColor.surface_dark,
      elevation: 0,
    ),
  );
}
