import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/Data/controller/get_data_controller.dart';
import 'package:mpa/presentaion/controllers/predefinelist_screen_controller.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/controllers/login_screen_controller.dart';
import 'package:mpa/presentaion/controllers/sign_up_screen_controller.dart';
import 'package:mpa/presentaion/controllers/signout_controller.dart';
import 'package:mpa/presentaion/controllers/track_expanse_screen_controller.dart';
import 'package:mpa/presentaion/controllers/update_profile_controller.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/controllers/view_expanse_screen_controller.dart';
import 'package:mpa/presentaion/controllers/weekly_data_controller.dart';

import 'Data/controller/add_budget_screen_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUPScreenController());
    Get.put(LoginScreenController());
    Get.put(SignOutController());
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => AddBudgetScreenController());
    Get.lazyPut(() => AddExpnseController(), fenix: true);
    Get.put(GetdataController());
    Get.lazyPut(() => ViewExpanseScreenController(), fenix: true);
    Get.lazyPut(() => TrackExpanseScreenController(), fenix: true);
    Get.lazyPut(() => LocalStorageController(), fenix: true);
    Get.lazyPut(() => UpdateProfileController(), fenix: true);
    Get.lazyPut(() => WeeklyDataController(), fenix: true);
    Get.lazyPut(() => PredefineListScreenController(), fenix: true);
  }
}
