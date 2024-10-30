import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/signout_controller.dart';
import 'package:mpa/presentaion/controllers/user_controller.dart';
import 'package:mpa/widgets/profile_avatar_button_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: AppColor.primaryColor,
      width: 225,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SafeArea(
          child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileAvatarButton(radius: 32),
                const Spacer(),
                Text(
                  UserController.userDetails?.name ?? "UnKnown",
                  style: AppFontStyles.playfairDisplay600S20,
                ),
                Text(
                  UserController.userDetails?.email ?? "UnKnown",
                  style: AppFontStyles.playfairDisplay400S15,
                ),
              ],
            ),
          ),
          getDrawerOptionList(
              onPress: signOut, icon: Icons.logout, titleText: "LogOut"),
          getDrawerOptionList(
              onPress: () {}, icon: Icons.help, titleText: "Help and feedback"),
        ],
      )),
    );
  }

  void signOut() {
    Get.find<SignOutController>().signOut();
  }

  ListTile getDrawerOptionList(
      {required Function()? onPress,
      required IconData icon,
      required String titleText}) {
    return ListTile(
      selectedTileColor: AppColor.primaryColor,
      onTap: onPress,
      title: Text(titleText),
      titleTextStyle: AppFontStyles.playfairDisplay400S15,
      leading: Icon(
        icon,
        color: AppColor.primaryColor,
      ),
    );
  }
}
