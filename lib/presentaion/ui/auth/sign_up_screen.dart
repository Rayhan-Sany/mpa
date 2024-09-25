import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/controllers/sign_up_screen.dart';
import 'package:mpa/widgets/appPrimaryAppBar.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameTEController = TextEditingController();
    TextEditingController emailTEController = TextEditingController();
    TextEditingController passwordTEController = TextEditingController();
    TextEditingController confirmPasswordTEController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppPrimaryAppBar(),
            const SizedBox(height: 50),
            Padding(
                padding: const EdgeInsets.all(16),
                child: signUpForm(formKey, nameTEController, emailTEController,
                    passwordTEController, confirmPasswordTEController)),
          ],
        ),
      ),
    );
  }

  Form signUpForm(
      GlobalKey<FormState> formKey,
      TextEditingController nameTEController,
      TextEditingController emailTEController,
      TextEditingController passwordTEController,
      TextEditingController confirmPasswordTEController) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Create Your Account",
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor)),
          const SizedBox(height: 20),
          TextField(
            controller: nameTEController,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person), hintText: "Name"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailTEController,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined), hintText: "Email"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordTEController,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock), hintText: "Password"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: confirmPasswordTEController,
            validator: (value) {
              if (passwordTEController.text.trim() !=
                  confirmPasswordTEController.text.trim()) {
                return "Password Does Not Match";
              }
              return null;
            },
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock), hintText: "Confirm Password"),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.maxFinite,
            child: GetBuilder<SignUPScreenController>(
                builder: (signUPScreenController) {
              return Visibility(
                visible: signUPScreenController.isInProgress == false,
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final signUpController =
                          Get.find<SignUPScreenController>();
                      signUpController.createUser(
                          emailTEController.text.toString().trim(),
                          passwordTEController.text.toString().trim(),
                          nameTEController.text.toString().trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Sign Up"),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
