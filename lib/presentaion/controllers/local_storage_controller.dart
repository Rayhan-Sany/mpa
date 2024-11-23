import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/widgets/app_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageController {
  static Future<void> storeUserDetails(UserDetails? userDetails) async {
    final storage = await SharedPreferences.getInstance();
    if (userDetails != null) {
      await storage.setString('name', userDetails.name);
      await storage.setString('email', userDetails.email);
      await storage.setString('profilePhotoUrl', userDetails.profilePhotoUrl);
      await storage.setString('uid', userDetails.uid);
    } else {
      AppSnackbar.showAppSnackbar(
          title: "Local Storage Failed ",
          subtitle: "Failed to Store Data in localStorage",
          isErrorSnak: true);
    }
  }

  static Future<void> deleteUserDetails() async {
    final storage = await SharedPreferences.getInstance();
    storage.clear();
  }

  static Future<UserDetails> getLocalUserDetails() async {
    final storage = await SharedPreferences.getInstance();
    String? name = storage.getString("name");
    String? email = storage.getString("email");
    String? photoUrl = storage.getString("profilePhotoUrl");
    String? uid = storage.getString("uid");
    UserDetails userDetails = UserDetails(
        name: name ?? "",
        email: email ?? "",
        uid: uid ?? "",
        profilePhotoUrl: photoUrl ?? "");
    return userDetails;
  }

  static Future<String> getUid() async {
    final storage = await SharedPreferences.getInstance();
    String? uid = storage.getString("uid");
    return uid ?? "";
  }
}
