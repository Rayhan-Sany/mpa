import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class UserController extends GetxController {
  bool isNewUserOrNewYear = false;
  bool isNewMonth = false;
  bool isNewDay = false;
  bool todayFlag = true;
  bool currentYearFlag = false;
  RxBool inProgress = false.obs;
  RxBool isCheckIsNewUserOrNewYearOrNewMonthIsRunSuccessFully = false.obs;
  static UserDetails? userDetails;

  Future<UserDetails?> getUserDetails(String? uid) async {
    inProgress.value = true;
    if (uid == null) {
      print("No User So Null Assigning in Userdetails");
      return null;
    }

    final firestore = FirebaseFirestore.instance;
    final dbRef = firestore.collection("users").doc(uid);
    // UserDetails? userDetails;
    await dbRef.get().then((documentSnapshot) {
      final Map<String, dynamic> userDetailsMap =
          documentSnapshot.data() as Map<String, dynamic>;
      print(userDetailsMap);
      userDetails = UserDetails.fromMap(userDetailsMap);
    }, onError: (e) => print("Error completing: $e"));

    inProgress.value = false;

    return userDetails;
  }

  void setUserDataFromLocalStorage() async {
    inProgress.value = true;
    userDetails = await LocalStorageController.getLocalUserDetails();
    inProgress.value = false;
  }

  Future<bool> checkIsNewUserOrNewYearOrNewMonth({required String uid}) async {
    inProgress.value = true;
    final firestore = FirebaseFirestore.instance;
    final dbRef = firestore
        .collection("users")
        .doc(uid)
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
              // ignore: unused_local_variable
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
    } on SocketException catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "No Internet", subtitle: "Somthing Wrong $e");
    } catch (e) {
      if (e.toString() == "Bad state: No element") {
        print("${e.toString}-----------------");
        if (currentYearFlag == false) {
          Get.to(() => const AddBudgetScreen());
          isNewUserOrNewYear = true;
          update();
        }

        print(e.toString() + isNewUserOrNewYear.toString());
      }
    }
    inProgress.value = false;
    isCheckIsNewUserOrNewYearOrNewMonthIsRunSuccessFully.value = true;
    return isCheckIsNewUserOrNewYearOrNewMonthIsRunSuccessFully.value;
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
}
