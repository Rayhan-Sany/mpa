import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/ui/auth/sign_up_screen.dart';
import 'package:mpa/widgets/appPrimaryAppBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  LoginScreenController loginScreenController =
      Get.find<LoginScreenController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppPrimaryAppBar(),
            SizedBox(height: 70),
            Padding(
                padding: EdgeInsets.all(16),
                child: loginForm(
                    _emailTEController, _passwordTEController, context)),
          ],
        ),
      ),
    );
  }

  Form loginForm(TextEditingController _emailTEController,
      TextEditingController _passwordTEController, BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Your Email And Password",
            style: AppFontStyles.playfairDisplay700S30,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailTEController,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined), hintText: "Email"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordTEController,
            onTapOutside: (event) {},
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock), hintText: "Password"),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.maxFinite,
            child: GetBuilder<LoginScreenController>(
                builder: (loginScreenController) {
              return Visibility(
                visible: loginScreenController.isInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    if (_emailTEController.text.trim().isNotEmpty &&
                        _passwordTEController.text.trim().isNotEmpty)
                      loginScreenController.loginUser(
                          _emailTEController.text.trim(),
                          _passwordTEController.text.trim());
                  },
                  child: Text("Sign in"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: (MediaQuery.of(context).size.width - 100) / 2,
                  child: Divider(
                    height: 5,
                  )),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Or"),
              ),
              SizedBox(
                  width: (MediaQuery.of(context).size.width - 100) / 2,
                  child: Divider(
                    height: 0,
                  )),
            ],
          ),
          SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(SignUpScreen());
                  },
                  child: Text("Create Account")))
        ],
      ),
    );
  }
}
