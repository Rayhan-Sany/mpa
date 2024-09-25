import 'package:flutter/material.dart';

import '../app/utils/app_color.dart';

class AppPrimaryAppBar extends StatelessWidget {
  const AppPrimaryAppBar({super.key});

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
        child: const Center(
          child: Text(
            "My Personal Assistant",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: AppColor.textColor),
          ),
        ),
      )
    ]);
  }
}
