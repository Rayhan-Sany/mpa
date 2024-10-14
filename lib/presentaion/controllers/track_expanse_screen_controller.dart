import 'package:get/get.dart';
import 'package:mpa/Data/controller/getDataController.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';

class TrackExpanseScreenController extends GetxController {
  RxBool isInProgress = false.obs;
  Rx<FullMonthDataModel>? monthlyData;
  @override
  void onInit() async {
    super.onInit();
    isInProgress.value = true;
    Get.find<UserController>();
    fetchFullMonthData();
    isInProgress.value = false;
  }

  Future<void> fetchFullMonthData() async {
    isInProgress.value = true;
    monthlyData = await Get.find<GetdataController>().getFullMonthData();
    isInProgress.value = false;
  }

  String? getTotalExpanseInWeek({required int weekNumberInInt}) {
    return null;
  }
}
