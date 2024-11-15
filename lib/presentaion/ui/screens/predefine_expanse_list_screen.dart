import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/controllers/predefinelist_screen_controller.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/app_primary_appbar.dart';

class PredefineExpanseListScreen extends StatelessWidget {
  const PredefineExpanseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController expanseCauseTEController =
        TextEditingController();
    final TextEditingController amountTEController = TextEditingController();
    final predefineExpanseListController =
        Get.find<PredefineListScreenController>();
    return Scaffold(
      floatingActionButton: floatingActionButton(
          context,
          predefineExpanseListController,
          expanseCauseTEController,
          amountTEController),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPrimaryAppBar(isAppbarWithButton: false),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Mostly Uses Expanses",
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          Obx(() {
            return predefineExpanseListController
                        .predefineExpanseList.isEmpty &&
                    predefineExpanseListController.isInProgress.isFalse
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 150),
                      Text(
                        "Empty",
                        style: AppFontStyles.playfairDisplay600S20.copyWith(
                          color: AppColor.primaryColor.withOpacity(0.75),
                        ),
                      ),
                      const Row()
                    ],
                  )
                : showPredefineExpanseList(
                    context, predefineExpanseListController);
          })
        ],
      ),
    );
  }

  FloatingActionButton floatingActionButton(
      BuildContext context,
      PredefineListScreenController predefineExpanseListController,
      TextEditingController expanseCauseTEController,
      TextEditingController amountTEController) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Column(
              children: [
                Text("Add Expanse", style: AppFontStyles.playfairDisplay700S30),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () =>
                      predefineExpanseListController.onClickProfileAvatar(),
                  child: Obx(
                    () {
                      return CircleAvatar(
                          radius: 30, backgroundImage: getAvatarBgImage());
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: expanseCauseTEController,
                  decoration: const InputDecoration(
                      hintText: "Expanse Cause",
                      contentPadding: EdgeInsets.only(left: 10)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountTEController,
                  decoration: const InputDecoration(
                      hintText: "Amount",
                      contentPadding: EdgeInsets.only(left: 10)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () {
                  predefineExpanseListController.addNewPredefineExpanse(
                      expanseCauseTEController.text.toString(),
                      amountTEController.text.toString().trim());
                  Navigator.pop(context);
                }, child: Obx(
                  () {
                    return predefineExpanseListController.isInProgress.value
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                color: AppColor.textColor))
                        : const Text("Add");
                  },
                ))
              ],
            ),
          ),
        );
      },
      backgroundColor: AppColor.primaryColor,
      foregroundColor: AppColor.textColor,
      child: const Icon(Icons.add),
    );
  }

  dynamic getAvatarBgImage() {
    if (Get.find<PredefineListScreenController>().isPhotoSelected.value) {
      return FileImage(Get.find<PredefineListScreenController>().expanseImage!);
    } else {
      return AssetImage(AssetsPath.expanseLogo);
    }
  }

  Widget showPredefineExpanseList(BuildContext context,
      PredefineListScreenController predefineExpanseListController) {
    return Obx(() {
      return Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            onTap: () {
              addExpanseAlertDialog(
                  predefineExpanseListController.predefineExpanseList[index]
                          ["ExpanseCause"] ??
                      "N/A",
                  predefineExpanseListController.predefineExpanseList[index]
                      ["ExpanseAmount"],
                  predefineExpanseListController.predefineExpanseList[index]
                      ["ExpansePhotoUrl"],
                  context);
            },
            leading: SizedBox(
              height: 30,
              width: 30,
              child: Image.network(predefineExpanseListController
                      .predefineExpanseList[index]["ExpansePhotoUrl"] ??
                  AssetsPath.defaultProfileImageUrl),
            ),
            title: Text(
                predefineExpanseListController.predefineExpanseList[index]
                        ["ExpanseCause"] ??
                    "",
                style: const TextStyle(fontSize: 25)),
            trailing: Text(
                predefineExpanseListController.predefineExpanseList[index]
                        ["ExpanseAmount"] ??
                    "",
                style: const TextStyle(
                    fontSize: 20, color: AppColor.primaryColor)),
          ),
        ),
        itemCount: predefineExpanseListController.predefineExpanseList.length,
        shrinkWrap: true,
      ));
    });
  }

  void addExpanseAlertDialog(String expanseCause, String amount,
      String imageUrl, BuildContext context) {
    TextEditingController expanseCauseTEController =
        TextEditingController(text: expanseCause);
    TextEditingController amountTEController =
        TextEditingController(text: amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text("Add Expanse", style: AppFontStyles.playfairDisplay700S30),
            const SizedBox(
              height: 16,
            ),
            CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: expanseCauseTEController,
              decoration: const InputDecoration(
                  hintText: "Expanse Cause",
                  contentPadding: EdgeInsets.only(left: 10)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountTEController,
              decoration: const InputDecoration(
                  hintText: "Amount",
                  contentPadding: EdgeInsets.only(left: 10)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {
              Get.find<AddExpnseController>().addExpanse(
                  amount: amountTEController.text.toString().trim(),
                  expanseCause: expanseCauseTEController.text.toString(),
                  imageUrl: imageUrl);
              Navigator.pop(context);
            }, child: Obx(() {
              return Get.find<AddExpnseController>().inProgress.value
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child:
                          CircularProgressIndicator(color: AppColor.textColor))
                  : const Text("Add");
            }))
          ],
        ),
      ),
    );
  }
}
