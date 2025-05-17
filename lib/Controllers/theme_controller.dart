import 'package:flutter/material.dart';
import 'package:love14/utils/app_colors.dart';


class ThemeController with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryYellow,
      secondary: AppColors.primaryPink,
      surface: AppColors.lightBackground,
      background: AppColors.lightBackground,
    ),
    useMaterial3: true,
    fontFamily: 'Lora',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkText),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryYellow,
      secondary: AppColors.primaryPink,
      surface: AppColors.darkBackground,
      background: AppColors.darkBackground,
    ),
    useMaterial3: true,
    fontFamily: 'Lora',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.lightText,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.lightText),
    ),
  );
}
