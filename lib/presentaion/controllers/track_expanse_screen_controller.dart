import 'package:get/get.dart';
import 'package:mpa/Data/controller/get_data_controller.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/controllers/weekly_data_controller.dart';

class TrackExpanseScreenController extends GetxController {
  RxBool isInProgress = false.obs;
  Rx<FullMonthDataModel>? monthlyData;
  @override
  void onInit() async {
    super.onInit();
    await fetchFullMonthData();
  }

  Future<void> fetchFullMonthData() async {
    isInProgress.value = true;

    final userDetails = await LocalStorageController.getLocalUserDetails();

    final userController = Get.find<UserController>();

    bool isCheckIsNewUserOrNewYearOrNewMonthIsRunSuccessFully =
        await userController.checkIsNewUserOrNewYearOrNewMonth(
            uid: userDetails.uid);

    if (userController.isNewUserOrNewYear != true &&
        userController.isNewMonth != true &&
        isCheckIsNewUserOrNewYearOrNewMonthIsRunSuccessFully == true) {
      monthlyData = await Get.find<GetdataController>().getFullMonthData();
    }

    Get.find<WeeklyDataController>().weeklyData(monthlyData?.value);

    isInProgress.value = false;
  }

  String? getTotalExpanseInWeek({required int weekNumberInInt}) {
    return null;
  }
}
