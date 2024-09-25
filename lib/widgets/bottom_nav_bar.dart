import 'package:flutter/material.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';

import '../app/utils/app_color.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Center(
        child: FittedBox(
          child: Card(
            color: AppColor.primaryColor,
            surfaceTintColor: AppColor.primaryColor,
            elevation: 10,
            child: SizedBox(
                height: 48, width: 54, child: Image.asset(AssetsPath.homeIcon)),
          ),
        ),
      ),
    );
  }
}
