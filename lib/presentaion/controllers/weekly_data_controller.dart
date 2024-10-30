// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:get/get.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';

import 'package:mpa/Data/model/weekly_data_model.dart';

class WeeklyDataController extends GetxController {
  Rx<WeeklyDataModel>? firstWeekExpancesData =
      WeeklyDataModel(weeklyExpanseList: [], totalExpanse: 0).obs;
  Rx<WeeklyDataModel>? secondWeekExpancesData =
      WeeklyDataModel(weeklyExpanseList: [], totalExpanse: 0).obs;
  Rx<WeeklyDataModel>? thirdWeekExpancesData =
      WeeklyDataModel(weeklyExpanseList: [], totalExpanse: 0).obs;
  Rx<WeeklyDataModel>? lastWeekExpancesData =
      WeeklyDataModel(weeklyExpanseList: [], totalExpanse: 0).obs;

  void weeklyData(FullMonthDataModel? monthlyData) {
    print("-----------------------I am inside WeeklyData Controller");
    if (monthlyData != null) {
      for (int i = 1; i <= 4; i++) {
        WeeklyDataModel weeklyData =
            WeeklyDataModel.fromMonthlyData(monthlyData, i);
        switch (i) {
          case 1:
            firstWeekExpancesData?.value = weeklyData;
            break;
          case 2:
            secondWeekExpancesData?.value = weeklyData;
            break;
          case 3:
            thirdWeekExpancesData?.value = weeklyData;

            break;
          case 4:
            lastWeekExpancesData?.value = weeklyData;
            break;
        }
      }
    } else {
      print("i am getting empty fullmonth Data");
    }
  }
}
