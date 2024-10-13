import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';

class UserController extends GetxController {
  bool isNewUserOrNewYear = false;
  bool isNewMonth = false;
  bool isNewDay = false;
  bool todayFlag = true;
  bool currentYearFlag = false;
  @override
  void onInit() async {
    super.onInit();
    await checkIsNewUserOrNewYear();
    stayOrMoveToAddBudgetScreen();
  }

  void stayOrMoveToAddBudgetScreen() {
    if (isNewUserOrNewYear || isNewMonth) {
      Get.to(const AddBudgetScreen());
    }
  }

  void makeNewYearOrNewUserFalse() {
    isNewUserOrNewYear = false;
    update();
  }

  void makeNewMonthFalse() {
    isNewMonth = false;
    update();
  }

  void makeNewDayFalse() {
    isNewDay = false;
    update();
  }

  Future<void> checkIsNewUserOrNewYear() async {
    final firestore = FirebaseFirestore.instance;
    final dbRef = firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years");
    try {
      await dbRef.get().then(
        (querySnapshot) {
          print("Successfully completed");
          if (querySnapshot.isBlank ?? false) {
            isNewUserOrNewYear = true;
            update();
            return;
          } else {
            currentYearFlag =
                querySnapshot.docs.last.id == DateTime.now().year.toString();
            if (currentYearFlag) {
              print(
                  "---------------------------------------------- $currentYearFlag");
              for (var docSnapshot in querySnapshot.docs) {
                Map<String, dynamic> currentYearData =
                    querySnapshot.docs.last.data();

                print(currentYearData);
                List monthList = currentYearData["Months"];
                if (monthList.isEmpty) {
                  isNewMonth = true;
                  update();
                }
                print(monthList.last);
                Map<String, dynamic> currentMonth = monthList.last;
                List dayList = currentMonth[currentMonth.keys.last.toString()];
                Map<String, dynamic> currentDay = dayList.last;
                bool isSameDay = currentDay.keys.last ==
                    "Day-${CurrentDateTimeReturnModel.day}";
                print("-----------is Same Day ---- $isSameDay:" +
                    currentDay.keys.last);
                if (!isSameDay) {
                  isNewDay = true;
                  todayFlag = false;
                  update();
                }
                bool isSameMonth = currentMonth.keys.last.toString() ==
                    CurrentDateTimeReturnModel.month;
                if (!isSameMonth) {
                  isNewMonth = true;
                  update();
                }
              }
            }

            return;
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    } catch (e) {
      if (e.toString() == "Bad state: No element") {
        if (currentYearFlag == false) isNewUserOrNewYear = true;
        update();

        print(e.toString() + isNewUserOrNewYear.toString());
      }
    }
  }
}
