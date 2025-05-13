import 'package:flutter/material.dart';

import 'app_colors.dart'; // Make sure AppColors is defined here

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: AppColors.appColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.appColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.appColor),
      titleTextStyle: TextStyle(
        color: AppColors.appColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.appColor),
      bodyMedium: TextStyle(color: AppColors.appColor),
      bodySmall: TextStyle(color: AppColors.appColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.appColor,
        textStyle: const TextStyle(color: Colors.white),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: false,
    primaryColor: AppColors.appColor,
    scaffoldBackgroundColor: AppColors.appColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appColor,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.appColor,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: AppColors.appColor),
      ),
    ),
  );
}
