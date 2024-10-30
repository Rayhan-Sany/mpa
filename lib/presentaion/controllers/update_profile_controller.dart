import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';

class UpdateProfileController extends GetxController {
  RxBool isInProgress = false.obs;
  File? profileImageFile;
  Rx<UserDetails>? userDetails;
  RxBool isPhotoSelected = false.obs;
  @override
  onInit() {
    super.onInit();
    getUserDetailsFromLocalStorage();
  }

  Future<void> getUserDetailsFromLocalStorage() async {
    var temp = await LocalStorageController.getLocalUserDetails();
    userDetails = temp.obs;
  }

  Future<void> updateProfile(UserDetails updatedUserDetails) async {
    isInProgress.value = true;
    final firestore = FirebaseFirestore.instance;

    final docRef = firestore.collection("users").doc(userDetails?.value.uid);
    String profilePhotoUrl = await uploadProfileImage(updatedUserDetails.uid) ??
        AssetsPath.defaultProfileImageUrl;

    updatedUserDetails.profilePhotoUrl = profilePhotoUrl;

    Map<String, dynamic> updatedUserData = updatedUserDetails.toMap();
    docRef.update(updatedUserData).then((value) async {
      print("SuccessFully Updated");
      UserDetails? updatedUserDetailsTemp = await Get.find<UserController>()
          .getUserDetails(userDetails?.value.uid);
      await LocalStorageController.storeUserDetails(updatedUserDetailsTemp);
      Get.back();
    }, //print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));

    isInProgress.value = false;
  }

  Future<String?> uploadProfileImage(String uid) async {
    if (profileImageFile != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(uid).child("profileImage");
      String fileName = "$uid.jpg";
      final spaceRef = imagesRef.child(fileName);

      try {
        await spaceRef.putFile(profileImageFile!);
        final storageRef =
            FirebaseStorage.instance.ref("$uid/profileImage/$uid.jpg");
        final profilePhotoUrl = await storageRef.getDownloadURL();
        return profilePhotoUrl;
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
      profileImageFile = File(result.files.single.path!);
      isPhotoSelected.value = true;
    } else {
      // User canceled the picker
      print("Can not pick a file error");
    }
  }
}
