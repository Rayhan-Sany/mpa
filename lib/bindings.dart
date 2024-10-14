import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/Data/controller/getDataController.dart';
import 'package:mpa/presentaion/controllers/add_budget_screen_Controller.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/controllers/sign_up_screen.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/controllers/view_expanse_screen_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUPScreenController());
    Get.put(LoginScreenController());
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => AddBudgetScreenController());
    Get.lazyPut(() => AddExpnseController(), fenix: true);
    Get.put(GetdataController());
    Get.lazyPut(() => ViewExpanseScreenController(), fenix: true);
  }
}
