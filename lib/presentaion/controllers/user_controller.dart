import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/ui/screens/add_budget_screen.dart';

class UserController extends GetxController {
  RxBool newUser = RxBool(false);

  Future<void> isNewUser() async {
    final firebaseFirestore = FirebaseFirestore.instance;
    final querySnapshot =
        await firebaseFirestore.collection("ExpanseData").get();

    newUser.value = querySnapshot.docs.isEmpty;
    update();
    if (newUser.isTrue) {
      Get.to(const AddBudgetScreen());
    }
  }
}
