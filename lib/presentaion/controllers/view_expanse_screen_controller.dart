import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/Data/controller/getDataController.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/Data/model/single_day_data_model.dart';

class ViewExpanseScreenController extends GetxController {
  RxBool isTodayIsSelected = true.obs;
  RxBool isInProgress = false.obs;
  RxBool addExpanseIsInProgress = false.obs;
  Rx<FullMonthDataModel>? monthlyData;
  Rx<SingleDayDataModel>? todaysData;

  void onClickTodayButton() {
    if (isTodayIsSelected.value == false) {
      isTodayIsSelected.value = true;
    }
  }

  void onClickMonthButton() {
    if (isTodayIsSelected.value == true) {
      isTodayIsSelected.value = false;
    }
  }

  Future<void> getMonthlyData() async {
    isInProgress.value = true;
    monthlyData = await Get.find<GetdataController>().getFullMonthData();
    isInProgress.value = false;
  }

  Future<void> getTodaysData() async {
    isInProgress.value = true;
    todaysData = await Get.find<GetdataController>().getSingleDayData();
    isInProgress.value = false;
  }

  Future<void> onClickAddExpanseButton(
      String amount, String expanseCause) async {
    addExpanseIsInProgress.value = true;

    await Get.find<AddExpnseController>().addExpanse(amount, expanseCause);
    addExpanseIsInProgress.value = false;
  }
}
