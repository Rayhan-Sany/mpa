import 'package:flutter/material.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/widgets/profile_avatar_button_widget.dart';

class AppPrimaryAppBar extends StatelessWidget {
  final bool isAppbarWithButton;
  const AppPrimaryAppBar({super.key, required this.isAppbarWithButton});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.45,
        decoration: const BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: isAppbarWithButton
                    ? Row(
                        children: [
                          Builder(builder: (context) {
                            return IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: const Icon(
                                  Icons.menu,
                                  color: AppColor.textColor,
                                  size: 35,
                                ));
                          }),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: ProfileAvatarButton(radius: 20),
                          )
                        ],
                      )
                    : const SizedBox(
                        height: 20,
                      ),
              ),
              const Text(
                "My Personal Assistant",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textColor),
              ),
              const Spacer()
            ],
          ),
        ),
      )
    ]);
  }
}
