import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyDataModel {
  final List dayList;
  final List monthList;
  int totalBudgetForThisMonth;
  MonthlyDataModel(
      {required this.dayList,
      required this.monthList,
      required this.totalBudgetForThisMonth});
  factory MonthlyDataModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List monthList = data["Months"];
    Map<String, dynamic> currentMonth = monthList.last;
    List dayList = currentMonth[currentMonth.keys.last.toString()];
    int totalBudget = dayList[0]["TotalBudget"];
    MonthlyDataModel monthlyDataModel = MonthlyDataModel(
        monthList: monthList,
        dayList: dayList,
        totalBudgetForThisMonth: totalBudget);

    return monthlyDataModel;
  }
}
