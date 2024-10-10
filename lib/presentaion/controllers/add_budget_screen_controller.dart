import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddBudgetScreenController extends GetxController {
  Future<void> addBudget() async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc("xZE01HNdVzgOU0byjVSPMLCWDFR2")
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .set({
      "yearList": FieldValue.arrayUnion([
        {
          "2026": [
            {
              "Dec": [
                {
                  "01": [
                    {"cause": "Biriyani", "amount": 50}
                  ]
                }
              ]
            }
          ]
        }
      ])
    }, SetOptions(merge: true));

    print("--------------------------------------");
  }
}
