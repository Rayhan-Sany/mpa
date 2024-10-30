import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/presentaion/controllers/local_storage_controller.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/presentaion/ui/screens/update_profile_screen.dart';

class ProfileAvatarButton extends StatelessWidget {
  final double radius;
  const ProfileAvatarButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => moveToUpdateProfileScreen(),
        child: CircleAvatar(
          backgroundImage: getAvatarBackgroundImage(),
          radius: radius,
        ));
  }

  dynamic getAvatarBackgroundImage() {
    String profilePhotoUrl = UserController.userDetails!.profilePhotoUrl;
    return NetworkImage(profilePhotoUrl);
  }

  Future<UserDetails> getUserDetails() async {
    UserDetails userDetails =
        await LocalStorageController.getLocalUserDetails();

    return userDetails;
  }

  void moveToUpdateProfileScreen() async {
    UserDetails userDetails;
    userDetails = await getUserDetails();
    Get.to(() => UpdateProfileScreen(userDetails: userDetails));
  }
}
