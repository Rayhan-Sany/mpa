import 'package:flutter/material.dart';
import 'package:mpa/app/utils/app_color.dart';

class AppFontStyles {
  static TextStyle get playfairDisplay700S30 => const TextStyle(
      fontSize: 30,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
      color: AppColor.primaryColor,
      fontFamily: "PlayfairDisplay");
  static TextStyle get playfairDisplay400S15 => const TextStyle(
      fontSize: 15, color: AppColor.blackColor, fontFamily: "PlayfairDisplay");

  static TextStyle get playfairDisplay600S20 => const TextStyle(
      fontSize: 20,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
      color: AppColor.primaryColor,
      fontFamily: "PlayfairDisplay");
}
