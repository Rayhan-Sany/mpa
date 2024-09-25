import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/controllers/sign_up_screen.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUPScreenController());
    Get.put(LoginScreenController());
  }
}
