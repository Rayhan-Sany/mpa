import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/model/user_details_data_model.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/update_profile_controller.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';
import 'package:mpa/widgets/bottom_nav_bar.dart';

class UpdateProfileScreen extends StatelessWidget {
  final UserDetails userDetails;
  const UpdateProfileScreen({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailTEController =
        TextEditingController(text: userDetails.email);
    final TextEditingController nameTEController =
        TextEditingController(text: userDetails.name);
    return Scaffold(
      body: Column(
        children: [
          const AppPrimaryAppBar(isAppbarWithButton: false),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Profile ",
                      style: AppFontStyles.playfairDisplay700S30),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            final updateProfileController =
                                Get.find<UpdateProfileController>();
                            updateProfileController.onClickProfileAvatar();
                          },
                          child: Obx(() => CircleAvatar(
                                backgroundImage: getProfileAvatarBgImage(),
                                radius: 32,
                              ))),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  profileUpdateForm(nameTEController, emailTEController),
                ],
              ),
            ),
          )),
          const BottomNavBar()
        ],
      ),
    );
  }

  dynamic getProfileAvatarBgImage() {
    final updateProfileController = Get.find<UpdateProfileController>();
    if (updateProfileController.isPhotoSelected.value) {
      return FileImage(updateProfileController.profileImageFile!);
    } else {
      return NetworkImage(userDetails.profilePhotoUrl);
    }
  }

  Form profileUpdateForm(TextEditingController nameTEController,
      TextEditingController emailTEController) {
    return Form(
        child: Column(
      children: [
        TextFormField(
          controller: nameTEController,
          decoration: const InputDecoration(
              label: Text("Name"),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailTEController,
          enabled: false,
          decoration: const InputDecoration(
              label: Text("Email"),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            onClickUploadButton(emailTEController.text.toString().trim(),
                nameTEController.text);
          },
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.maxFinite, 40)),
          child: Obx(() {
            if (Get.find<UpdateProfileController>().isInProgress.value) {
              return const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(color: AppColor.textColor));
            } else {
              return const Text("Update");
            }
          }),
        )
      ],
    ));
  }

  Future<void> onClickUploadButton(String email, String name) async {
    UpdateProfileController updateProfileController =
        Get.find<UpdateProfileController>();
    final updatedUserDetails = UserDetails(
        name: name,
        email: email,
        uid: userDetails.uid,
        profilePhotoUrl: userDetails.profilePhotoUrl);
    updateProfileController.updateProfile(updatedUserDetails);
  }
}
