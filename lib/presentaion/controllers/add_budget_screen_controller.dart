import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/models/monthly_data_model.dart';

class AddBudgetScreenController extends GetxController {
  final userController = Get.find<UserController>();

  void addBudget({required String budget, required String budgetName}) {
    if (userController.isNewUserOrNewYear) {
      addBudgetForNewUserOrNewYear(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName);
    } else if (userController.isNewMonth) {
      addBudgetForNewMonth(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName);
    } else if (userController.isNewDay) {
      addBudgetForNewDay(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName);
    } else if (userController.todayFlag) {
      addBudgetForToday(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName);
    } else {
      print("Error->Somthing Wrong");
    }
  }

  Future<void> addBudgetForToday(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName}) async {
    MonthlyDataModel? monthlyData;
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(year);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        monthlyData = MonthlyDataModel.fromDocumentSnapshot(doc);
        print(monthlyData?.dayList);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    Map<String, dynamic> todayBudget = {
      "BudgetName": budgetName,
      "BudgetAmount": budget,
      "AddedAt": DateTime.now()
    };

    if (monthlyData != null) {
      print(monthlyData?.dayList);
      monthlyData?.dayList.last?["Day-$day"]?["BudgetAdded"].add(todayBudget);
      print(monthlyData?.dayList);

      int? totalBudgetForThisMonth = monthlyData?.totalBudgetForThisMonth;
      if (totalBudgetForThisMonth != null) {
        totalBudgetForThisMonth += int.tryParse(budget) ?? 0;
        monthlyData?.dayList[0]["TotalBudget"] = totalBudgetForThisMonth;
      }
    }

    docRef.update({
      "Months": [
        {month: monthlyData?.dayList}
      ]
    });

    print("--------------------------------Today Budget Added");
  }

  Future<void> addBudgetForNewDay(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName}) async {
    MonthlyDataModel? monthlyData;
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(year);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        monthlyData = MonthlyDataModel.fromDocumentSnapshot(doc);
        print(monthlyData?.dayList);
      },
      onError: (e) => print("Error getting document: $e"),
    );

    Map<String, dynamic> newDay = {
      "Day-$day": {
        "BudgetAdded": [
          {
            "BudgetName": budgetName,
            "BudgetAmount": budget,
            "AddedAt": DateTime.now()
          }
        ],
        "Expanses": []
      }
    };

    if (monthlyData != null) {
      monthlyData?.dayList.add(newDay);
      int? totalBudgetForThisMonth = monthlyData?.totalBudgetForThisMonth;
      if (totalBudgetForThisMonth != null) {
        totalBudgetForThisMonth += int.tryParse(budget) ?? 0;
        monthlyData?.dayList[0]["TotalBudget"] = totalBudgetForThisMonth;
      }
    }

    docRef.update({
      "Months": [
        {month: monthlyData?.dayList}
      ]
    });

    print("--------------------------------Single day Budget Add");
    userController.makeNewDayFalse();
  }

  Future<void> addBudgetForNewUserOrNewYear(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName}) async {
    final firestore = FirebaseFirestore.instance;
    final dbRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(year);

    await dbRef.set({
      "Months": [
        {
          month: [
            {"TotalBudget": int.tryParse(budget)},
            {
              "Day-$day": {
                "BudgetAdded": [
                  {
                    "BudgetName": budgetName,
                    "BudgetAmount": budget,
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
    userController.makeNewYearOrNewUserFalse();
  }

  Future<void> addBudgetForNewMonth(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName}) async {
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
        {"TotalBudget": int.tryParse(budget)},
        {
          "Day-$day": {
            "BudgetAdded": [
              {
                "BudgetName": budgetName,
                "BudgetAmount": budget,
                "AddedAt": DateTime.now()
              }
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
    userController.makeNewMonthFalse();
  }
}
