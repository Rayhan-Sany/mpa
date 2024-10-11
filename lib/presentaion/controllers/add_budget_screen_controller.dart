import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';

class AddBudgetScreenController extends GetxController {
  final userController = Get.find<UserController>();

  void addBudget() {
    if (userController.isNewUserOrNewYear) {
      addBudgetForNewUserOrNewYear(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day);
    } else if (userController.isNewMonth) {
      addBudgetForNewMonth(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day);
    } else {
      print("Nothing-------------------");
    }
  }

  Future<void> addBudgetForNewUserOrNewYear(
      {required String year,
      required String month,
      required String day}) async {
    final firestore = FirebaseFirestore.instance;
    final dbRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(year);

    dbRef.set({
      "Months": [
        {
          month: [
            {"TotalBudget": 2000},
            {
              "Day-$day": {
                "BudgetAdded": [
                  {
                    "BudgetName": "",
                    "BudgetAmount": "",
                    "AddedAt": DateTime.now()
                  }
                ],
                "Expanses": []
              }
            }
          ]
        }
      ]
    });

    print("--------------------------------Brand New Budget Add");
  }

  Future<void> addBudgetForNewMonth(
      {required String year,
      required String month,
      required String day}) async {
    final firestore = FirebaseFirestore.instance;

    final dbRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(year);

    Map<String, dynamic> newMonth = {
      month: [
        {"TotalBudget": 2000},
        {
          "Day-$day": {
            "BudgetAdded": [
              {"BudgetName": "", "BudgetAmount": "", "AddedAt": DateTime.now()}
            ],
            "Expanses": []
          }
        }
      ]
    };

    dbRef.set({
      "Months": FieldValue.arrayUnion([newMonth])
    }, SetOptions(merge: true));

    print("-------------------------------- New Month Budget Add");
  }
}
