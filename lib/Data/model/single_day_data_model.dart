import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';

class SingleDayDataModel {
  RxList expansesList;
  RxInt totalExapanse;
  SingleDayDataModel({required this.expansesList, required this.totalExapanse});
  List get getExpansesList => expansesList;
  int get getTodayTotalExapanse => totalExapanse.value;

  factory SingleDayDataModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List monthList = data["Months"];
    Map<String, dynamic> currentMonth = monthList.last;
    List dayList = currentMonth[CurrentDateTimeReturnModel.month];

    Map<String, dynamic> today = dayList.last;

    RxList expansesList = [].obs;
    expansesList.value =
        today["Day-${CurrentDateTimeReturnModel.day}"]?["Expanses"] ?? [];

    RxInt totalExpanse = 0.obs;
    for (int i = 0; i < expansesList.length; i++) {
      totalExpanse.value += int.tryParse(expansesList[i]["ExpanseAmount"]) ?? 0;
    }
    SingleDayDataModel todaysData = SingleDayDataModel(
        expansesList: expansesList, totalExapanse: totalExpanse);

    return todaysData;
  }
}
