import 'package:flutter/material.dart';
import 'package:mpa/app/utils/app_color.dart';

class AppThemeData {
  static ThemeData light() {
    return ThemeData(
        useMaterial3: true,
        fontFamily: "PlayfairDisplay",
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: AppColor.primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          foregroundColor: AppColor.textColor,
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppColor.primaryColor, width: 1),
            ),
            prefixIconColor: AppColor.primaryColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 0)));
  }
}
