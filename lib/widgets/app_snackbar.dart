import 'package:get/get.dart';
import 'package:mpa/app/utils/app_color.dart';

class AppSnackbar {
  static showAppSnackbar(
      {required String title,
      required String subtitle,
      bool isErrorSnak = false}) {
    return Get.snackbar(
      title,
      subtitle,
      backgroundColor:
          isErrorSnak ? AppColor.errorColor : AppColor.successColor,
      colorText: AppColor.textColor,
    );
  }
}
