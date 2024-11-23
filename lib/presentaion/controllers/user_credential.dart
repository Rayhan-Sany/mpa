import 'package:get/get.dart';
import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';

class UserCredentials extends GetxController {
  static UserDetails? userDetails;
  @override
  void onInit() {
    super.onInit();
    getUserCredentialFromLocalStorage();
  }

  static void getUserCredentialFromLocalStorage() async {
    userDetails = await LocalStorageController.getLocalUserDetails();
  }
}
