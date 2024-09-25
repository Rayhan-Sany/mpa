import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/ui/auth/login_screen.dart';

class SignUPScreenController extends GetxController {
  bool isInProgress = false;
  Future<void> createUser(String email, String password, String name) async {
    final _auth = FirebaseAuth.instance;
    isInProgress = true;
    update();
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      print(userCredential.user);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      isInProgress = false;
      update();
      Get.snackbar(
        'Sign in Success',
        'Account created successfully!',
        backgroundColor: Colors.green,
        colorText: AppColor.textColor,
      );

      Get.offAll(const LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        isInProgress = false;
        update();
        Get.snackbar(
          'Sign in Failed',
          'The email address is already in use.',
          backgroundColor: Colors.red,
          colorText: AppColor.textColor,
        );
      } else {
        isInProgress = false;
        update();
        Get.snackbar(
          'Sign in Failed',
          e.message ?? 'An error occurred.',
          backgroundColor: Colors.red,
          colorText: AppColor.textColor,
        );
      }
    } catch (e) {
      isInProgress = false;
      update();
      print(e.toString());
      Get.snackbar(
        'Sign in Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: AppColor.textColor,
      );
    }
  }
}
