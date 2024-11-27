import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/ui/auth/login_screen.dart';
import 'package:mpa/presentaion/ui/screens/homscreen.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Lottie.asset(
              "assets/animation/splash.json",
              errorBuilder: (context, error, stackTrace) {
                debugPrint("Error loading Lottie animation: $error");
                return const Text("Connection Error");
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(height: 100, child: Image.asset(AssetsPath.baseLogo)),
          const Spacer(),
          Text("Version: 1.0.0",
              style: AppFontStyles.playfairDisplay400S15
                  .copyWith(color: AppColor.textColor.withOpacity(0.5))),
          const SizedBox(height: 8)
        ],
      ),
    );
  }

  moveToNextScreen() async {
    await Get.find<LoginScreenController>().isAlreadyLoggedIn();
    bool isLoggedIn = Get.find<LoginScreenController>().isLoggedIn;
    Timer(
        const Duration(seconds: 3),
        () => isLoggedIn
            ? Get.to(const HomePage())
            : Get.to(const LoginScreen()));
  }
}
