import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class PredefineListScreenController extends GetxController {
  RxBool isInProgress = false.obs;
  RxBool isPhotoSelected = false.obs;
  RxList predefineExpanseList = [].obs;
  File? expanseImage;
  Rx<UserDetails>? userDetails;

  @override
  void onInit() async {
    super.onInit();
    await getPredefinedExpanseList();
  }

  Future<void> getPredefinedExpanseList() async {
    isInProgress.value = true;
    await getUserDetailsFromLocalStorage();

    final firestore = FirebaseFirestore.instance;

    final docRef = firestore
        .collection("users")
        .doc(userDetails?.value.uid)
        .collection("ExpanseData")
        .doc("PredefineExpanseList");

    try {
      await docRef.get().then((DocumentSnapshot doc) {
        DocumentSnapshot docSnapshot = doc;
        final data = docSnapshot.data() as Map<String, dynamic>;

        predefineExpanseList.value = data["PredefineExpanseList"];
        print(data);
      }, onError: (e) => print("Error getting document: $e"));
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Error", subtitle: "Erorr:${e.toString()}");
    }
    isInProgress.value = false;
  }

  Future<void> getUserDetailsFromLocalStorage() async {
    var temp = await LocalStorageController.getLocalUserDetails();
    userDetails = temp.obs;
  }

  Future<void> addNewPredefineExpanse(
      String expanseCause, String amount) async {
    isInProgress.value = true;

    // await getUserDetailsFromLocalStorage();

    final firestore = FirebaseFirestore.instance;

    final docRef = firestore
        .collection("users")
        .doc(userDetails?.value.uid)
        .collection("ExpanseData")
        .doc("PredefineExpanseList");
    String expansePhotoUrl =
        await uploadExpanseImage(userDetails!.value.uid, expanseCause) ??
            AssetsPath.defaultProfileImageUrl;

    predefineExpanseList.add({
      "ExpansePhotoUrl": expansePhotoUrl,
      "ExpanseCause": expanseCause,
      "ExpanseAmount": amount
    });

    final predefineExpanseData = <String, dynamic>{
      "PredefineExpanseList": predefineExpanseList,
    };

    docRef.set(predefineExpanseData).then((valu) {
      AppSnackbar.showAppSnackbar(
          title: "Added Successfully",
          subtitle: "predefine Expanse Added Successfully");
    }, onError: (e) {
      AppSnackbar.showAppSnackbar(
          title: "Add predefine Expanse failed",
          subtitle: "Failed:$e",
          isErrorSnak: true);
    });

    isInProgress.value = false;
  }

  Future<String?> uploadExpanseImage(String uid, String expanseCause) async {
    if (expanseImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(uid).child("predefineExpanseImages");
      String fileName = "$expanseCause.jpg";
      final spaceRef = imagesRef.child(fileName);

      try {
        await spaceRef.putFile(expanseImage!);
        final storageRef = FirebaseStorage.instance
            .ref("$uid/predefineExpanseImages/$expanseCause.jpg");
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

  Future<void> onClickProfileAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      expanseImage = File(result.files.single.path!);
      isPhotoSelected.value = true;
    } else {
      // User canceled the picker
      print("Can not pick a file error");
    }
  }
}
