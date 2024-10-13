import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';

class FullMonthDataModel {
  List expansesList;
  int totalExpanse;
  int totalBudget;

  FullMonthDataModel(
      {required this.expansesList,
      required this.totalExpanse,
      required this.totalBudget});

  factory FullMonthDataModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List monthList = data["Months"];
    Map<String, dynamic> currentMonth = monthList.last;
    List dayList = currentMonth[CurrentDateTimeReturnModel.month];
    int totalBudget = dayList[0]["TotalBudget"];

    List dayDates = [];
    for (int i = 1; i < dayList.length; i++) {
      dayDates.add(dayList[i].keys.toString().trim());
    }
    List expanses = [];
    for (int i = 0; i < dayDates.length; i++) {
      dayDates[i] = dayDates[i].substring(1, dayDates[i].length - 1);
      expanses.add(dayList[i + 1][dayDates[i]]["Expanses"]);
    }
    List pureExpaneseList = [];
    int tempTotalExpanse = 0;
    for (int i = 0; i < expanses.length; i++) {
      for (int j = 0; j < expanses[i].length; j++) {
        pureExpaneseList.add(expanses[i][j]);
        tempTotalExpanse += int.tryParse(expanses[i][j]["ExpanseAmount"]) ?? 0;
      }
    }

    FullMonthDataModel monthlyDataModel = FullMonthDataModel(
        expansesList: pureExpaneseList,
        totalExpanse: tempTotalExpanse,
        totalBudget: totalBudget);

    return monthlyDataModel;
  }
}
