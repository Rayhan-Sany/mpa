import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/presentaion/ui/screens/homscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController extends GetxController {
  bool isInProgress = false;
  bool isLoggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  onInit() {
    super.onInit();
    isAlreadyLoggedIn();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isInProgress = true;
      update();
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        final storage = await SharedPreferences.getInstance();
        await storage.setString('token', token);
      }

      isInProgress = false;
      update();
      Get.snackbar(
        'Login Success',
        'Login successfully!',
        backgroundColor: AppColor.successColor,
        colorText: AppColor.textColor,
      );
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      isInProgress = false;
      update();
      Get.snackbar(
        'Login Failed',
        e.message ?? 'An unknown error occurred',
        backgroundColor: AppColor.errorColor,
        colorText: AppColor.textColor,
      );
      print(e);
    } catch (e) {
      isInProgress = false;
      print(e.toString());
      update();
      Get.snackbar(
        'Login Failed',
        'An error occurred. Please try again.',
        backgroundColor: AppColor.errorColor,
        colorText: AppColor.textColor,
      );
    }
  }

  Future<void> isAlreadyLoggedIn() async {
    final storage = await SharedPreferences.getInstance();
    String? token = storage.getString('token');

    print(token);
    if (token != null) {
      isLoggedIn = true;
      update();
    }
  }
}
