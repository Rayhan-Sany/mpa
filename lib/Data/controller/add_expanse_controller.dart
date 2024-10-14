import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/models/monthly_data_model.dart';

class AddExpnseController extends GetxController {
  RxBool inProgress = false.obs;
  Future<void> addExpanse(String amount, String expanseCause) async {
    inProgress.value = true;
    MonthlyDataModel? monthlyData;
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(CurrentDateTimeReturnModel.year);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        monthlyData = MonthlyDataModel.fromDocumentSnapshot(doc);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    Map<String, dynamic> newExpanse = {
      "ExpanseCause": expanseCause,
      "ExpanseAmount": amount,
      "AddedAt": DateTime.now()
    };

    if (monthlyData != null) {
      print("------------------------------------");
      print(monthlyData?.dayList);
      if (monthlyData?.dayList.last.keys !=
          "(Day-${CurrentDateTimeReturnModel.day})") {
        print(monthlyData?.dayList.last.keys);
        monthlyData?.dayList.add({
          "Day-${CurrentDateTimeReturnModel.day}": {
            "Expanses": [],
            "BudgetAdded": []
          }
        });
        print("-----------------------------Day add korte hobe");
      }
      monthlyData
          ?.dayList.last?["Day-${CurrentDateTimeReturnModel.day}"]?["Expanses"]
          .add(newExpanse);
      print(monthlyData?.dayList);
    }

    docRef.update({
      "Months": [
        {CurrentDateTimeReturnModel.month: monthlyData?.dayList}
      ]
    });
    inProgress.value = false;
  }
}
