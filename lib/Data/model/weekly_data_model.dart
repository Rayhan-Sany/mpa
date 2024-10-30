// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';

class WeeklyDataModel {
  List<Map<String, dynamic>> weeklyExpanseList;

  int totalExpanse;
  WeeklyDataModel({
    required this.weeklyExpanseList,
    required this.totalExpanse,
  });
  factory WeeklyDataModel.fromMonthlyData(
      FullMonthDataModel monthlyData, int week) {
    List<Map<String, dynamic>> expanseListForGivenWeek = [];
    int sum = 0;

    print('--------------------Weekly data model from monthly data');
    for (Map<String, dynamic> data in monthlyData.expansesList) {
      Timestamp timestamp = data["AddedAt"];
      int day = timestamp.toDate().day;
      if (day <= 7 && week == 1) {
        print("first Week");
        expanseListForGivenWeek.add(data);
        sum += int.tryParse(data["ExpanseAmount"]) ?? 0;
      } else if (day > 7 && day <= 14 && week == 2) {
        print("Second Week");
        expanseListForGivenWeek.add(data);
        sum += int.tryParse(data["ExpanseAmount"]) ?? 0;
      } else if (day > 14 && day <= 21 && week == 3) {
        print("Third Week");
        expanseListForGivenWeek.add(data);
        sum += int.tryParse(data["ExpanseAmount"]) ?? 0;
        print(sum);
      } else if (day > 21 && day <= 31 && week == 4) {
        print("last Week");
        expanseListForGivenWeek.add(data);
        sum += int.tryParse(data["ExpanseAmount"]) ?? 0;
      } else {
        if (week > 4) print("Somthing Wrong Week Out of bound-----");
      }
    }

    WeeklyDataModel weeklyData = WeeklyDataModel(
        weeklyExpanseList: expanseListForGivenWeek, totalExpanse: sum);
    return weeklyData;
  }
}
