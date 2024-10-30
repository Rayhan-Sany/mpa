import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/models/monthly_data_model.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class AddBudgetScreenController extends GetxController {
  final userController = Get.find<UserController>();
  RxBool isInProgress = false.obs;

  Future<void> addBudget(
      {required String budget, required String budgetName}) async {
    isInProgress.value = true;
    String uid = UserController.userDetails!.uid;
    if (userController.isNewUserOrNewYear) {
      await addBudgetForNewUserOrNewYear(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName,
          uid: uid);
    } else if (userController.isNewMonth) {
      await addBudgetForNewMonth(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName,
          uid: uid);
    } else if (userController.isNewDay) {
      await addBudgetForNewDay(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName,
          uid: uid);
    } else if (userController.todayFlag) {
      await addBudgetForToday(
          year: CurrentDateTimeReturnModel.year,
          month: CurrentDateTimeReturnModel.month,
          day: CurrentDateTimeReturnModel.day,
          budget: budget,
          budgetName: budgetName,
          uid: uid);
    } else {
      print("Error->Somthing Wrong");
    }

    isInProgress.value = false;
  }

  Future<void> addBudgetForToday(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName,
      required String uid}) async {
    MonthlyDataModel? monthlyData;
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("users")
        .doc(uid)
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(year);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        monthlyData = MonthlyDataModel.fromDocumentSnapshot(doc);
        print(monthlyData?.dayList);
      },
      onError: (e) => print("Somthing Wrong => $e"),
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
    }).then(
      (value) {
        AppSnackbar.showAppSnackbar(
            title: "Successfully Added", subtitle: "Budget Added Successfully");
      },
      onError: (e) => AppSnackbar.showAppSnackbar(
          title: "Faild",
          subtitle: "Budget Added Failed : $e",
          isErrorSnak: true),
    );

    print("--------------------------------Today Budget Added");
  }

  Future<void> addBudgetForNewDay(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName,
      required String uid}) async {
    MonthlyDataModel? monthlyData;
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("users")
        .doc(uid)
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
    }).then((value) {
      AppSnackbar.showAppSnackbar(
          title: "Successfully Added", subtitle: "Budget Added Successfully");
    },
        onError: (e) => AppSnackbar.showAppSnackbar(
            title: "Faild",
            subtitle: "Budget Added Failed : $e",
            isErrorSnak: true));

    print("--------------------------------Single day Budget Add");
    userController.makeNewDayFalse();
  }

  Future<void> addBudgetForNewUserOrNewYear(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName,
      required String uid}) async {
    final firestore = FirebaseFirestore.instance;
    final dbRef = firestore
        .collection("users")
        .doc(uid)
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
    }).then((value) {
      AppSnackbar.showAppSnackbar(
          title: "Successfully Added", subtitle: "Budget Added Successfully");
    },
        onError: (e) => AppSnackbar.showAppSnackbar(
            title: "Faild",
            subtitle: "Budget Added Failed : $e",
            isErrorSnak: true));

    print("--------------------------------Brand New Budget Add");
    userController.makeNewYearOrNewUserFalse();
  }

  Future<void> addBudgetForNewMonth(
      {required String year,
      required String month,
      required String day,
      required String budget,
      required String budgetName,
      required String uid}) async {
    final firestore = FirebaseFirestore.instance;

    final dbRef = firestore
        .collection("users")
        .doc(uid)
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
    }, SetOptions(merge: true)).then((value) {
      AppSnackbar.showAppSnackbar(
          title: "Successfully Added", subtitle: "Budget Added Successfully");
    },
        onError: (e) => AppSnackbar.showAppSnackbar(
            title: "Faild",
            subtitle: "Budget Added Failed : $e",
            isErrorSnak: true));

    print("-------------------------------- New Month Budget Add");
    userController.makeNewMonthFalse();
  }
}
