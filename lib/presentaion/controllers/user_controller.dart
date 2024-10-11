import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';

class UserController extends GetxController {
  bool isNewUserOrNewYear = false;
  bool isNewMonth = false;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await checkIsNewUserOrNewYear();
    if (isNewUserOrNewYear || isNewMonth) {
      Get.to(const AddBudgetScreen());
    }
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
            bool isNewUserOrNewYear = true;
            update();
            return;
          } else {
            bool isCurrentYear =
                querySnapshot.docs.last.id == DateTime.now().year.toString();
            if (isCurrentYear) {
              for (var docSnapshot in querySnapshot.docs) {
                Map<String, dynamic> currentYearData =
                    querySnapshot.docs.last.data();

                print(currentYearData);
                List monthList = currentYearData["Months"];

                print(monthList.last);
                Map<String, dynamic> currentMonth = monthList.last;
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
        bool isNewUserOrNewYear = true;
        update();
        print(e.toString() + isNewUserOrNewYear.toString());
      }
    }
  }
}
