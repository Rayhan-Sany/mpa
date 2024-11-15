import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_snackbar.dart';

class EducationScreenController extends GetxController {
  RxString currentPath = "Education".obs;
  RxString pathWithIndicator = "Education".obs;
  RxList pathContent = [].obs;
  RxList<String> pathStack = ["Education"].obs;
  RxBool canPop = true.obs;
  RxBool isInProgress = false.obs;
  Rx<File>? file;
  RxBool isFileSelected = false.obs;
  RxBool isFileUploadingIsInProgress = false.obs;
  @override
  void onInit() async {
    super.onInit();
    await getEducationFileAndFolders("Education");
  }

  Future<void> uploadFile(String fullPath) async {
    isFileUploadingIsInProgress.value = true;
    try {
      final fileRef = FirebaseStorage.instance.ref(fullPath);

      if (file?.value != null) {
        final readyFile = file!.value.readAsBytesSync();
        await fileRef.putData(readyFile).onError((e, stackTrace) {
          throw e.toString();
        });
        isFileSelected.value = false;
        file?.value.delete();
        AppSnackbar.showAppSnackbar(
            title: "Successfull", subtitle: "File Uploaded Successfully");
      }
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Unsuccessfull",
          subtitle: "File Upload Error ${e.toString()}");
      print(e.toString());
    }
    isFileUploadingIsInProgress.value = false;
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!).obs;
      isFileSelected.value = true;
    } else {
      // User canceled the picker
      print("Can not pick a file error");
    }
  }

  Future<void> deleteFolder({required folderPath, int? index}) async {
    try {
      final folderRef = FirebaseStorage.instance.ref(folderPath);

      final ListResult result = await folderRef.listAll();

      for (Reference fileRef in result.items) {
        await fileRef.delete();
        print('Deleted file: ${fileRef.fullPath}');
      }

      for (Reference dirRef in result.prefixes) {
        await deleteFolder(folderPath: dirRef.fullPath);
      }

      if (index != null) {
        pathContent.removeAt(index);
      }
      AppSnackbar.showAppSnackbar(
          title: "Successfull", subtitle: "Deleted Successfully");

      print('Folder $folderPath deleted successfully.');
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Unsuccessfull", subtitle: "Error ${e.toString()}");
      print('Error deleting folder: $e');
    }
  }

  Future<void> deleteFile(String filePath, int index) async {
    try {
      final fileRef = FirebaseStorage.instance.ref(filePath);

      fileRef.delete().onError((e, stackTrace) {
        AppSnackbar.showAppSnackbar(
            title: "Unsuccessfull", subtitle: "Error ${e.toString()}");
        print('Error deleting file: $e');
        throw e.toString();
      });
      AppSnackbar.showAppSnackbar(
          title: "Successfull", subtitle: "Deleted Successfully");
      pathContent.removeAt(index);
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Unsuccessfull", subtitle: "Error ${e.toString()}");
      print('Error deleting folder: $e');
    }
  }

  Future<void> getEducationFileAndFolders(String path) async {
    isInProgress.value = true;
    final storageRef = FirebaseStorage.instance.ref(path);
    pathContent.clear();
    await storageRef.list().then((listResult) {
      for (var item in listResult.prefixes) {
        print(item.name);
        Map<String, dynamic> tempContent = {
          "name": item.name,
          "isFolder": true
        };
        pathContent.add(tempContent);
      }
      for (var item in listResult.items) {
        print(item.name);
        if (item.name == "placeholder.png") continue;
        Map<String, dynamic> tempContent = {
          "name": item.name,
          "isFolder": false
        };
        pathContent.add(tempContent);
      }
      isInProgress.value = false;
    }, onError: (e) {
      print(e.toString());
      print("----------------------------");
    });
  }

  Future<void> createEmptyFolder(String folderName) async {
    isInProgress.value = true;
    final storageRef = FirebaseStorage.instance
        .ref(currentPath.value)
        .child("$folderName/placeholder.png");

    bool isAlreadyFolderNameExist = false;
    for (var item in pathContent) {
      if (item["name"] == folderName && item["isFolder"] == true) {
        isAlreadyFolderNameExist = true;
      }
    }
    if (isAlreadyFolderNameExist) {
      AppSnackbar.showAppSnackbar(
          title: "Error",
          subtitle: "Folder Name Already Exist",
          isErrorSnak: true);
      return;
    }
    try {
      ByteData byteData = await rootBundle.load(AssetsPath.homeIcon);
      Uint8List tempFile = byteData.buffer.asUint8List();

      // Upload the empty file as a placeholder
      await storageRef.putData(tempFile);
      print("Folder created successfully: $folderName");
      Map<String, dynamic> tempContent = {"name": folderName, "isFolder": true};
      pathContent.add(tempContent);

      AppSnackbar.showAppSnackbar(
        title: "Successfull",
        subtitle: "Folder Created Successfully",
      );
    } catch (e) {
      AppSnackbar.showAppSnackbar(
          title: "Error", subtitle: "$e", isErrorSnak: true);
      print("Error creating folder: $e");
    }
    isInProgress.value = false;
  }
}
