import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/ui/auth/login_screen.dart';

class SignOutController extends GetxController {
  void signOut() {
    print("------------------------------SignOut");
    LocalStorageController.deleteUserDetails();
    Get.offAll(() => const LoginScreen());
  }
}
