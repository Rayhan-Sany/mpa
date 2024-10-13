import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/full_month_data_model.dart';
import 'package:mpa/Data/model/single_day_data_model.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';

class GetdataController extends GetxController {
  bool isInProgress = false;
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

  Future<FullMonthDataModel?> getFullMonthData() async {
    isInProgress = true;
    update();
    final DocumentSnapshot? documentSnapshot =
        await getAllDataForCurrentMonth();
    if (documentSnapshot != null) {
      FullMonthDataModel fullMonthData =
          FullMonthDataModel.fromDocumentSnapshot(documentSnapshot);
      isInProgress = false;
      update();
      return fullMonthData;
    }
    isInProgress = false;
    update();
    return null;
  }

  Future<SingleDayDataModel?> getSingleDayData() async {
    final DocumentSnapshot? documentSnapshot =
        await getAllDataForCurrentMonth();
    if (documentSnapshot != null) {
      SingleDayDataModel TodaysData =
          SingleDayDataModel.fromDocumentSnapshot(documentSnapshot);
      return TodaysData;
    }
    return null;
  }
}
