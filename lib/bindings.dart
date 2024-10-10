import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/add_budget_screen_Controller.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/controllers/sign_up_screen.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUPScreenController());
    Get.put(LoginScreenController());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => AddBudgetScreenController());
  }
}
