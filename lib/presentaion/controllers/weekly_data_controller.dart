// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:get/get.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';

import 'package:mpa/Data/model/weekly_data_model.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/widgets/app_snackbar.dart';

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
        if (CurrentDateTimeReturnModel.currentWeekNumber() == i) {
          double avgExpansePerWeekWithRespectToBudget =
              monthlyData.totalExpanse.value / 4;
          if (i == 1) {
            if (firstWeekExpancesData!.value.totalExpanse >
                avgExpansePerWeekWithRespectToBudget) {
              AppSnackbar.showAppSnackbar(
                  title: "Limit Exceeded ",
                  subtitle: "1s Week Expanse Excedded Avarge Limit",
                  isErrorSnak: true);
            }
          } else if (i == 2) {
            if (secondWeekExpancesData!.value.totalExpanse >
                avgExpansePerWeekWithRespectToBudget) {
              AppSnackbar.showAppSnackbar(
                  title: "Limit Exceeded ",
                  subtitle: "2nd Week Expanse Excedded Avarge Limit",
                  isErrorSnak: true);
            }
          } else if (i == 3) {
            if (thirdWeekExpancesData!.value.totalExpanse >
                avgExpansePerWeekWithRespectToBudget) {
              AppSnackbar.showAppSnackbar(
                  title: "Limit Exceeded ",
                  subtitle: "3rd Week Expanse Excedded Avarge Limit",
                  isErrorSnak: true);
            }
          } else {
            if (lastWeekExpancesData!.value.totalExpanse >
                avgExpansePerWeekWithRespectToBudget) {
              AppSnackbar.showAppSnackbar(
                  title: "Limit Exceeded ",
                  subtitle: "last Week Expanse Excedded Avarge Limit",
                  isErrorSnak: true);
            }
          }
        }
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
