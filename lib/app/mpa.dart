import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/theme/app_theme_data.dart';
import 'package:mpa/bindings.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/ui/auth/login_screen.dart';
import 'package:mpa/presentaion/ui/screens/homscreen.dart';

class MyPersonalAssistant extends StatelessWidget {
  const MyPersonalAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    final loginScreenController = Get.put(LoginScreenController());
    loginScreenController.isAlreadyLoggedIn();
    return GetMaterialApp(
      title: "My Personal Assistant",
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      theme: AppThemeData.light(),
      home: GetBuilder<LoginScreenController>(builder: (loginScreenController) {
        return loginScreenController.isLoggedIn
            ? const HomePage()
            : const LoginScreen();
      }),
    );
  }
}
