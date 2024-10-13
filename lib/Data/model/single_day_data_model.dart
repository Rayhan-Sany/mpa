import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';

class SingleDayDataModel {
  List expansesList;
  int totalExapanse;
  SingleDayDataModel({required this.expansesList, required this.totalExapanse});
  List get getExpansesList => expansesList;
  int get getTodayTotalExapanse => totalExapanse;

  factory SingleDayDataModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List monthList = data["Months"];
    Map<String, dynamic> currentMonth = monthList.last;
    List dayList = currentMonth[CurrentDateTimeReturnModel.month];

    Map<String, dynamic> today = dayList.last;

    List expansesList = [];
    expansesList =
        today["Day-${CurrentDateTimeReturnModel.day}"]?["Expanses"] ?? [];

    int totalExpanse = 0;
    for (int i = 0; i < expansesList.length; i++) {
      totalExpanse += int.tryParse(expansesList[i]["ExpanseAmount"]) ?? 0;
    }
    SingleDayDataModel TodaysData = SingleDayDataModel(
        expansesList: expansesList, totalExapanse: totalExpanse);

    return TodaysData;
  }
}
