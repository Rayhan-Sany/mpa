import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpa/Data/controller/add_expanse_controller.dart';
import 'package:mpa/app/utils/app_color.dart';
import 'package:mpa/app/utils/app_font_styles.dart';
import 'package:mpa/presentaion/ui/utils/assets_path.dart';
import 'package:mpa/widgets/appPrimaryAppBar.dart';

class PredefineExpanseListScreen extends StatelessWidget {
  const PredefineExpanseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPrimaryAppBar(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Mostly Uses Expanses",
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          showPredefineExpanseList(context),
        ],
      ),
    );
  }

  Expanded showPredefineExpanseList(BuildContext context) {
    List predefinedExpanseList = [
      {"name": "Bicycle", "Cost": "482"},
      {"name": "Pen", "Cost": "87"},
      {"name": "Phone", "Cost": "999"},
      {"name": "Chair", "Cost": "150"},
      {"name": "Laptop", "Cost": "620"},
      {"name": "Backpack", "Cost": "240"},
      {"name": "Watch", "Cost": "300"},
      {"name": "Shoes", "Cost": "75"},
      {"name": "Book", "Cost": "50"},
      {"name": "Headphones", "Cost": "230"}
    ];

    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          onTap: () {
            addExpanseAlertDialog(predefinedExpanseList[index]["name"],
                predefinedExpanseList[index]["Cost"], context);
          },
          leading: SizedBox(
            height: 30,
            width: 30,
            child: Image.asset(AssetsPath.notesLogo),
          ),
          title: Text(predefinedExpanseList[index]["name"],
              style: TextStyle(fontSize: 25)),
          trailing: Text(predefinedExpanseList[index]["Cost"],
              style: TextStyle(fontSize: 20, color: AppColor.primaryColor)),
        ),
      ),
      itemCount: predefinedExpanseList.length,
      shrinkWrap: true,
    ));
  }

  void addExpanseAlertDialog(
      String expanseCause, String amount, BuildContext context) {
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
                  amountTEController.text.toString().trim(),
                  expanseCauseTEController.text.toString());
              Navigator.pop(context);
            }, child:
                GetBuilder<AddExpnseController>(builder: (addExpnseController) {
              return addExpnseController.inProgress
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
