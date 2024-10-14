import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/Data/model/single_day_data_model.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';

class GetdataController extends GetxController {
  RxBool isInProgress = false.obs;
  Future<DocumentSnapshot?> getAllDataForCurrentMonth() async {
    DocumentSnapshot? docSnapshot;
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
        docSnapshot = doc;
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return docSnapshot;
  }

  Future<Rx<FullMonthDataModel>?> getFullMonthData() async {
    isInProgress.value = true;

    final DocumentSnapshot? documentSnapshot =
        await getAllDataForCurrentMonth();
    if (documentSnapshot != null) {
      Rx<FullMonthDataModel>? fullMonthData;
      fullMonthData =
          FullMonthDataModel.fromDocumentSnapshot(documentSnapshot).obs;
      isInProgress.value = false;
      //update();

      return fullMonthData;
    }
    isInProgress.value = false;
    // update();
    return null;
  }

  Future<Rx<SingleDayDataModel>?> getSingleDayData() async {
    isInProgress.value = true;
    final DocumentSnapshot? documentSnapshot =
        await getAllDataForCurrentMonth();
    if (documentSnapshot != null) {
      Rx<SingleDayDataModel> TodaysData =
          SingleDayDataModel.fromDocumentSnapshot(documentSnapshot).obs;
      isInProgress.value = false;
      return TodaysData;
    }
    isInProgress.value = false;
    return null;
  }
}
