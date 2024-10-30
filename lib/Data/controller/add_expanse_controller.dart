import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/models/current_date_time_return_model.dart';
import 'package:mpa/presentaion/models/monthly_data_model.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class AddExpnseController extends GetxController {
  RxBool inProgress = false.obs;
  File? expanseImageFile;
  RxBool isPhotoSelected = false.obs;

  Future<void> addExpanse(
      {required String amount,
      required String expanseCause,
      String? imageUrl}) async {
    inProgress.value = true;
    String uid = UserController.userDetails!.uid;
    MonthlyDataModel? monthlyData;
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("users")
        .doc(uid)
        .collection("ExpanseData")
        .doc("ExpanseHistory")
        .collection("Years")
        .doc(CurrentDateTimeReturnModel.year);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        monthlyData = MonthlyDataModel.fromDocumentSnapshot(doc);
      },
      onError: (e) => print("Error getting document: $e"),
    );

    String expanseImageUrl = await uploadExpanseImage(uid, expanseCause) ??
        AssetsPath.defaultProfileImageUrl;

    if (imageUrl != null) {
      expanseImageUrl = imageUrl;
    }

    Map<String, dynamic> newExpanse = {
      "ExpanseCause": expanseCause,
      "ExpanseAmount": amount,
      "ExpanseImageUrl": expanseImageUrl,
      "AddedAt": DateTime.now()
    };

    if (monthlyData != null) {
      print("------------------------------------");
      print(monthlyData?.dayList);
      if (monthlyData?.dayList.last.keys.toString() !=
          "(Day-${CurrentDateTimeReturnModel.day})") {
        monthlyData?.dayList.add({
          "Day-${CurrentDateTimeReturnModel.day}": {
            "Expanses": [],
            "BudgetAdded": []
          }
        });
        print("-----------------------------Day add korte hobe");
      }
      monthlyData
          ?.dayList.last?["Day-${CurrentDateTimeReturnModel.day}"]?["Expanses"]
          .add(newExpanse);
      print(monthlyData?.dayList);
    }

    docRef.update({
      "Months": [
        {CurrentDateTimeReturnModel.month: monthlyData?.dayList}
      ]
    }).then((value) {
      AppSnackbar.showAppSnackbar(
          title: "Successful", subtitle: "Add Expanse Successfully");
    },
        onError: (e) => AppSnackbar.showAppSnackbar(
            title: "Add Exapanse Failed", subtitle: "Failed :$e"));
    inProgress.value = false;
  }

  Future<String?> uploadExpanseImage(String uid, String expanseCause) async {
    if (expanseImageFile != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(uid).child("expanseImage");
      String fileName = "$expanseCause.jpg";
      final spaceRef = imagesRef.child(fileName);

      try {
        await spaceRef.putFile(expanseImageFile!);
        final storageRef =
            FirebaseStorage.instance.ref("$uid/expanseImage/$expanseCause.jpg");
        final expansePhotoUrl = await storageRef.getDownloadURL();
        return expansePhotoUrl;
      } on FirebaseException catch (e) {
        print(e.toString());
        // ...
      }
    } else {
      print("Image Not Found To Uplaod");
    }
    return null;
  }

  Future<void> onClickCircularAvatarButton() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      expanseImageFile = File(result.files.single.path!);
      isPhotoSelected.value = true;
    } else {
      // User canceled the picker
      print("Can not pick a file error");
    }
  }
}
